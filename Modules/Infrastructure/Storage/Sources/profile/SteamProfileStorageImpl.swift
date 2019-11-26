//
//  SteamProfileStorageImpl.swift
//  Storage
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Services


class SteamProfileStorageImpl: SteamProfileStorage
{
    // TODO: make real storage
    func put(profile: SteamProfile) {

    }

    func put(games: [SteamProfileGameInfo]) {
    }

    func put(game: SteamProfileGameInfo) {
    }



    func fetchProfile(by steamId: SteamID) -> SteamProfile? {
        return nil
    }

    func fetchGames(by steamId: SteamID) -> [SteamProfileGameInfo]? {
        return nil
    }

    func fetchGame(by steamId: SteamID, gameId: SteamGameID) -> SteamProfileGameInfo? {
        return nil
    }
}

