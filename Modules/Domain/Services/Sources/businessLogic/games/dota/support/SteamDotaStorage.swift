//
//  SteamDotaStorage.swift
//  Services
//
//  Created by Alexander Ivlev on 02/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public protocol SteamDotaStorage: class
{
    func put(matches: [DotaMatch], for accountId: AccountID)
    func put(details: DotaMatchDetails)

    func fetchMatches(for accountId: AccountID) -> [DotaMatch]
    func fetchDetail(for matchId: DotaMatchID) -> DotaMatchDetails?
    func fetchDetails(for accountId: AccountID) -> [DotaMatchDetails]
}
