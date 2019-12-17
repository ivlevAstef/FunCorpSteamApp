//
//  SteamGameNetwork.swift
//  UseCases
//
//  Created by Alexander Ivlev on 24/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Entities
import UseCases

public protocol SteamGameNetwork: class
{
    func requestScheme(by gameId: SteamGameID, loc: SteamLocalization, completion: @escaping (SteamGameSchemeResult) -> Void)

    func requestGameProgress(by gameId: SteamGameID, steamId: SteamID, completion: @escaping (SteamGameProgressResult) -> Void)
}
