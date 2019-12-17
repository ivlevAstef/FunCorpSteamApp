//
//  DotaGameInfoPresenter.swift
//  Dota
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Entities
import UseCases
import GameInformation //TODO: CustomGameInformation

final class DotaGameInfoPresenter: CustomGameInfoPresenter
{
    let priority: Int = 0
    var orders: [UInt] = []

    let tapSummaryNotifier = Notifier<Void>()

    private weak var view: CustomGameInfoViewContract?
    private let dotaService: SteamDotaService
    private let dotaCalculator: SteamDotaServiceCalculator
    private let imageService: ImageService

    private let summaryConfigurator = Dota2WeeksSummaryConfigurator()
    private let lastMatchConfigurator = DotaLastMatchConfigurator()

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
        configurators: [lastMatchConfigurator])

        view?.addCustomSection(title: loc["Games.Dota2.2weeksStats.title"],
                               order: orders[1],
                               configurators: [summaryConfigurator])

        summaryConfigurator.tapNotifier.join(tapSummaryNotifier)

        /// Устанавливаем начальное состояние - обычно это прогресс
        view?.updateCustom(configurator: lastMatchConfigurator)
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
        defer {
            view?.updateCustom(configurator: lastMatchConfigurator)
        }

        let optDetails: DotaMatchDetails?
        switch result {
        case .actual(let actualDetails):
            optDetails = actualDetails
        case .notActual(let notActualDetails):
            optDetails = notActualDetails
        case .failure(let error):
            processFailureError(error)
            lastMatchConfigurator.lastMatchViewModel = .failed
            return
        }

        guard let details = optDetails, let player = dotaCalculator.player(for: accountId, in: details) else {
            view?.removeCustomSection(order: orders[0])
            return
        }


        dotaService.getHero(for: player.heroId, loc: .current, completion: { [weak self] result in
            self?.processLastMatchResult(result, player: player, details: details)
        })
    }

    private func processLastMatchResult(_ result: SteamDotaCompletion<DotaHero?>,
                                        player: DotaMatchDetails.Player,
                                        details: DotaMatchDetails) {
        let hero: DotaHero?
        switch result {
        case .actual(let actualHero):
            hero = actualHero
        case .notActual(let actualHero):
            hero = actualHero
        default:
            hero = nil
        }

        var lastHeroImage: ChangeableImage?
        if case .done(let viewModel) = lastMatchConfigurator.lastMatchViewModel {
            lastHeroImage = viewModel.heroImage
        }

        let viewModel = DotaLastMatchViewModel(
            heroImage: lastHeroImage ?? ChangeableImage(placeholder: nil, image: nil),
            heroName: hero?.name.uppercased() ?? loc["Games.Dota2.lastGame.heroNotFound"],
            kdaText: loc["Games.Dota2.lastGame.kda"],
            kills: Int(player.kills), deaths: Int(player.deaths), assists: Int(player.assists),
            startTime: details.startTime,
            durationText: loc["Games.Dota2.lastGame.duration"], duration: details.duration,
            resultText: loc["Games.Dota2.lastGame.result"],
            isWin: player.side == details.winSide,
            winText: loc["Games.Dota2.lastGame.win"], loseText: loc["Games.Dota2.lastGame.lose"]
        )

        imageService.fetch(url: hero?.iconFullVerticalURL, to: viewModel.heroImage)

        lastMatchConfigurator.lastMatchViewModel = .done(viewModel)

        view?.updateCustom(configurator: lastMatchConfigurator)
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
                lastMatchConfigurator.lastMatchViewModel = .failed
                view?.updateCustom(configurator: summaryConfigurator)

                view?.showError(loc["Games.Dota2.Errors.NotAllowed"])
            }
        case .customError:
            break
        }
    }
}
