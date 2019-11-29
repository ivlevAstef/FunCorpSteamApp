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
private let profileGameInfoUpdateInterval: TimeInterval = .minutes(15)

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
        let dataOfGames = games.map { SteamProfileGameData(profileGameInfo: $0) }
        _ = try? realm.threadSafe?.write {
            realm.add(dataOfGames, update: .all)
        }
    }

    func put(game: SteamProfileGameInfo) {
        let data = SteamProfileGameData(profileGameInfo: game)
        _ = try? realm.threadSafe?.write {
            realm.add(data, update: .all)
        }
    }

    func fetchGames(by steamId: SteamID) -> StorageResult<[SteamProfileGameInfo]> {
        let dataOfGames = realm.threadSafe?.objects(SteamProfileGameData.self).filter("_steamId = %@", "\(steamId)")
        return dataArrayToResult(dataOfGames, updateInterval: profileGameInfoUpdateInterval, map: { $0.profileGameInfo })
    }

    func fetchGame(by steamId: SteamID, gameId: SteamGameID) -> StorageResult<SteamProfileGameInfo> {
        let primaryKey = SteamProfileGameData.generatePrimaryKey(steamId: steamId, gameId: gameId)
        let data = realm.threadSafe?.object(ofType: SteamProfileGameData.self, forPrimaryKey: primaryKey)
        return dataToResult(data, updateInterval: profileGameInfoUpdateInterval, map: { $0.profileGameInfo })
    }
}
