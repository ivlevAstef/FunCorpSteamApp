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
    private lazy var universalService = {
        UniversalServiceImpl(
            fetcher: { [unowned self] steamId in
                return self.fetch(by: steamId)
            },
            updater: { [unowned self] (steamId, completion) in
                self.update(by: steamId, completion: completion)
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

    private func fetch(by steamId: SteamID) -> SteamProfileResult {
        guard let profile = storage.fetchProfile(by: steamId) else {
            return .failure(.notFound)
        }
        return .success(profile)
    }

    private func update(by steamId: SteamID, completion: @escaping (SteamProfileResult) -> Void) {
        network.requestUser(by: steamId, completion: { [weak storage] result in
            if case let .success(profile) = result {
                storage?.put(profile: profile)
            }

            completion(result)
        })
    }
}
