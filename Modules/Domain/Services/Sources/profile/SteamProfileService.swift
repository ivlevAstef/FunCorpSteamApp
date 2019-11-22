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
    func refresh(for steamId: SteamID)
    func getNotifier(for steamId: SteamID) -> Notifier<SteamProfileResult>
}
