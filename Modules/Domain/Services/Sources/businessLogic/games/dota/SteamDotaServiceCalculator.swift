//
//  SteamDotaService.swift
//  Services
//
//  Created by Alexander Ivlev on 04/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

/// Различные функции подсчета данных
public protocol SteamDotaServiceCalculator: class
{
    /// Подсчитывает статистику побед/поражений из переданных игр. unknown это то количество, в скольких играх не нашелся данный игрок
    func winLoseCount(for accountId: AccountID, details: [DotaMatchDetails]) -> (win: Int, lose: Int, unknown: Int)
}
