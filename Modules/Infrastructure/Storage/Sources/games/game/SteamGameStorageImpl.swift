//
//  SteamGameStorageImpl.swift
//  Storage
//
//  Created by Alexander Ivlev on 27/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import RealmSwift
import Services

private let gameSchemeUpdateInterval: TimeInterval = .minutes(60)
private let gameProgressUpdateInterval: TimeInterval = .minutes(5)

class SteamGameStorageImpl: SteamGameStorage {
    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    // MARK: - scheme

    func put(scheme: SteamGameScheme, loc: SteamLocalization) {
        let data = SteamGameSchemeData(scheme: scheme, loc: loc)
        _ = try? realm.threadSafe?.write {
            realm.add(data, update: .all)
        }
    }

    func fetchScheme(by gameId: SteamGameID, loc: SteamLocalization) -> StorageResult<SteamGameScheme> {
        let primaryKey = SteamGameSchemeData.generatePrimaryKey(gameId: gameId, loc: loc)
        let data = realm.threadSafe?.object(ofType: SteamGameSchemeData.self, forPrimaryKey: primaryKey)
        return dataToResult(data, updateInterval: gameSchemeUpdateInterval, map: { $0.scheme })
    }

    // MARK: - game progress

    func put(gameProgress: SteamGameProgress, steamId: SteamID) {
        let oldData = fetchGameProgressData(by: gameProgress.gameId, steamId: steamId)

        _ = try? realm.threadSafe?.write {
            let data: SteamGameProgressData
            if let oldData = oldData {
                // если объект изменился, то добавляем новую запись, если не изменился, то обновляем старую
                data = updateGameProgressData(oldData: oldData, newObject: gameProgress, steamId: steamId)
            } else {
                data = SteamGameProgressData(gameProgress: gameProgress, order: 0, steamId: steamId)
            }

            let lastData = makeLastGameProgressData(by: gameProgress.gameId, steamId: steamId, order: data.order)

            realm.add(lastData, update: .all)
            realm.add(data, update: .all)
        }
    }

    func fetchGameProgress(by gameId: SteamGameID, steamId: SteamID) -> StorageResult<SteamGameProgress> {
        let data = fetchGameProgressData(by: gameId, steamId: steamId)
        return dataToResult(data, updateInterval: gameProgressUpdateInterval, map: { $0.gameProgress })
    }

    func fetchGameProgressHistory(by gameId: SteamGameID, steamId: SteamID) -> [SteamGameProgress] {
        let historyData = realm.ts?.objects(SteamGameProgressData.self).filter("_steamId = %@ AND _gameId = $@", steamId, gameId)

        return dataArrayToResult(historyData, map: { $0.gameProgress })
    }

    // MARK: - private

    private func fetchGameProgressData(by gameId: SteamGameID, steamId: SteamID) -> SteamGameProgressData? {
        let pk = SteamLastGameProgressData.generatePrimaryKey(steamId: steamId, gameId: gameId)
        let order = realm.ts?.object(ofType: SteamLastGameProgressData.self, forPrimaryKey: pk)?._order ?? 0

        let primaryKey = SteamGameProgressData.generatePrimaryKey(steamId: steamId, gameId: gameId, order: order)
        return realm.ts?.object(ofType: SteamGameProgressData.self, forPrimaryKey: primaryKey)
    }

    private func updateGameProgressData(oldData: SteamGameProgressData,
                                        newObject: SteamGameProgress,
                                        steamId: SteamID) -> SteamGameProgressData {
        if oldData.gameProgress == newObject {
            oldData._stateDateEnd = newObject.stateDateEnd
            return oldData
        }
        return SteamGameProgressData(gameProgress: newObject, order: oldData.order + 1, steamId: steamId)
    }

    private func makeLastGameProgressData(by gameId: SteamGameID, steamId: SteamID, order: Int64) -> SteamLastGameProgressData {
        let data = SteamLastGameProgressData()
        data._primaryKey = SteamLastGameProgressData.generatePrimaryKey(steamId: steamId, gameId: gameId)
        data._order = order

        return data
    }
}

