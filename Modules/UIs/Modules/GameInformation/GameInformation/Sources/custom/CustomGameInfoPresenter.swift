//
//  CustomGameInfoPresenter.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Services

public protocol CustomGameInfoPresenter: class
{
    var priority: Int { get }

    var orders: [UInt] { set get }

    // Говорит сколько секций он должен занимать. Вернет ноль, если не поддерживает информацию об игре
    func requestSectionsCount(gameId: SteamGameID) -> UInt

    func configure(steamId: SteamID, gameId: SteamGameID)
    func refresh(steamId: SteamID, gameId: SteamGameID)
}
