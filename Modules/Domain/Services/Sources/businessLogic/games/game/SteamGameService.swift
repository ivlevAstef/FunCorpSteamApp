//
//  SteamGameService.swift
//  Services
//
//  Created by Alexander Ivlev on 24/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

/// Позволяет получить общую универсальную информацию по любой игре
public protocol SteamGameService: class
{
    /// Схема выдает основную информацию о внутренностях игры - список ачивок, и список показателей.
    /// Универсально для любой игры.
    /// Схема не меняется, поэтому ей всяких нотификаторов не надо.
    func getScheme(for gameId: SteamGameID, loc: SteamLocalization, completion: @escaping (SteamGameSchemeCompletion) -> Void)

    /// Позволяет получить универсальный прогресс по игре - ачивки, и некоторую универсальную статистиску
    func getGameProgressNotifier(for gameId: SteamGameID, steamId: SteamID) -> Notifier<SteamGameProgressResult>
    /// Обновляет универсальный прогресс по игре - ачивки, и некоторую универсальную статистиску
    func refreshGameProgress(for gameId: SteamGameID, steamId: SteamID, completion: ((Bool) -> Void)?)

    /// Выдает универсальную историю прогресса - то есть как менялось состояние ачивок, и универсальной статистики
    func getGameProgressHistory(for gameId: SteamGameID, steamId: SteamID,
                                completion: @escaping (SteamGameProgressHistoryCompletion) -> Void)
}

extension SteamGameService
{
    public func refreshGameProgress(for gameId: SteamGameID, steamId: SteamID) {
        refreshGameProgress(for: gameId, steamId: steamId, completion: nil)
    }
}
