//
//  SteamLocalization.swift
//  UseCases
//
//  Created by Alexander Ivlev on 24/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

public enum SteamLocalization
{
    case en
    case ru

    public static var current: SteamLocalization {
        return SteamLocalization(current: ())
    }
}

extension SteamLocalization
{
    public init(current: Void) {
        switch loc.languageCode {
        case "en":
            self = .en
        case "ru":
            self = .ru
        default:
            self = .en
        }
    }
}
