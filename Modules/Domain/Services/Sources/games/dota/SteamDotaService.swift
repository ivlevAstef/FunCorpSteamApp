//
//  SteamDotaService.swift
//  Services
//
//  Created by Alexander Ivlev on 24/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

/// Позволяет получить более подробную информацию о Dota 2
public protocol SteamDotaService: class
{
    /// Возвращает идентификатор игры "Dota 2"
    static var gameId: SteamGameID { get }

    func matchHistory(for accountId: AccountID)
}
