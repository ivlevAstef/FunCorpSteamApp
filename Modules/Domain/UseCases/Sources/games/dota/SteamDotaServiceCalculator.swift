//
//  SteamDotaService.swift
//  UseCases
//
//  Created by Alexander Ivlev on 04/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Entities

/// Различные функции подсчета данных
public protocol SteamDotaServiceCalculator: class
{
    func player(for accountId: AccountID, in details: DotaMatchDetails) -> DotaMatchDetails.Player?

    /// Подсчитывает статистику побед/поражений из переданных игр. unknown это то количество, в скольких играх не нашелся данный игрок
    func winLoseCount(for accountId: AccountID, details: [DotaMatchDetails]) -> DotaWinLose

    /// Подсчитывает статистику усредненных показателей из переданных игр.
    func avgScores(for accountId: AccountID, details: [DotaMatchDetails]) -> DotaAvgScores
}
