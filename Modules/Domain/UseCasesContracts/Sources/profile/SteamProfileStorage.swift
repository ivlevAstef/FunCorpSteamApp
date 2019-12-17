//
//  SteamProfileStorage.swift
//  UseCases
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Entities
import UseCases

public protocol SteamProfileStorage: class
{
    func put(profile: SteamProfile)
    func put(friends: [SteamFriend])
    func put(games: [SteamProfileGameInfo])
    func put(game: SteamProfileGameInfo)

    func fetchProfile(by steamId: SteamID) -> StorageResult<SteamProfile>
    func fetchFriends(for steamId: SteamID) -> StorageResult<[SteamFriend]>
    func fetchGames(by steamId: SteamID) -> StorageResult<[SteamProfileGameInfo]>
    func fetchGame(by steamId: SteamID, gameId: SteamGameID) -> StorageResult<SteamProfileGameInfo>
}
