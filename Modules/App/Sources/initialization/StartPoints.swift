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

    static let common: [CommonStartPoint] = [
        CoreStartPoint(),
        DesignStartPoint(),
        UIComponentsStartPoint()
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
