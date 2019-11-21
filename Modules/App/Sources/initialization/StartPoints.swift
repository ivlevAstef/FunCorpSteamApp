//
//  StartPoints.swift
//  ApLife
//
//  Created by Alexander Ivlev on 24/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import Design
import UIComponents
import Storage
import Network
import ServicesImpl

import Menu

import News
import Profile
import Friends
import GameInformation
import Settings

enum StartPoints
{
    static let menu = MenuStartPoint()

    static let news = NewsStartPoint()
    static let profile = ProfileStartPoint()
    static let friends = FriendsStartPoint()
    static let gameInfo = GameInfoStartPoint()
    static let settings = SettingsStartPoint()

    // Порядок инициализации этих точек важен - всегда идем от низа к вверху
    static let common: [CommonStartPoint] = [
        CoreStartPoint(),
        DesignStartPoint(),
        UIComponentsStartPoint(),
        StorageStartPoint(),
        NetworkStartPoint(),
        ServicesImplStartPoint()
    ]

    static let ui: [UIModuleName: UIStartPoint] = [
        MenuStartPoint.name: menu,
        NewsStartPoint.name: news,
        ProfileStartPoint.name: profile,
        FriendsStartPoint.name: friends,
        GameInfoStartPoint.name: gameInfo,
        SettingsStartPoint.name: settings,
    ]
}
