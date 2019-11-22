//
//  Int64+ToDate.swift
//  Network
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

extension Int64 {
    var unixTimeToDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}

