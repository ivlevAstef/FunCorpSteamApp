//
//  SteamProfileService.swift
//  UseCases
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Entities

public protocol SteamProfileService: class
{
    func getNotifier(for steamId: SteamID) -> Notifier<SteamProfileResult>

    func refresh(for steamId: SteamID, completion: ((Bool) -> Void)?)

    func getProfile(for steamId: SteamID, completion: @escaping (SteamProfileCompletion) -> Void)
}

extension SteamProfileService
{
    public func refresh(for steamId: SteamID) {
        refresh(for: steamId, completion: nil)
    }
}
