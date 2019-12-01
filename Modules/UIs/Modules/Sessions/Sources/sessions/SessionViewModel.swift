//
//  SessionViewModel.swift
//  Sessions
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common

struct SessionViewModel
{
    let icon: ChangeableImage
    let name: String

    let playtimeForeverPrefix: String
    let playtimeForever: TimeInterval

    let playtime2weeksPrefix: String
    let playtime2weeks: TimeInterval
    let playtime2weeksSuffix: String

    let tapNotifier: Notifier<Void>
}
