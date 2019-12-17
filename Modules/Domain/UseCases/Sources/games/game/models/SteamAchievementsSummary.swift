//
//  SteamAchievementsSummary.swift
//  UseCases
//
//  Created by Alexander Ivlev on 27/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Entities

public typealias SteamAchievementsSummaryResult = Result<SteamAchievementsSummary, ServiceError>

public struct SteamAchievementsSummary {
    public let current: Set<SteamAchievementID>
    public let any: Set<SteamAchievementID>
    public let onlyVisible: Set<SteamAchievementID>

    public init(current: Set<SteamAchievementID>,
                any: Set<SteamAchievementID>,
                onlyVisible: Set<SteamAchievementID>) {
        self.current = current
        self.any = any
        self.onlyVisible = onlyVisible
    }
}
