//
//  SteamFriendsService.swift
//  Services
//
//  Created by Alexander Ivlev on 30/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

public protocol SteamFriendsService: class
{
    func getNotifier(for steamId: SteamID) -> Notifier<SteamFriendsResult>

    func refresh(for steamId: SteamID, completion: ((Bool) -> Void)?)
}


extension SteamFriendsService
{
    public func refresh(for steamId: SteamID) {
        refresh(for: steamId, completion: nil)
    }
}
