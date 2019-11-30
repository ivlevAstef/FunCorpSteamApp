//
//  SteamProfileNetwork.swift
//  Services
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public protocol SteamProfileNetwork: class
{
    func requestProfile(by steamId: SteamID, completion: @escaping (SteamProfileResult) -> Void)

    func requestFriends(for steamId: SteamID, completion: @escaping (SteamFriendsResult) -> Void)

    func requestGames(by steamId: SteamID, completion: @escaping (SteamProfileGamesInfoResult) -> Void)

    func requestGame(by steamId: SteamID, gameId: SteamGameID, completion: @escaping (SteamProfileGameInfoResult) -> Void)
}
