//
//  SteamSessionsNetwork.swift
//  Services
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public protocol SteamSessionsNetwork: class
{
    func requestSessions(for steamId: SteamID, completion: @escaping (SteamSessionsResult) -> Void)
}

