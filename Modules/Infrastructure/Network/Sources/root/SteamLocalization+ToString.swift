//
//  SteamLocalization+ToString.swift
//  Network
//
//  Created by Alexander Ivlev on 27/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Services

extension SteamLocalization
{
    var toString: String {
        switch self {
        case .en:
            return "english" // or not?
        case .ru:
            return "russian"
        }
    }
}
