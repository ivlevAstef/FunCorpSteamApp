//
//  UIModuleName.swift
//  Core
//
//  Created by Alexander Ivlev on 30/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public enum UIModuleName {
    case menu

    case news
    case profile
    case friends
    case gameInfo
    case settings

    public var deeplinkName: DeepLink.Name {
        switch self {
        case .menu: return "menu"
        case .news: return "news"
        case .profile: return "profile"
        case .friends: return "friends"
        case .gameInfo: return "gameInfo"
        case .settings: return "settings"
        }
    }
}
