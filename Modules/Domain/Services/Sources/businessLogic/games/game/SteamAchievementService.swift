//
//  SteamAchievementService.swift
//  Services
//
//  Created by Alexander Ivlev on 27/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

/// Позволяет получить общую универсальную информацию по любой игре
public protocol SteamAchievementService: class
{
    /// Позволяет получить суммарную информацию об ачивках, и реагировать на ее изменение
    func getAchievementsSummaryNotifier(for gameId: SteamGameID, steamId: SteamID) -> Notifier<SteamAchievementsSummaryResult>
    /// Обновляет суммарную информацию об ачивках. Обновление состоит из получения схемы и игрового прогресса.
    func refreshAchievementsSummary(for gameId: SteamGameID, steamId: SteamID, completion: ((Bool) -> Void)?)
}

extension SteamAchievementService
{
    public func refreshAchievementsSummary(for gameId: SteamGameID, steamId: SteamID) {
        refreshAchievementsSummary(for: gameId, steamId: steamId, completion: nil)
    }
}
