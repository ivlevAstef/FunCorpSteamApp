//
//  CustomGameInfoRouter.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 07/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Services
import Core

// TODO: весь custom лучше бы в отдельный модуль, дабы Dota и другие кастомные модули не завязывались на прямую на GameInformation
public protocol CustomGameInfoRouter: class
{
    func configure(navigator: Navigator, steamId: SteamID, gameId: SteamGameID) -> [CustomGameInfoPresenter]
}
