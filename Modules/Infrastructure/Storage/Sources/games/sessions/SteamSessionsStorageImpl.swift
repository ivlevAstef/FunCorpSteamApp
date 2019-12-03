//
//  SteamSessionsStorageImpl.swift
//  Storage
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import RealmSwift
import Services

private let sessionsUpdateInterval: TimeInterval = .minutes(5)

final class SteamSessionsStorageImpl: SteamSessionsStorage
{
    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    // MARK: - sessions

    func put(sessions: [SteamSession], steamId: SteamID) {
        realm.threadSafeWrite { realm in
            let data = SteamSessionsData(sessions: sessions, steamId: steamId)
            realm.add(data, update: .all)
        }
    }

    func fetchSessions(for steamId: SteamID) -> StorageResult<[SteamSession]> {
        let primaryKey = "\(steamId)"
        let data = realm.ts?.object(ofType: SteamSessionsData.self, forPrimaryKey: primaryKey)
        return dataToResult(data, updateInterval: sessionsUpdateInterval, map: { $0.sessions })
    }
}
