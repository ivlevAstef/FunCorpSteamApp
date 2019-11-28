//
//  TimeInterval+minutes.swift
//  Storage
//
//  Created by Alexander Ivlev on 28/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

extension TimeInterval
{
    static func minutes(_ minutes: Int) -> TimeInterval {
        return TimeInterval(minutes) * 60.0
    }
}
