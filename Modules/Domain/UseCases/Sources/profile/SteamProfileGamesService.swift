//
//  SteamProfileGamesService.swift
//  UseCases
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Entities

public protocol SteamProfileGamesService: class
{
    func getGameNotifier(for steamId: SteamID, gameId: SteamGameID) -> Notifier<SteamProfileGameInfoResult>
    func refreshGame(for steamId: SteamID, gameId: SteamGameID, completion: ((Bool) -> Void)?)

    func getGamesNotifier(for steamId: SteamID) -> Notifier<SteamProfileGamesInfoResult>
    func refreshGames(for steamId: SteamID, completion: ((Bool) -> Void)?)
}

extension SteamProfileGamesService
{
    public func refreshGame(for steamId: SteamID, gameId: SteamGameID) {
        refreshGame(for: steamId, gameId: gameId, completion: nil)
    }

    public func refreshGames(for steamId: SteamID) {
        refreshGames(for: steamId, completion: nil)
    }
}
