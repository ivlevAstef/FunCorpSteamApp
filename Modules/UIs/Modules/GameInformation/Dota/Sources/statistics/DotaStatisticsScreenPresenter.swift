//
//  DotaStatisticsScreenPresenter.swift
//  Dota
//
//  Created by Alexander Ivlev on 06/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Entities
import UseCases

protocol DotaStatisticsScreenViewContract: class
{
   func setStatistics(_ viewModels: [DotaStatisticViewModel])

   func showError(_ text: String)
}

final class DotaStatisticsScreenPresenter
{
    private weak var view: DotaStatisticsScreenViewContract?
    private let dotaService: SteamDotaService
    private let dotaCalculator: SteamDotaServiceCalculator

    private var statistics: [DotaStatisticViewModel] {
        return [winLoseStatistic, kdaStatistic, lastHitsStatistic]
    }

    /// Два числа - первое количество побед, второе количество поражений. Индикатор не имеет смысла выводить - там или [1,0] или [0,1]
    private var winLoseStatistic: DotaStatisticViewModel = DotaStatisticViewModel(
        title: "Победы/Поражения",
        totalPrefix: "Всего: ",
        supportedIntervals: [.day, .week, .month],
        valueNames: ["Победы", "Поражения"],
        valueColors: [.green, .red]
    )
    /// Три числа - Убийства, Смерти, Ассисты
    private var kdaStatistic: DotaStatisticViewModel = DotaStatisticViewModel(
        title: "Убийства/Смерти/Ассисты",
        totalPrefix: "Всего: ",
        supportedIntervals: [.indicator, .day, .week, .month],
        valueNames: ["Убийства", "Смерти", "Ассисты"],
        valueColors: [.green, .red, .blue]
    )
    /// Одно число - количество добитых крипов
    private var lastHitsStatistic: DotaStatisticViewModel = DotaStatisticViewModel(
        title: "Добитых крипов",
        totalPrefix: "Всего: ",
        supportedIntervals: [.indicator, .day, .week, .month],
        valueNames: ["Добитых крипов"],
        valueColors: [.blue]
    )

    init(view: DotaStatisticsScreenViewContract,
         dotaService: SteamDotaService,
         dotaCalculator: SteamDotaServiceCalculator) {
        self.view = view
        self.dotaService = dotaService
        self.dotaCalculator = dotaCalculator
    }

    func configure(steamId: SteamID) {
        // TODO: сделано, быстро, поэтому не организованна постраничная загрузка.
        // В идеале конечно уметь запрашивать данные частями, и технически это можно, но ui надо делать дольше.
        dotaService.detailsInPeriod(for: steamId.accountId, from: Date(timeIntervalSince1970: 0), to: Date()) { [weak self] result in
            self?.processDetailsResult(result, steamId: steamId)
        }

        view?.setStatistics(statistics)
    }

    private func processDetailsResult(_ result: SteamDotaCompletion<[DotaMatchDetails]>, steamId: SteamID) {
        var matches: [DotaMatchDetails]
        switch result {
        case .actual(let actualMatches):
            matches = actualMatches
        case .notActual(let notActualMatches):
            matches = notActualMatches
        case .failure(let error):
            processError(error)
            return
        }
        matches.sort(by: { $0.startTime < $1.startTime })

        var winLoseList: [DotaStatisticViewModel.Indicator] = []
        var kdaList: [DotaStatisticViewModel.Indicator] = []
        var lastHitsList: [DotaStatisticViewModel.Indicator] = []

        for match in matches {
            guard let player = dotaCalculator.player(for: steamId.accountId, in: match) else {
                continue
            }
            let isWin = player.side == match.winSide
            winLoseList.append(DotaStatisticViewModel.Indicator(
                values: [isWin ? 1 : 0, isWin ? 0 : 1],
                date: match.startTime
            ))
            kdaList.append(DotaStatisticViewModel.Indicator(
                values: [Int(player.kills), Int(player.deaths), Int(player.assists)],
                date: match.startTime
            ))
            lastHitsList.append(DotaStatisticViewModel.Indicator(
                values: [Int(player.lastHits)],
                date: match.startTime
            ))
        }

        winLoseStatistic.progressState = .done(indicators: winLoseList)
        kdaStatistic.progressState = .done(indicators: kdaList)
        lastHitsStatistic.progressState = .done(indicators: lastHitsList)

        winLoseStatistic.updateInterval(on: winLoseStatistic.supportedIntervals[0], force: true)
        kdaStatistic.updateInterval(on: kdaStatistic.supportedIntervals[0], force: true)
        lastHitsStatistic.updateInterval(on: lastHitsStatistic.supportedIntervals[0], force: true)

        view?.setStatistics(statistics)
    }

    private func processError(_ error: ServiceError) {
        switch error {
        case .cancelled, .incorrectResponse, .customError:
            break
        case .notConnection:
            view?.showError(loc["Errors.NotConnect"])
        }

        winLoseStatistic.progressState = .failed
        kdaStatistic.progressState = .failed
        lastHitsStatistic.progressState = .failed
        view?.setStatistics(statistics)
    }
}

