//
//  SteamProfileStorageImpl.swift
//  Storage
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import RealmSwift
import Services

private let profileUpdateInterval: TimeInterval = .minutes(5)

class SteamProfileStorageImpl: SteamProfileStorage
{
    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    func put(profile: SteamProfile) {
        let data = SteamProfileData(profile: profile)
        _ = try? realm.threadSafe?.write {
            realm.add(data, update: .all)
        }
    }

    func fetchProfile(by steamId: SteamID) -> StorageResult<SteamProfile> {
        let data = realm.threadSafe?.object(ofType: SteamProfileData.self, forPrimaryKey: "\(steamId)")
        return dataToResult(data, updateInterval: profileUpdateInterval, map: { $0.profile })
    }

    func put(games: [SteamProfileGameInfo]) {
    }

    func put(game: SteamProfileGameInfo) {
    }

    func fetchGames(by steamId: SteamID) -> StorageResult<[SteamProfileGameInfo]> {
        return nil
    }

    func fetchGame(by steamId: SteamID, gameId: SteamGameID) -> StorageResult<SteamProfileGameInfo> {
        return nil
    }
}
