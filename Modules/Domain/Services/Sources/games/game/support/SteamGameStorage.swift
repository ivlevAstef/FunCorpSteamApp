//
//  SteamGameStorage.swift
//  Services
//
//  Created by Alexander Ivlev on 24/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public protocol SteamGameStorage: class
{
    func put(scheme: SteamGameScheme, loc: SteamLocalization)
    func put(gameProgress: SteamGameProgress)

    func fetchScheme(by gameId: SteamGameID, loc: SteamLocalization) -> SteamGameScheme?
    func fetchGameProgress(by gameId: SteamGameID, steamId: SteamID) -> SteamGameProgress?
    func fetchGameProgressHistory(by gameId: SteamGameID, steamId: SteamID) -> [SteamGameProgress]?
}
