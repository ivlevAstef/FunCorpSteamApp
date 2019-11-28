//
//  SteamGameStorageImpl.swift
//  Storage
//
//  Created by Alexander Ivlev on 27/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Services


class SteamGameStorageImpl: SteamGameStorage {
    // TODO: make real storage
    func put(scheme: SteamGameScheme, loc: SteamLocalization) {

    }
    func put(gameProgress: SteamGameProgress) {

    }

    func fetchScheme(by gameId: SteamGameID, loc: SteamLocalization) -> StorageResult<SteamGameScheme> {
        return nil
    }
    func fetchGameProgress(by gameId: SteamGameID, steamId: SteamID) -> StorageResult<SteamGameProgress> {
        return nil
    }
    func fetchGameProgressHistory(by gameId: SteamGameID, steamId: SteamID) -> [SteamGameProgress] {
        return []
    }
}

