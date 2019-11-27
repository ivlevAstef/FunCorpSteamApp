//
//  SteamProfileGamesServiceImpl.swift
//  ServicesImpl
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

final class SteamProfileGamesServiceImpl: SteamProfileGamesService
{
    private lazy var universalGamesService = {
        UniversalServiceImpl(
            fetcher: { [unowned self] steamId in
                return self.fetchGames(by: steamId)
            },
            updater: { [unowned self] (steamId, completion) in
                self.updateGames(by: steamId, completion: completion)
            }
        )
    }()

    private struct SteamIdGameIdPair: Hashable { let steamId: SteamID; let gameId: SteamGameID; }
    private lazy var universalGameService = {
        UniversalServiceImpl<SteamProfileGameInfo, SteamIdGameIdPair>(
            fetcher: { [unowned self] pair in
                return self.fetchGame(by: pair.steamId, gameId: pair.gameId)
            },
            updater: { [unowned self] (pair, completion) in
                self.updateGame(by: pair.steamId, gameId: pair.gameId, completion: completion)
            }
        )
    }()

    private let network: SteamProfileNetwork
    private let storage: SteamProfileStorage

    init(network: SteamProfileNetwork, storage: SteamProfileStorage) {
        self.network = network
        self.storage = storage
    }

    // MARK: - game

    func getGameNotifier(for steamId: SteamID, gameId: SteamGameID) -> Notifier<SteamProfileGameInfoResult> {
        universalGameService.getNotifier(for: SteamIdGameIdPair(steamId: steamId, gameId: gameId))
    }
    func refreshGame(for steamId: SteamID, gameId: SteamGameID, completion: ((Bool) -> Void)?) {
        universalGameService.refresh(for: SteamIdGameIdPair(steamId: steamId, gameId: gameId), completion: completion)
    }

    private func fetchGame(by steamId: SteamID, gameId: SteamGameID) -> SteamProfileGameInfoResult {
        guard let game = storage.fetchGame(by: steamId, gameId: gameId) else {
            return .failure(.notFound)
        }
        return .success(game)
    }

    private func updateGame(by steamId: SteamID, gameId: SteamGameID, completion: @escaping (SteamProfileGameInfoResult) -> Void) {
        network.requestGame(by: steamId, gameId: gameId, completion: { [weak storage] result in
            if case let .success(game) = result {
                storage?.put(game: game)
            }

            completion(result)
        })
    }


    // MARK: - games

    func getGamesNotifier(for steamId: SteamID) -> Notifier<SteamProfileGamesInfoResult> {
        universalGamesService.getNotifier(for: steamId)
    }
    func refreshGames(for steamId: SteamID, completion: ((Bool) -> Void)?) {
        universalGamesService.refresh(for: steamId, completion: completion)
    }

    private func fetchGames(by steamId: SteamID) -> SteamProfileGamesInfoResult {
        guard let games = storage.fetchGames(by: steamId) else {
            return .failure(.notFound)
        }
        return .success(games)
    }

    private func updateGames(by steamId: SteamID, completion: @escaping (SteamProfileGamesInfoResult) -> Void) {
        network.requestGames(by: steamId, completion: { [weak storage] result in
            if case let .success(games) = result {
                storage?.put(games: games)
            }

            completion(result)
        })
    }
}
