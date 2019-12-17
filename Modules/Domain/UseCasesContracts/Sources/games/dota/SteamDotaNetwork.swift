//
//  SteamDotaNetwork.swift
//  UseCases
//
//  Created by Alexander Ivlev on 02/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Entities
import UseCases

public protocol SteamDotaNetwork: class
{
    func requestHistory(accountId: AccountID, count: UInt, heroId: Int?, from: DotaMatchID?, completion: @escaping (DotaMatchHistoryResult) -> Void)

    func requestDetails(matchId: DotaMatchID, completion: @escaping (DotaMatchDetailsResult) -> Void)

    func requestHeroes(loc: SteamLocalization, completion: @escaping (DotaHeroesResult) -> Void)
}
