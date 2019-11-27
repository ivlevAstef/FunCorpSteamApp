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
    private struct GameIdSteamIdPair: Hashable { let gameId: SteamGameID; let steamId: SteamID; }
    private lazy var universalGameProgressService = {
        UniversalServiceImpl<SteamGameProgress, GameIdSteamIdPair>(
            fetcher: { [unowned self] pair in
                return self.fetchGameProgress(for: pair.gameId, steamId: pair.steamId)
            },
            updater: { [unowned self] (pair, completion) in
                self.updateGameProgress(for: pair.gameId, steamId: pair.steamId, completion: completion)
            }
        )
    }()

    private let network: SteamGameNetwork
    private let storage: SteamGameStorage

    init(network: SteamGameNetwork, storage: SteamGameStorage) {
        self.network = network
        self.storage = storage
    }


    func getScheme(for gameId: SteamGameID, loc: SteamLocalization, completion: @escaping (SteamGameSchemeResult) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [network, storage] in
            if let scheme = storage.fetchScheme(by: gameId, loc: loc) {
                completion(.success(scheme))
                return
            }

            network.requestScheme(by: gameId, loc: loc) { [weak storage] result in
                if case let .success(scheme) = result {
                    storage?.put(scheme: scheme, loc: loc)
                }
                completion(result)
            }
        }
    }

    // MARK: - game progress

    func getGameProgressNotifier(for gameId: SteamGameID, steamId: SteamID) -> Notifier<SteamGameProgressResult> {
        universalGameProgressService.getNotifier(for: GameIdSteamIdPair(gameId: gameId, steamId: steamId))
    }
    func refreshGameProgress(for gameId: SteamGameID, steamId: SteamID, completion: ((Bool) -> Void)?) {
        universalGameProgressService.refresh(for: GameIdSteamIdPair(gameId: gameId, steamId: steamId), completion: completion)
    }

    private func fetchGameProgress(for gameId: SteamGameID, steamId: SteamID) -> SteamGameProgressResult {
        guard let gameProgress = storage.fetchGameProgress(by: gameId, steamId: steamId) else {
            return .failure(.notFound)
        }
        return .success(gameProgress)
    }

    private func updateGameProgress(for gameId: SteamGameID, steamId: SteamID, completion: @escaping (SteamGameProgressResult) -> Void) {
        network.requestGameProgress(by: gameId, steamId: steamId, completion: { [weak storage] result in
            if case let .success(gameProgress) = result {
                storage?.put(gameProgress: gameProgress)
            }

            completion(result)
        })
    }

    func getGameProgressHistory(for gameId: SteamGameID, steamId: SteamID,
                                completion: @escaping (SteamGameProgressHistoryResult) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [storage] in
            guard let history = storage.fetchGameProgressHistory(by: gameId, steamId: steamId) else {
                completion(.failure(.notFound))
                return
            }
            completion(.success(history))
        }
    }
}
