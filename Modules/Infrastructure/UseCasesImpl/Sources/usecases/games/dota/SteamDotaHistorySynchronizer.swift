//
//  SteamDotaHistorySynchronizer.swift
//  UseCasesImpl
//
//  Created by Alexander Ivlev on 04/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//


import Foundation
import Common
import Entities
import UseCases
import UseCasesContracts

private let synchronizationCooldown: TimeInterval = 60.0/*sec*/ * 2.0/*min*/

private let twoWeeksTimeInterval: TimeInterval = 60.0 * 60.0 * 24.0 * 14.0

final class SteamDotaHistorySynchronizer
{
    private var isSynchonization: Bool = false
    private var lastSynchonizationDate: Date = Date(timeIntervalSince1970: 0)
    private let synchronizationMonitor: NSObject = NSObject()
    private var waiters: [(Result<Void, ServiceError>) -> Void] = []

    private let network: SteamDotaNetwork
    private let storage: SteamDotaStorage

    private let accountId: AccountID

    init(network: SteamDotaNetwork, storage: SteamDotaStorage, accountId: AccountID) {
        self.network = network
        self.storage = storage
        self.accountId = accountId
    }

    func synchronize(completion: @escaping (Result<Void, ServiceError>) -> Void) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.notThreadSynchronize(completion: completion)
        }
    }

    private func notThreadSynchronize(completion: @escaping (Result<Void, ServiceError>) -> Void) {
        func prevalidate() -> Bool {
            objc_sync_enter(synchronizationMonitor)
            defer { objc_sync_exit(synchronizationMonitor) }
            /// Если мы и так синхронизируемся, то подписываемся на оповещение
            if isSynchonization {
                waiters.append(completion)
                return false
            }
            /// Если недавно была успешная синхронизация, то не имеет смысла запускать новую - за небольшой промежуток времени наврятли данные сильно поменялись
            if lastSynchonizationDate.timeIntervalSinceNow + synchronizationCooldown > 0 {
                completion(.success(()))
                return false
            }

            /// В противных случаях надо запустить синхронизацию.
            isSynchonization = true
            waiters.append(completion)

            return true
        }

        if !prevalidate() {
            return
        }

        let matches = storage.fetchMatches(for: accountId)
        /// Сервер вроде по startTime упорядочивает, по этому надо соблюдать способ сортировки его.
        let oldMatch = matches.min(by: { $0.startTime < $1.startTime })
        /// Если самая давняя сохраненная игра, ближе чем две недели, то стоит пересинхронизироваться - возможно в первый раз, загрузка прервалась на середине
        /// Да к сожалению это приведет к сетевой лишней нагрузке, зато данные будут точно верные.
        /// Для игроков у которых первая игра была не давно, будет выполнятся метод всегда - но у них всеравно игр мало.
        if let oldMatch = oldMatch, oldMatch.startTime.timeIntervalSinceNow + twoWeeksTimeInterval > 0 {
            recursiveSynchonizeHistory(from: nil, lastMatch: nil)
        } else {
            let lastMatch = matches.max(by: { $0.startTime < $1.startTime })
            recursiveSynchonizeHistory(from: nil, lastMatch: lastMatch)
        }
    }

    private func recursiveSynchonizeHistory(from: DotaMatch?, lastMatch: DotaMatch?) {
        /// Если БД пустое, то лучше сразуже запрашивать по многу, дабы бысрее подгрузить.
        /// Если же данные есть уже, то лучше запрашивать по маленьку, дабы трафик не сжирать
        let requestCount: UInt = nil == lastMatch ? 100 : 25

        /// Суть в том что выкачиваем или все данные, или данные до момента, пока не пересечемся со старыми данными (lastMatch).
        /// Максиум можем получить 500 игр, а столько за две недели наиграть нереал, поэтому все будет работать в любом случае.
        network.requestHistory(accountId: accountId, count: requestCount, heroId: nil, from: from?.matchId, completion: { [weak self] result in
            self?.processRequestHistoryResult(result, lastMatch: lastMatch)
        })
    }

    private func processRequestHistoryResult(_ result: DotaMatchHistoryResult, lastMatch: DotaMatch?) {
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
            recursiveSynchonizeHistory(from: nextFromMatch, lastMatch: lastMatch)

        case .failure(let error):
            notifyAndEndSynchonizeHistoryWaiter(.failure(error))
        }
    }

    private func notifyAndEndSynchonizeHistoryWaiter(_ result: Result<Void, ServiceError>) {
        objc_sync_enter(synchronizationMonitor)
        isSynchonization = false
        if case .success = result {
            lastSynchonizationDate = Date()
        }

        let waiters = self.waiters
        self.waiters.removeAll()
        objc_sync_exit(synchronizationMonitor)

        for waiter in waiters {
            waiter(result)
        }
    }
}
