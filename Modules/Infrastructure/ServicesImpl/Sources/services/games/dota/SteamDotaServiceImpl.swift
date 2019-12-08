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

private let synchronizationCooldown: TimeInterval = 60.0/*sec*/ * 2.0/*min*/
private let synchronizationDetailsCooldown: TimeInterval = 60.0/*sec*/ * 5.0/*min*/
private let twoWeeksTimeInterval: TimeInterval = 60.0 * 60.0 * 24.0 * 14.0 * 25.0 // FIXME: Убрать 25 - к сожалению у меня нет друзей активно играющих в доту

/// Сам жеский класс... ибо в нем синхронизация игр, причем с учетом, что в любой момент пользователь может зайти заново...
final class SteamDotaServiceImpl: SteamDotaService
{
    let gameId: SteamGameID = 570

    private let network: SteamDotaNetwork
    private let storage: SteamDotaStorage
    private let synchronizers: SteamDotaSynchronizers

    init(network: SteamDotaNetwork,
         storage: SteamDotaStorage,
         synchronizers: SteamDotaSynchronizers) {
        self.network = network
        self.storage = storage
        self.synchronizers = synchronizers
    }

    func matchesInLast2weeks(for accountId: AccountID, completion: @escaping (SteamDotaCompletion<Int>) -> Void) {
        synchronizers.historySynchronizer(for: accountId).synchronize { [storage] result in
            // TODO: Пока парится не буду. Конечно в идеале, подобные фильтры надо в БД переносить.
            /// получаем все игры за последние две недели
            let last2WeeksMatches = storage.fetchMatches(for: accountId).filter { $0.startTime.timeIntervalSinceNow + twoWeeksTimeInterval > 0 }
            DispatchQueue.main.async {
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
        }
    }

    func lastMatch(for accountId: AccountID, completion: @escaping (SteamDotaCompletion<DotaMatchDetails?>) -> Void) {
        synchronizers.historySynchronizer(for: accountId).synchronize { [storage, weak self] result in
            guard let lastMatch = storage.fetchMatches(for: accountId).max(by: { $0.startTime < $1.startTime }) else {
                /// Если игр нет, то или их вообще нет, или не удалось синхронизировать историю
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        completion(.actual(nil))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                return
            }

            self?.synchronizers.detailsSynchronizer(for: accountId).synchronize { result -> Bool in
                switch result {
                case .first:
                    // Первый подготовительный запрос - на нем нужно убедиться, что данные есть или нету
                    guard let details = storage.fetchDetails(for: accountId, matchId: lastMatch.matchId) else {
                        return false
                    }

                    DispatchQueue.main.async {
                        completion(.actual(details))
                    }

                case .response(let matchId, let result):
                    // Пришли данные, которые нас не интерисуют
                    if matchId != lastMatch.matchId {
                        return false
                    }

                    DispatchQueue.main.async {
                        switch result {
                        case .success(let details):
                            assert(details.matchId == matchId, "returned details match id not equal requested match id")
                            completion(.actual(details))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }

                return true
            }
        }
    }

    func detailsInLast2weeks(for accountId: AccountID, completion: @escaping (SteamDotaCompletion<[DotaMatchDetails]>) -> Void) {
        detailsFromIds(idsProvider: { [storage] in
            let last2WeekMatches = storage.fetchMatches(for: accountId).filter { $0.startTime.timeIntervalSinceNow + twoWeeksTimeInterval > 0 }
            return Set(last2WeekMatches.map { $0.matchId })
        }, accountId: accountId, completion: completion)
    }

    func detailsInPeriod(for accountId: AccountID, from: Date, to: Date, completion: @escaping (SteamDotaCompletion<[DotaMatchDetails]>) -> Void) {
        detailsFromIds(idsProvider: { [storage] in
            let matchesInPeriod = storage.fetchMatches(for: accountId).filter { from <= $0.startTime && $0.startTime <= to }
            return Set(matchesInPeriod.map { $0.matchId })
        }, accountId: accountId, completion: completion)
    }

    func getHero(for heroId: DotaHeroID, loc: SteamLocalization, completion: @escaping (SteamDotaCompletion<DotaHero?>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [storage, network] in
            let heroesResult = storage.fetchHeroes(loc: loc)

            var notReleventHero: DotaHero?
            switch heroesResult {
            case .done(let heroes):
                if let hero = heroes.first(where: { $0.id == heroId }) {
                    DispatchQueue.main.async {
                        completion(.actual(hero))
                    }
                    return
                }
            case .noRelevant(let heroes):
                notReleventHero = heroes.first(where: { $0.id == heroId })
            case .none:
                break
            }

            network.requestHeroes(loc: loc) { result in
                switch result {
                case .success(let heroes):
                    storage.put(heroes: heroes, loc: loc)
                    let optHero = heroes.first(where: { $0.id == heroId })
                    DispatchQueue.main.async {
                        completion(.actual(optHero))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        if let hero = notReleventHero {
                            completion(.notActual(hero))
                            return
                        }
                        completion(.failure(error))
                    }
                }
            }
        }

    }

    func popularHero(for accountId: AccountID, completion: @escaping (SteamDotaCompletion<DotaPopularHero>) -> Void) {

    }

    /// Грузит/отдает все детали из списка, который будет создан с помощью closure
    private func detailsFromIds(idsProvider: @escaping () -> Set<DotaMatchID>,
                                accountId: AccountID,
                                completion: @escaping (SteamDotaCompletion<[DotaMatchDetails]>) -> Void) {
        synchronizers.historySynchronizer(for: accountId).synchronize { [weak self, storage] result in
            // TODO: Пока парится не буду. Конечно в идеале, подобные фильтры надо в БД переносить.
            /// получаем все игры за последние две недели
            let matchIds = idsProvider()
            if matchIds.isEmpty {
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        completion(.actual([]))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                return
            }

            /// Для удобства будем вести счетчик всех нужных еще к загрузке деталей
            var needLoadDetails: Set<DotaMatchID> = matchIds
            var detailsList: [DotaMatchDetails] = []

            self?.synchronizers.detailsSynchronizer(for: accountId).synchronize { result -> Bool in
                switch result {
                case .first:
                    // Первый подготовительный запрос - на нем нужно убедиться, что все данные есть, а если нет, то запомнить нехватающих
                    detailsList = storage.fetchDetailsList(for: accountId).filter { matchIds.contains($0.matchId) }
                    if detailsList.count != matchIds.count {
                        needLoadDetails.subtract(detailsList.map { $0.matchId })
                        return false
                    }

                    DispatchQueue.main.async {
                        completion(.actual(detailsList))
                    }
                    return true

                case .response(let matchId, let result):
                    // Пришли данные, которые нас не интерисуют
                    if !needLoadDetails.contains(matchId) {
                        return false
                    }

                    if case .success(let details) = result {
                        detailsList.append(details)
                    }

                    needLoadDetails.remove(matchId)
                    if needLoadDetails.isEmpty {
                        DispatchQueue.main.async {
                            completion(.actual(detailsList))
                        }
                        return true
                    }

                    return false
                }
            }
        }
    }
}

