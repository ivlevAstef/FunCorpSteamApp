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

    func put(for steamId: SteamID, games: [SteamProfileGame]) {
    }



    func fetchProfile(by steamId: SteamID) -> SteamProfile? {
        return nil
    }

    func fetchGames(by steamId: SteamID) -> [SteamProfileGame]? {
        return nil
    }
}

