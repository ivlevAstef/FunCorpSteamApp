//
//  SteamSessionsStorage.swift
//  Services
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public protocol SteamSessionsStorage: class
{
    func put(sessions: [SteamSession], steamId: SteamID)

    func fetchSessions(for steamId: SteamID) -> StorageResult<[SteamSession]>
}
