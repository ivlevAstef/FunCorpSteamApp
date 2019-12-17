//
//  DotaAvgScores.swift
//  UseCases
//
//  Created by Alexander Ivlev on 05/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public struct DotaAvgScores
{
    public let kills: Double
    public let deaths: Double
    public let assists: Double
    public let lastHits: Double
    public let denies: Double
    /// gold per minute
    public let gpm: Double
    /// xp per minute
    public let xpm: Double

    public let level: Double

    private init() { fatalError("Not support empty initialization") }
}

extension DotaAvgScores
{
    public init(
        kills: Double,
        deaths: Double,
        assists: Double,
        lastHits: Double,
        denies: Double,
        gpm: Double,
        xpm: Double,
        level: Double
    ) {
        self.kills = kills
        self.deaths = deaths
        self.assists = assists
        self.lastHits = lastHits
        self.denies = denies
        self.gpm = gpm
        self.xpm = xpm
        self.level = level
    }
}
