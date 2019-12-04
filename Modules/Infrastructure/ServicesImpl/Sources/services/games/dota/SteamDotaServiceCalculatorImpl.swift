//
//  SteamDotaServiceCalculatorImpl.swift
//  ServicesImpl
//
//  Created by Alexander Ivlev on 04/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

final class SteamDotaServiceCalculatorImpl: SteamDotaServiceCalculator
{
    func winLoseCount(for accountId: AccountID, details detailsList: [DotaMatchDetails]) -> (win: Int, lose: Int, unknown: Int) {
        var win: Int = 0
        var lose: Int = 0
        var unknown: Int = 0
        for details in detailsList {
            guard let accountPlayer = details.players.first(where: { $0.accountId == accountId }) else {
                unknown += 1
                continue
            }
            if accountPlayer.side == details.winSide {
                win += 1
            } else {
                lose += 1
            }
        }

        return (win: win, lose: lose, unknown: unknown)
    }
}
