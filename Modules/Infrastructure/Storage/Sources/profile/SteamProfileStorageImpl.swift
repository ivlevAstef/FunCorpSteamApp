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
private let friendsUpdateInterval: TimeInterval = .minutes(10)

class SteamProfileStorageImpl: SteamProfileStorage
{
    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    // MARK: - profile

    func put(profile: SteamProfile) {
        realm.threadSafeWrite { realm in
            let data = SteamProfileData(profile: profile)
            realm.add(data, update: .all)
        }
    }

    func fetchProfile(by steamId: SteamID) -> StorageResult<SteamProfile> {
        let data = realm.ts?.object(ofType: SteamProfileData.self, forPrimaryKey: "\(steamId)")
        return dataToResult(data, updateInterval: profileUpdateInterval, map: { $0.profile })
    }

    // MARK: - friends

    func put(friends: [SteamFriend]) {
        realm.threadSafeWrite { realm in
            let dataOfFriends = friends.map { SteamFriendData(friend: $0) }
            realm.add(dataOfFriends, update: .all)
        }
    }

    func fetchFriends(for steamId: SteamID) -> StorageResult<[SteamFriend]> {
        let dataOfFriends = realm.ts?.objects(SteamFriendData.self).filter("_ownerSteamId = %@", "\(steamId)")
        return dataArrayToResult(dataOfFriends, updateInterval: friendsUpdateInterval, map: { $0.friend })
    }

    // MARK: - games

    func put(games: [SteamProfileGameInfo]) {
        realm.threadSafeWrite { realm in
            let dataOfGames = games.map { SteamProfileGameData(profileGameInfo: $0) }
            realm.add(dataOfGames, update: .all)
        }
    }

    func fetchGames(by steamId: SteamID) -> StorageResult<[SteamProfileGameInfo]> {
        let dataOfGames = realm.ts?.objects(SteamProfileGameData.self).filter("_steamId = %@", "\(steamId)")
        return dataArrayToResult(dataOfGames, updateInterval: profileGameInfoUpdateInterval, map: { $0.profileGameInfo })
    }

    // MARK: - game

    func put(game: SteamProfileGameInfo) {
        realm.threadSafeWrite { realm in
            let data = SteamProfileGameData(profileGameInfo: game)
            realm.add(data, update: .all)
        }
    }

    func fetchGame(by steamId: SteamID, gameId: SteamGameID) -> StorageResult<SteamProfileGameInfo> {
        let primaryKey = SteamProfileGameData.generatePrimaryKey(steamId: steamId, gameId: gameId)
        let data = realm.ts?.object(ofType: SteamProfileGameData.self, forPrimaryKey: primaryKey)
        return dataToResult(data, updateInterval: profileGameInfoUpdateInterval, map: { $0.profileGameInfo })
    }
}
