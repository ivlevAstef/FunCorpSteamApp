//
//  DotaStatisticViewModel.swift
//  Dota
//
//  Created by Alexander Ivlev on 07/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

struct DotaStatisticViewModel
{
    enum Interval {
        /// Не группирует данные
        case indicator
        /// Группирует данные по дням
        case day
        /// Группирует данные по неделям
        case week
        /// Группирует данные по месяцам
        case month
    }

    struct Indicator {
        let values: [Int]
        let date: Date
    }

    enum State {
        case loading
        case failed
        case done(indicators: [Indicator])
    }

    let title: String
    let avgPrefix: String
    let supportedIntervals: [Interval]
    let valueNames: [String]

    var state: State = .loading
}

extension DotaStatisticViewModel.Interval
{
    var localize: String {
        switch self {
        case .indicator:
            return "Игры"
        case .day:
            return "Дни"
        case .week:
            return "Недели"
        case .month:
            return "Месяцы"
        }
    }
}
