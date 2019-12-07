//
//  DotaStatisticsScreenPresenter.swift
//  Dota
//
//  Created by Alexander Ivlev on 06/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

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
        title: "Победы/Поражения:",
        avgPrefix: "В среднем: ",
        supportedIntervals: [.day, .week, .month],
        valueNames: ["Победы", "Поражения"]
    )
    /// Три числа - Убийства, Смерти, Ассисты
    private var kdaStatistic: DotaStatisticViewModel = DotaStatisticViewModel(
        title: "Убийства/Смерти/Ассисты:",
        avgPrefix: "В среднем: ",
        supportedIntervals: [.indicator, .day, .week, .month],
        valueNames: ["Убийства", "Смерти", "Ассисты"]
    )
    /// Одно число - количество добитых крипов
    private var lastHitsStatistic: DotaStatisticViewModel = DotaStatisticViewModel(
        title: "Добитых крипов",
        avgPrefix: "В среднем",
        supportedIntervals: [.indicator, .day, .week, .month],
        valueNames: ["Добитых крипов"]
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
        let matches: [DotaMatchDetails]
        switch result {
        case .actual(let actualMatches):
            matches = actualMatches
        case .notActual(let notActualMatches):
            matches = notActualMatches
        case .failure(let error):
            processError(error)
            return
        }

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

        winLoseStatistic.state = .done(indicators: winLoseList)
        kdaStatistic.state = .done(indicators: kdaList)
        lastHitsStatistic.state = .done(indicators: lastHitsList)

        view?.setStatistics(statistics)
    }

    private func processError(_ error: ServiceError) {
        switch error {
        case .cancelled, .incorrectResponse, .customError:
            break
        case .notConnection:
            view?.showError(loc["Errors.NotConnect"])
        }

        winLoseStatistic.state = .failed
        kdaStatistic.state = .failed
        lastHitsStatistic.state = .failed
        view?.setStatistics(statistics)
    }
}

