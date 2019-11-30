//
//  UIModuleName.swift
//  Core
//
//  Created by Alexander Ivlev on 30/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public enum UIModuleName {
    case auth
    case menu

    case news
    case profile
    case gameInfo
    case sessions

    public var deeplinkName: DeepLink.Name {
        switch self {
        case .auth: return "auth"
        case .menu: return "menu"
        case .news: return "news"
        case .profile: return "profile"
        case .gameInfo: return "gameInfo"
        case .sessions: return "sessions"
        }
    }
}
