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
    func put(games: [SteamProfileGameInfo])
    func put(game: SteamProfileGameInfo)

    func fetchProfile(by steamId: SteamID) -> StorageResult<SteamProfile>
    func fetchGames(by steamId: SteamID) -> StorageResult<[SteamProfileGameInfo]>
    func fetchGame(by steamId: SteamID, gameId: SteamGameID) -> StorageResult<SteamProfileGameInfo>
}
