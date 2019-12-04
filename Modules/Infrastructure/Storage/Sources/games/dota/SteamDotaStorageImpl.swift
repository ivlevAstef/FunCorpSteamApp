//
//  SteamDotaStorageImpl.swift
//  Storage
//
//  Created by Alexander Ivlev on 03/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import RealmSwift
import Services

private let heroesUpdateInterval: TimeInterval = .minutes(60)

final class SteamDotaStorageImpl: SteamDotaStorage
{
    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    // MARK: - matches

    func put(matches: [DotaMatch], for accountId: AccountID) {
        realm.threadSafeWrite { realm in
            let data = matches.map { SteamDotaMatchData(match: $0, accountId: accountId) }
            realm.add(data, update: .all)
        }
    }

    func fetchMatches(for accountId: AccountID) -> [DotaMatch] {
        let optDataArray = realm.ts?.objects(SteamDotaMatchData.self).filter("_accountId = %@", Int64(accountId))
        guard let dataArray = optDataArray, !dataArray.isEmpty else {
            return []
        }

        var result: [DotaMatch] = []
        for data in dataArray {
            if let match = data.match {
                result.append(match)
            }
        }

        return result
    }

    // MARK: - details

    func put(details: DotaMatchDetails, for accountId: AccountID) {
        realm.threadSafeWrite { realm in
            let data = SteamDotaMatchDetailsData(match: details, accountId: accountId)
            realm.add(data, update: .all)
        }
    }

    func fetchDetails(for accountId: AccountID, matchId: DotaMatchID) -> DotaMatchDetails? {
        let primaryKey = SteamDotaMatchDetailsData.generatePrimaryKey(matchId: matchId, accountId: accountId)
        let data = realm.ts?.object(ofType: SteamDotaMatchDetailsData.self, forPrimaryKey: primaryKey)
        return data?.matchDetails
    }

    func fetchDetailsList(for accountId: AccountID) -> [DotaMatchDetails] {
        let optDataArray = realm.ts?.objects(SteamDotaMatchDetailsData.self).filter("_accountId = %@", Int64(accountId))
        guard let dataArray = optDataArray, !dataArray.isEmpty else {
            return []
        }

        var result: [DotaMatchDetails] = []
        for data in dataArray {
            if let matchDetails = data.matchDetails {
                result.append(matchDetails)
            }
        }

        return result
    }

    // MARK: - heroes

    func put(heroes: [DotaHero], loc: SteamLocalization) {
        realm.threadSafeWrite { realm in
            let data = heroes.map { SteamDotaHeroData(hero: $0, loc: loc) }
            realm.add(data, update: .all)
        }
    }

    func fetchHeroes(loc: SteamLocalization) -> StorageResult<[DotaHero]> {
        let dataArray = realm.ts?.objects(SteamDotaHeroData.self).filter("_loc = %@", "\(loc)")
        return dataArrayToResult(dataArray, updateInterval: heroesUpdateInterval, map: { $0.hero })
    }
}
