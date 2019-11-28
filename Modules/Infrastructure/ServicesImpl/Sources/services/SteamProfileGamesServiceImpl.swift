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
    private lazy var universalGamesService = { [unowned self] in
        UniversalServiceImpl(
            fetcher: { steamId in
                self.storage.fetchGames(by: steamId)
            }, updater: { (steamId, completion) in
                self.network.requestGames(by: steamId, completion: completion)
            }, saver: { (_, games) in
                self.storage.put(games: games)
            }
        )
    }()

    private struct SteamIdGameIdPair: Hashable { let steamId: SteamID; let gameId: SteamGameID; }
    private lazy var universalGameService = { [unowned self] in
        UniversalServiceImpl<SteamProfileGameInfo, SteamIdGameIdPair>(
            fetcher: { pair in
                self.storage.fetchGame(by: pair.steamId, gameId: pair.gameId)
            }, updater: { (pair, completion) in
                self.network.requestGame(by: pair.steamId, gameId: pair.gameId, completion: completion)
            }, saver: { (_, game) in
                self.storage.put(game: game)
            }
        )
    }()

    private let network: SteamProfileNetwork
    private let storage: SteamProfileStorage

    init(network: SteamProfileNetwork, storage: SteamProfileStorage) {
        self.network = network
        self.storage = storage
    }

    // MARK: - games

    func getGamesNotifier(for steamId: SteamID) -> Notifier<SteamProfileGamesInfoResult> {
        universalGamesService.getNotifier(for: steamId)
    }
    func refreshGames(for steamId: SteamID, completion: ((Bool) -> Void)?) {
        universalGamesService.refresh(for: steamId, completion: completion)
    }

    // MARK: - game

    func getGameNotifier(for steamId: SteamID, gameId: SteamGameID) -> Notifier<SteamProfileGameInfoResult> {
        universalGameService.getNotifier(for: SteamIdGameIdPair(steamId: steamId, gameId: gameId))
    }
    func refreshGame(for steamId: SteamID, gameId: SteamGameID, completion: ((Bool) -> Void)?) {
        universalGameService.refresh(for: SteamIdGameIdPair(steamId: steamId, gameId: gameId), completion: completion)
    }
}
