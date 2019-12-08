//
//  DotaStatisticViewModel.swift
//  Dota
//
//  Created by Alexander Ivlev on 07/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import UIKit

struct DotaStatisticViewModel
{
    class ViewState {
        fileprivate(set) var selectedInterval: Interval = .day
        var to: Date = Date()
        fileprivate(set) var count: Int = 0

        fileprivate(set) var groupedIndicators: [Indicator] = []
    }

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

    enum ProgressState {
        case loading
        case failed
        case done(indicators: [Indicator])
    }

    let title: String
    let totalPrefix: String
    let supportedIntervals: [Interval]
    let valueNames: [String]
    let valueColors: [UIColor]

    var progressState: ProgressState = .loading
    let state: ViewState = ViewState()
}

extension DotaStatisticViewModel
{
    func updateInterval(on newInterval: Interval, force: Bool = false) {
        if newInterval == state.selectedInterval && !force {
            return
        }
        guard case .done(let indicators) = progressState else {
            return
        }

        state.selectedInterval = newInterval

        switch newInterval {
        case .indicator:
            state.count = 10
            state.groupedIndicators = indicators
        case .day:
            state.count = 7
            state.groupedIndicators = grouped(indicators: indicators, by: [.day, .month, .year]) { lhs, rhs in
                lhs.day == rhs.day && lhs.month == rhs.month && lhs.year == rhs.year
            }
        case .week:
            state.count = 6
            state.groupedIndicators = grouped(indicators: indicators, by: [.weekOfYear, .year]) { lhs, rhs in
                lhs.weekOfYear == rhs.weekOfYear && lhs.year == rhs.year
            }
        case .month:
            state.count = 6
            state.groupedIndicators = grouped(indicators: indicators, by: [.month, .year]) { lhs, rhs in
                lhs.month == rhs.month && lhs.year == rhs.year
            }
        }

        if let toIndicatorIndex = state.nearGroupedIndicatorIndex(to: state.to) {
            state.to = state.groupedIndicators[toIndicatorIndex].date
        }
    }

    private func grouped(indicators: [Indicator], by components: Set<Calendar.Component>, compare: (DateComponents, DateComponents) -> Bool) -> [Indicator] {
        guard var stash = indicators.last else {
            return []
        }

        var groupedIndicators: [Indicator] = []

        for indicator in indicators.dropLast().reversed() {
            let stashComponents = Calendar.current.dateComponents(components, from: stash.date)
            let indicatorComponents = Calendar.current.dateComponents(components, from: indicator.date)

            if compare(stashComponents, indicatorComponents) {
                let values = zip(stash.values, indicator.values).map { $0 + $1 }
                stash = Indicator(values: values, date: stash.date)
            } else {
                groupedIndicators.append(stash)
                stash = indicator
            }
        }
        groupedIndicators.append(stash)

        return groupedIndicators.reversed()
    }
}

extension DotaStatisticViewModel.ViewState
{
    func updateFromDate(use index: Int) {
        let index = max(0, min(index + count, groupedIndicators.count - 1))

        to = groupedIndicators[index].date
    }

    var total: [Int] {
        guard let toIndex = nearGroupedIndicatorIndex(to: to) else {
            return [ 0 ]
        }

        let fromIndex = max(0, min(toIndex - count + 1, toIndex))

        var values = groupedIndicators[toIndex].values
        for index in fromIndex..<toIndex {
            values = zip(groupedIndicators[index].values, values).map { $0 + $1 }
        }

        return values
    }

    var from: Date {
        guard let toIndex = nearGroupedIndicatorIndex(to: to) else {
            return to
        }

        let fromIndex = max(0, toIndex - count + 1)
        return groupedIndicators[fromIndex].date
    }

    var fromIndex: Int? {
        return nearGroupedIndicatorIndex(to: from)
    }

    fileprivate func nearGroupedIndicatorIndex(to date: Date) -> Int? {
        return groupedIndicators.enumerated().min {
            abs($0.element.date.timeIntervalSince(date)) < abs($1.element.date.timeIntervalSince(date))
        }?.offset
    }
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

    var twoLineFormat: String {
        switch self {
        case .indicator:
            return "HH:mm\ndd.MM"
        case .day:
            return "dd.MM\nyyyy"
        case .week:
            return "ww\nyyyy"
        case .month:
            return "LLL\nyyyy"
        }
    }

    var fullyFormat: String {
        switch self {
        case .indicator:
            return "HH:mm dd LLLL yyyy"
        case .day:
            return "dd LLLL yyyy"
        case .week:
            return "ww LLLL yyyy"
        case .month:
            return "LLLL yyyy"
        }
    }
}
