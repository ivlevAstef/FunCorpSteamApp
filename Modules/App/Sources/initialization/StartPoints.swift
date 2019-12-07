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
import AppUIComponents

import Storage
import Network
import ServicesImpl

import Auth
import Menu

import News
import Profile
import GameInformation
import Sessions

import Dota

enum StartPoints
{
    static let auth = AuthStartPoint()
    static let menu = MenuStartPoint()

    static let news = NewsStartPoint()
    static let profile = ProfileStartPoint()
    static let gameInfo = GameInfoStartPoint()
    static let sessions = SessionsStartPoint()

    // Порядок инициализации этих точек важен - всегда идем от низа к вверху
    static let common: [CommonStartPoint] = [
        CoreStartPoint(),
        DesignStartPoint(),
        UIComponentsStartPoint(),
        AppUIComponentsStartPoint(),
        StorageStartPoint(),
        NetworkStartPoint(),
        ServicesImplStartPoint(),

        DotaStartPoint(),
    ]

    static let ui: [UIModuleName: UIStartPoint] = [
        AuthStartPoint.name: auth,
        MenuStartPoint.name: menu,
        NewsStartPoint.name: news,
        ProfileStartPoint.name: profile,
        GameInfoStartPoint.name: gameInfo,
        SessionsStartPoint.name: sessions,
    ]
}
