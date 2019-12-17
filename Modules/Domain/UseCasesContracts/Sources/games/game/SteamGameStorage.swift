//
//  SteamGameStorage.swift
//  UseCases
//
//  Created by Alexander Ivlev on 24/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Entities
import UseCases

public protocol SteamGameStorage: class
{
    func put(scheme: SteamGameScheme, loc: SteamLocalization)
    func put(gameProgress: SteamGameProgress, steamId: SteamID)

    func fetchScheme(by gameId: SteamGameID, loc: SteamLocalization) -> StorageResult<SteamGameScheme>
    func fetchGameProgress(by gameId: SteamGameID, steamId: SteamID) -> StorageResult<SteamGameProgress>
    func fetchGameProgressHistory(by gameId: SteamGameID, steamId: SteamID) -> [SteamGameProgress]
}
