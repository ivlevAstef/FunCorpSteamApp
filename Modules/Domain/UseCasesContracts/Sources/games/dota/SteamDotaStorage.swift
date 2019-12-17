//
//  SteamDotaStorage.swift
//  UseCases
//
//  Created by Alexander Ivlev on 02/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Entities
import UseCases

public protocol SteamDotaStorage: class
{
    func put(matches: [DotaMatch], for accountId: AccountID)
    func put(details: DotaMatchDetails, for accountId: AccountID)
    func put(heroes: [DotaHero], loc: SteamLocalization)

    func fetchMatches(for accountId: AccountID) -> [DotaMatch]
    func fetchDetails(for accountId: AccountID, matchId: DotaMatchID) -> DotaMatchDetails?
    func fetchDetailsList(for accountId: AccountID) -> [DotaMatchDetails]
    func fetchHeroes(loc: SteamLocalization) -> StorageResult<[DotaHero]>
}
