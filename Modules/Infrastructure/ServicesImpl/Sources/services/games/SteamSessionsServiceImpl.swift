//
//  SteamSessionsServiceImpl.swift
//  ServicesImpl
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

final class SteamSessionsServiceImpl: SteamSessionsService
{
    private lazy var universalService = { [unowned self] in
        UniversalServiceImpl(
            fetcher: { steamId in
                self.storage.fetchSessions(for: steamId)
            }, updater: { (steamId, completion) in
                self.network.requestSessions(for: steamId, completion: completion)
            }, saver: { (steamId, sessions) in
                self.storage.put(sessions: sessions, steamId: steamId)
            }
        )
    }()

    private let network: SteamSessionsNetwork
    private let storage: SteamSessionsStorage

    init(network: SteamSessionsNetwork, storage: SteamSessionsStorage) {
        self.network = network
        self.storage = storage
    }

    func refreshSessions(for steamId: SteamID, completion: ((Bool) -> Void)?) {
        universalService.refresh(for: steamId, completion: completion)
    }

    func getSessionsNotifier(for steamId: SteamID) -> Notifier<SteamSessionsResult> {
        universalService.getNotifier(for: steamId)
    }
}
