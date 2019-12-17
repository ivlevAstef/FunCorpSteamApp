//
//  SteamIDs.swift
//  UseCases
//
//  Created by Alexander Ivlev on 28/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public typealias SteamID = UInt64
public typealias AccountID = UInt32

public typealias SteamGameID = UInt32

public typealias SteamAchievementID = String
public typealias SteamStatID = String


private let magicSteamIDMapNumber: SteamID = 76561197960265728

extension SteamID {
    public var accountId: AccountID { AccountID(self - magicSteamIDMapNumber) }
}

extension AccountID {
    public var steamId: SteamID { SteamID(self) + magicSteamIDMapNumber }
}
