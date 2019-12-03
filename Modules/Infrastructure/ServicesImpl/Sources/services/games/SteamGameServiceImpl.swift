//
//  SteamGameServiceImpl.swift
//  ServicesImpl
//
//  Created by Alexander Ivlev on 27/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Services
import UIKit
import WebKit


final class SteamGameServiceImpl: SteamGameService
{
    private struct GameIdLocPair: Hashable { let gameId: SteamGameID; let loc: SteamLocalization; }
    private lazy var universalSchemeService = { [unowned self] in
        UniversalServiceImpl<SteamGameScheme, GameIdLocPair>(
            fetcher: { pair in
                self.storage.fetchScheme(by: pair.gameId, loc: pair.loc)
            }, updater: { (pair, completion) in
                self.network.requestScheme(by: pair.gameId, loc: pair.loc, completion: completion)
            }, saver: { (pair, scheme) in
                self.storage.put(scheme: scheme, loc: pair.loc)
            }
        )
    }()

    private struct GameIdSteamIdPair: Hashable { let gameId: SteamGameID; let steamId: SteamID; }
    private lazy var universalGameProgressService = { [unowned self] in
        UniversalServiceImpl<SteamGameProgress, GameIdSteamIdPair>(
            fetcher: { pair in
                self.storage.fetchGameProgress(by: pair.gameId, steamId: pair.steamId)
            }, updater: { (pair, completion) in
                self.network.requestGameProgress(by: pair.gameId, steamId: pair.steamId, completion: completion)
            }, saver: { (pair, gameProgress) in
                self.storage.put(gameProgress: gameProgress, steamId: pair.steamId)
            }
        )
    }()

    private let network: SteamGameNetwork
    private let storage: SteamGameStorage

    init(network: SteamGameNetwork, storage: SteamGameStorage) {
        self.network = network
        self.storage = storage
    }


    func getScheme(for gameId: SteamGameID, loc: SteamLocalization, completion: @escaping (SteamGameSchemeCompletion) -> Void) {
        universalSchemeService.refresh(for: GameIdLocPair(gameId: gameId, loc: loc), contentCompletion: completion)
    }

    // MARK: - game progress

    func getGameProgressNotifier(for gameId: SteamGameID, steamId: SteamID) -> Notifier<SteamGameProgressResult> {
        universalGameProgressService.getNotifier(for: GameIdSteamIdPair(gameId: gameId, steamId: steamId))
    }
    func refreshGameProgress(for gameId: SteamGameID, steamId: SteamID, completion: ((Bool) -> Void)?) {
        universalGameProgressService.refresh(for: GameIdSteamIdPair(gameId: gameId, steamId: steamId), completion: completion)
    }

    func getGameProgressHistory(for gameId: SteamGameID, steamId: SteamID,
                                completion: @escaping (SteamGameProgressHistoryCompletion) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [storage] in
            let history = storage.fetchGameProgressHistory(by: gameId, steamId: steamId)
            completion(.success(history))
        }
    }
}
