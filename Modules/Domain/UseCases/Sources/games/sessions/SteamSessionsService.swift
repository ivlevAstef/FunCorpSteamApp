//
//  SteamSessionsService.swift
//  UseCases
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Entities

/// Позволяет получить информацию о последних сессиях. В реальности пока это последние игры в которые заходил игрок
public protocol SteamSessionsService: class
{
    func getSessionsNotifier(for steamId: SteamID) -> Notifier<SteamSessionsResult>

    func refreshSessions(for steamId: SteamID, completion: ((Bool) -> Void)?)
}

extension SteamSessionsService
{
    public func refreshSessions(for steamId: SteamID) {
        refreshSessions(for: steamId, completion: nil)
    }
}
