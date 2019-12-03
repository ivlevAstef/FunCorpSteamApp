//
//  SteamDotaServiceImpl.swift
//  ServicesImpl
//
//  Created by Alexander Ivlev on 03/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

private let synchonizationCooldown: TimeInterval = 60.0/*sec*/ * 2.0/*min*/
private let twoWeeksTimeInterval: TimeInterval = 60.0 * 60.0 * 24.0 * 14.0 * 25.0 // FIXME: Убрать 25 - к сожалению у меня нет друзей активно играющих в доту

// TODO: Во всем классе делается одна помарка - accountId не меняется. Если он резко сменится, то синхронизация может не начаться.
final class SteamDotaServiceImpl: SteamDotaService
{
    let gameId: SteamGameID = 570

    private var isSynchonization: Bool = false
    private var lastSynchonizationDate: Date = Date(timeIntervalSince1970: 0)
    private var synchonizationMonitor: NSObject = NSObject()
    private var synchonizationWaiters: [(Result<Void, ServiceError>) -> Void] = []

    private let network: SteamDotaNetwork
    private let storage: SteamDotaStorage

    init(network: SteamDotaNetwork, storage: SteamDotaStorage) {
        self.network = network
        self.storage = storage
    }

    /// Возвращает сколько игр было сыграно за последние две недели
    func matchesInLast2weeks(for accountId: AccountID, completion: @escaping (SteamDotaCompletion<Int>) -> Void) {
        func processLast2weeks(storage: SteamDotaStorage, result: Result<Void, ServiceError>) {
            // TODO: Пока парится не буду. Конечно в идеале, подобные фильтры надо в БД переносить.
            /// получаем все игры за последние две недели
            let last2WeeksMatches = storage.fetchMatches(for: accountId).filter { $0.startTime.timeIntervalSinceNow + twoWeeksTimeInterval > 0 }
            switch result {
            case .success:
                completion(.actual(last2WeeksMatches.count))
            case .failure(let error):
                if last2WeeksMatches.isEmpty {
                    completion(.failure(error))
                } else {
                    completion(.notActual(last2WeeksMatches.count))
                }
            }
        }

        synchonizeHistory(for: accountId) { [storage] result in
            processLast2weeks(storage: storage, result: result)
        }
    }

    /// Возвращает информацию по последней сыгранной игре. nil если игр нет
    func lastMatch(for accountId: AccountID, completion: @escaping (SteamDotaCompletion<DotaMatchDetails?>) -> Void) {

    }

    /// Возвращает популярного героя, за последние 100 игр, или за две недели (в зависимости от того каких данных больше).
    func popularHero(for accountId: AccountID, completion: @escaping (SteamDotaCompletion<DotaPopularHero>) -> Void) {

    }

    // MARK: history synchonizer

    private func synchonizeHistory(for accountId: AccountID, completion: @escaping (Result<Void, ServiceError>) -> Void) {
        objc_sync_enter(synchonizationMonitor)
        /// Если мы и так синхронизируемся, то подписываемся на оповещение
        if isSynchonization {
            synchonizationWaiters.append(completion)
            return
        }
        /// Если недавно была успешная синхронизация, то не имеет смысла запускать новую - за небольшой промежуток времени наврятли данные сильно поменялись
        if lastSynchonizationDate.timeIntervalSinceNow + synchonizationCooldown > 0 {
            completion(.success(()))
            return
        }

        /// В противных случаях надо запустить синхронизацию.
        isSynchonization = true
        synchonizationWaiters.append(completion)
        objc_sync_exit(synchonizationMonitor)

        let matches = storage.fetchMatches(for: accountId)
        /// Сервер вроде по startTime упорядочивает, по этому надо соблюдать способ сортировки его.
        let oldMatch = matches.min(by: { $0.startTime < $1.startTime })
        /// Если самая давняя сохраненная игра, ближе чем две недели, то стоит пересинхронизироваться - возможно в первый раз, загрузка прервалась на середине
        /// Да к сожалению это приведет к сетевой лишней нагрузке, зато данные будут точно верные.
        /// Для игроков у которых первая игра была не давно, будет выполнятся метод всегда - но у них всеравно игр мало.
        if let oldMatch = oldMatch, oldMatch.startTime.timeIntervalSinceNow + twoWeeksTimeInterval > 0 {
            recursiveSynchonizeHistory(for: accountId, from: nil, lastMatch: nil)
        } else {
            let lastMatch = matches.max(by: { $0.startTime < $1.startTime })
            recursiveSynchonizeHistory(for: accountId, from: nil, lastMatch: lastMatch)
        }
    }

    private func recursiveSynchonizeHistory(for accountId: AccountID, from: DotaMatch?, lastMatch: DotaMatch?) {
        /// Если БД пустое, то лучше сразуже запрашивать по многу, дабы бысрее подгрузить.
        /// Если же данные есть уже, то лучше запрашивать по маленьку, дабы трафик не сжирать
        let requestCount: UInt = nil == lastMatch ? 100 : 25

        /// Суть в том что выкачиваем или все данные, или данные до момента, пока не пересечемся со старыми данными (lastMatch).
        /// Максиум можем получить 500 игр, а столько за две недели наиграть нереал, поэтому все будет работать в любом случае.
        self.network.requestHistory(accountId: accountId, count: requestCount, heroId: nil, from: from?.matchId, completion: { [weak self] result in
            self?.processRequestHistoryResult(result, accountId: accountId, lastMatch: lastMatch)
        })
    }

    private func processRequestHistoryResult(_ result: DotaMatchHistoryResult, accountId: AccountID, lastMatch: DotaMatch?) {
        switch result {
        case .success(let matches):
            storage.put(matches: matches, for: accountId)

            /// Если все ок, но при этом данных нет (ноль или одна последняя запись), то значит синхронизация закончилась - выкачали все что было
            guard let nextFromMatch = matches.last, matches.count > 1 else {
                notifyAndEndSynchonizeHistoryWaiter(.success(()))
                return
            }

            /// Если в загруженных данных есть пересечение с имеющимися, то значит синхронизация удалась - можно завершать
            if let lastMatch = lastMatch, matches.contains(where: { $0.matchId == lastMatch.matchId }) {
                notifyAndEndSynchonizeHistoryWaiter(.success(()))
                return
            }

            /// Иначе переходим на следующую страницу
            recursiveSynchonizeHistory(for: accountId, from: nextFromMatch, lastMatch: lastMatch)

        case .failure(let error):
            notifyAndEndSynchonizeHistoryWaiter(.failure(error))
        }
    }

    private func notifyAndEndSynchonizeHistoryWaiter(_ result: Result<Void, ServiceError>) {
        objc_sync_enter(synchonizationMonitor)
        isSynchonization = false
        if case .success = result {
            lastSynchonizationDate = Date()
        }

        let waiters = synchonizationWaiters
        synchonizationWaiters.removeAll()
        objc_sync_exit(synchonizationMonitor)

        for waiter in waiters {
            waiter(result)
        }
    }
}
