//
//  DotaSide+Convert.swift
//  Storage
//
//  Created by Alexander Ivlev on 03/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UseCases

extension DotaSide {
    init?(_ int: Int) {
        switch int {
        case 0: self = .radiant
        case 1: self = .dire
        default:
            return nil
        }
    }

    var toInt: Int {
        switch self {
        case .radiant: return 0
        case .dire: return 1
        }
    }
}
