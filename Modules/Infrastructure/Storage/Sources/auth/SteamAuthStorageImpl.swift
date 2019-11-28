//
//  SteamAuthStorageImpl.swift
//  Storage
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import RealmSwift
import Services

class SteamAuthStorageImpl: SteamAuthStorage {
    //var steamId: SteamID? = 76561198073561699 // my steam id
    //var steamId: SteamID? = 76561197960434622 // more games steam id
    //var steamId: SteamID? = 76561198047329396 // core2duo steam id

    var steamId: SteamID? {
        set {
            if let steamId = newValue {
                let data = SteamAuthData(steamId: steamId)
                _ = try? realm.threadSafe?.write { realm.add(data, update: .all) }
            } else if let object = realm.object(ofType: SteamAuthData.self, forPrimaryKey: SteamAuthData.singlePrimaryKey) {
                _ = try? realm.threadSafe?.write { realm.delete(object) }
            }
        }
        get {
            realm.threadSafe?.object(ofType: SteamAuthData.self, forPrimaryKey: SteamAuthData.singlePrimaryKey)?.steamId
        }
    }

    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }
}
