//
//  SteamProfileStorage.swift
//  Services
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public protocol SteamProfileStorage: class
{
    func put(profile: SteamProfile)
    func put(for steamId: SteamID, games: [SteamProfileGameInfo])

    func fetchProfile(by steamId: SteamID) -> SteamProfile?
    func fetchGames(by steamId: SteamID) -> [SteamProfileGameInfo]?
}
