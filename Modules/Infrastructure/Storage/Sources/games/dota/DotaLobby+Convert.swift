//
//  DotaLobby+Convert.swift
//  Storage
//
//  Created by Alexander Ivlev on 03/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UseCases

extension DotaLobby {
    init?(_ int: Int) {
        switch int {
        case 0: self = .public
        case 1: self = .practice
        case 2: self = .tournament
        case 3: self = .tutorial
        case 4: self = .coopWithBots
        case 5: self = .teamMatch
        case 6: self = .soloQueue
        case 7: self = .ranked
        case 8: self = .soloMid1v1
        default:
            return nil
        }
    }

    var toInt: Int {
        switch self {
        case .`public`: return 0
        case .practice: return 1
        case .tournament: return 2
        case .tutorial: return 3
        case .coopWithBots: return 4
        case .teamMatch: return 5
        case .soloQueue: return 6
        case .ranked: return 7
        case .soloMid1v1: return 8
        }
    }
}
