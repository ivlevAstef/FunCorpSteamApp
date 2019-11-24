//
//  SteamProfileGamesService.swift
//  Services
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

public protocol SteamProfileGamesService: class
{
    func getNotifier(for steamId: SteamID) -> Notifier<SteamProfileGamesInfoResult>

    func refresh(for steamId: SteamID, completion: ((Bool) -> Void)?)
}

extension SteamProfileGamesService
{
    public func refresh(for steamId: SteamID) {
        refresh(for: steamId, completion: nil)
    }
}
