//
//  DotaGameInfoPresenter.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services


final class DotaGameInfoPresenter: CustomGameInfoPresenter
{
    let priority: Int = 0
    var orders: [UInt] = []

    private weak var view: CustomGameInfoViewContract?
    private let dotaService: SteamDotaService
    private let dotaCalculator: SteamDotaServiceCalculator
    private let imageService: ImageService
    private var isFirstRefresh: Bool = true

    private let summaryConfigurator = Dota2WeeksSummaryConfigurator()
    private let lastGameConfigurator = DotaLastGameConfigurator()

    init(view: CustomGameInfoViewContract,
         dotaService: SteamDotaService,
         dotaCalculator: SteamDotaServiceCalculator,
         imageService: ImageService) {
        self.view = view
        self.dotaService = dotaService
        self.dotaCalculator = dotaCalculator
        self.imageService = imageService
    }


    func requestSectionsCount(gameId: SteamGameID) -> UInt {
        if gameId == dotaService.gameId {
            return 2
        }
        return 0
    }

    func configure(steamId: SteamID, gameId: SteamGameID) {
        view?.addCustomSection(title: loc["Games.Dota2.lastGame.title"],
        order: orders[0],
        configurators: [lastGameConfigurator])

        view?.addCustomSection(title: loc["Games.Dota2.2weeksStats.title"],
                               order: orders[1],
                               configurators: [summaryConfigurator])

        /// Устанавливаем начальное состояние - обычно это прогресс
        view?.updateCustom(configurator: lastGameConfigurator)
        view?.updateCustom(configurator: summaryConfigurator)
    }

    func refresh(steamId: SteamID, gameId: SteamGameID) {
        dotaService.lastMatch(for: steamId.accountId) { [weak self] result in
            self?.processLastMatchResult(result, for: steamId.accountId)
        }

        dotaService.matchesInLast2weeks(for: steamId.accountId) { [weak self] result in
            self?.processMatchesIn2WeeksResult(result)
        }
        dotaService.detailsInLast2weeks(for: steamId.accountId) { [weak self] result in
            self?.processDetailsIn2WeeksResult(result, for: steamId.accountId)
        }
    }

    // MARK: - last match

    private func processLastMatchResult(_ result: SteamDotaCompletion<DotaMatchDetails?>, for accountId: AccountID) {
        switch result {
            case .actual(let details):
                print("!!DOTA LAST actual: \(details)")
            case .notActual(let details):
                print("!!DOTA LAST not actual: \(details)")
            case .failure(let error):
            print("!!DOTA LAST failure: \(error)")
        }
    }

    // MARK: - summary

    private func processMatchesIn2WeeksResult(_ result: SteamDotaCompletion<Int>) {
        defer {
            view?.updateCustom(configurator: summaryConfigurator)
        }

        let count: Int
        switch result {
        case .actual(let actualCount):
            count = actualCount
        case .notActual(let notActualCount):
            count = notActualCount
        case .failure(let error):
            processFailureError(error)
            summaryConfigurator.gamesCountViewModel = .failed
            return
        }

        summaryConfigurator.gamesCountViewModel = .done(
            Dota2WeeksGamesCountViewModel(prefix: loc["Games.Dota2.2weeksStats.count"], count: count)
        )
    }

    private func processDetailsIn2WeeksResult(_ result: SteamDotaCompletion<[DotaMatchDetails]>, for accountId: AccountID) {
        defer {
            view?.updateCustom(configurator: summaryConfigurator)
        }

        let details: [DotaMatchDetails]
        switch result {
        case .actual(let actualDetails):
            details = actualDetails
        case .notActual(let notActualDetails):
            details = notActualDetails
        case .failure(let error):
            processFailureError(error)
            summaryConfigurator.detailsViewModel = .failed
            return
        }

        let winLose = dotaCalculator.winLoseCount(for: accountId, details: details)
        let avgScores = dotaCalculator.avgScores(for: accountId, details: details)

        // Такое весело округление, чтобы восхвалять игрока :D на самом деле, времени нет
        summaryConfigurator.detailsViewModel = .done(Dota2WeeksDetailsViewModel(
            winPrefix: loc["Games.Dota2.2weeksStats.wins"], win: winLose.win,
            avgKillsPrefix: loc["Games.Dota2.2weeksStats.kills"], avgKills: Int(ceil(avgScores.kills)),
            avgDeathsPrefix: loc["Games.Dota2.2weeksStats.deaths"], avgDeaths: Int(floor(avgScores.deaths)),
            avgAssistsPrefix: loc["Games.Dota2.2weeksStats.assists"], avgAssists: Int(ceil(avgScores.assists)),
            avgLastHitsPrefix: loc["Games.Dota2.2weeksStats.lastHits"], avgLastHits: Int(ceil(avgScores.lastHits)),
            avgDeniesPrefix: loc["Games.Dota2.2weeksStats.denies"], avgDenies: Int(ceil(avgScores.denies)),
            avgGPMPrefix: loc["Games.Dota2.2weeksStats.gpm"], avgGPM: Int(ceil(avgScores.gpm))
        ))
    }

    // MARK: - support

    private func processFailureError(_ error: ServiceError) {
        switch error {
        case .cancelled, .incorrectResponse:
            break
        case .notConnection:
            view?.showError(loc["Errors.NotConnect"])

        case .customError(let dotaError as SteamDotaError):
            if dotaError == .notAllowed {
                summaryConfigurator.gamesCountViewModel = .failed
                summaryConfigurator.detailsViewModel = .failed
                view?.updateCustom(configurator: summaryConfigurator)

                view?.showError(loc["Games.Dota2.Errors.NotAllowed"])
            }
        case .customError:
            break
        }
    }
}
