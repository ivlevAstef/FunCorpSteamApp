//
//  SteamProfileServiceImpl.swift
//  ServicesImpl
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

final class SteamProfileServiceImpl: SteamProfileService
{
    private lazy var universalService = { [unowned self] in
        UniversalServiceImpl(
            fetcher: { steamId in
                self.storage.fetchProfile(by: steamId)
            }, updater: { (steamId, completion) in
                self.network.requestProfile(by: steamId, completion: completion)
            }, saver: { (_, profile) in
                self.storage.put(profile: profile)
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

    func getNotifier(for steamId: SteamID) -> Notifier<SteamProfileResult> {
        universalService.getNotifier(for: steamId)
    }
}
