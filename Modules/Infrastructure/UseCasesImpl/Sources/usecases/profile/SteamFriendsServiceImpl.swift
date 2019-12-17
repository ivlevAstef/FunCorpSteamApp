//
//  SteamFriendsServiceImpl.swift
//  UseCasesImpl
//
//  Created by Alexander Ivlev on 30/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Entities
import UseCases
import UseCasesContracts

final class SteamFriendsServiceImpl: SteamFriendsService
{

    private lazy var universalService = { [unowned self] in
        UniversalServiceImpl(
            fetcher: { steamId in
                self.storage.fetchFriends(for: steamId)
            }, updater: { (steamId, completion) in
                self.network.requestFriends(for: steamId, completion: completion)
            }, saver: { (_, friends) in
                self.storage.put(friends: friends)
            }
        )
    }()

    private let network: SteamProfileNetwork
    private let storage: SteamProfileStorage

    init(network: SteamProfileNetwork, storage: SteamProfileStorage) {
        self.network = network
        self.storage = storage
    }

    func refresh(for steamId: SteamID, completion: ((Bool) -> Void)?) {
        universalService.refresh(for: steamId, completion: completion)
    }

    func getNotifier(for steamId: SteamID) -> Notifier<SteamFriendsResult> {
        universalService.getNotifier(for: steamId)
    }
}
