//
//  SteamDotaServiceCalculatorImpl.swift
//  UseCasesImpl
//
//  Created by Alexander Ivlev on 04/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Entities
import UseCases

final class SteamDotaServiceCalculatorImpl: SteamDotaServiceCalculator
{
    func player(for accountId: AccountID, in details: DotaMatchDetails) -> DotaMatchDetails.Player? {
        return details.players.first(where: { $0.accountId == accountId })
    }

    func winLoseCount(for accountId: AccountID, details detailsList: [DotaMatchDetails]) -> DotaWinLose {
        var win: Int = 0
        var lose: Int = 0
        var unknown: Int = 0
        for details in detailsList {
            guard let player = details.players.first(where: { $0.accountId == accountId }) else {
                unknown += 1
                continue
            }
            if player.side == details.winSide {
                win += 1
            } else {
                lose += 1
            }
        }

        return DotaWinLose(win: win, lose: lose, unknown: unknown)
    }

    func avgScores(for accountId: AccountID, details detailsList: [DotaMatchDetails]) -> DotaAvgScores {
        var kills = 0.0
        var deaths = 0.0
        var assists = 0.0
        var lastHits = 0.0
        var denies = 0.0
        var gpm = 0.0
        var xpm = 0.0
        var level = 0.0

        var count: Int = 0
        for details in detailsList {
            guard let player = details.players.first(where: { $0.accountId == accountId }) else {
                continue
            }

            kills += Double(player.kills)
            deaths += Double(player.deaths)
            assists += Double(player.assists)
            lastHits += Double(player.lastHits)
            denies += Double(player.denies)
            gpm += Double(player.gpm)
            xpm += Double(player.xpm)
            level += Double(player.level)

            count += 1
        }

        if 0 == count {
            return DotaAvgScores(kills: 0, deaths: 0, assists: 0, lastHits: 0, denies: 0, gpm: 0, xpm: 0, level: 0)
        }

        return DotaAvgScores(
            kills: kills / Double(count),
            deaths: deaths / Double(count),
            assists: assists / Double(count),
            lastHits: lastHits / Double(count),
            denies: denies / Double(count),
            gpm: gpm / Double(count),
            xpm: xpm / Double(count),
            level: level / Double(count)
        )
    }
}
