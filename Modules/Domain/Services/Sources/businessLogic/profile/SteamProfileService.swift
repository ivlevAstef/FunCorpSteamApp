//
//  SteamProfileService.swift
//  Services
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

public protocol SteamProfileService: class
{
    func getNotifier(for steamId: SteamID) -> Notifier<SteamProfileResult>

    func refresh(for steamId: SteamID, completion: ((Bool) -> Void)?)
}

extension SteamProfileService
{
    public func refresh(for steamId: SteamID) {
        refresh(for: steamId, completion: nil)
    }
}
