//
//  DotaRouter.swift
//  Dota
//
//  Created by Alexander Ivlev on 06/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Core
import Services
import SwiftLazy
import GameInformation

typealias DotaStatisticsScreen = Screen<DotaStatisticsScreenView, DotaStatisticsScreenPresenter>

final class DotaRouter: CustomGameInfoRouter
{
    var statisticsProvider = Provider<DotaStatisticsScreen>()

    private var navigator: Navigator?
    private let gameInfoPresenter: DotaGameInfoPresenter
    private let dotaService: SteamDotaService

    init(gameInfoPresenter: DotaGameInfoPresenter, dotaService: SteamDotaService) {
        self.gameInfoPresenter = gameInfoPresenter
        self.dotaService = dotaService
    }

    func configure(navigator: Navigator, steamId: SteamID, gameId: SteamGameID) -> [CustomGameInfoPresenter] {
        if gameId == dotaService.gameId {
            self.navigator = navigator
            configureCustomPresenters(steamId: steamId, gameId: gameId)
            return [gameInfoPresenter]
        }
        return []
    }

    private func showDotaStatistics(for steamId: SteamID) {
        log.assert(navigator != nil, "Call show dota statistics but navigator is nil")

        let screen = statisticsProvider.value

        screen.presenter.configure(steamId: steamId)

        navigator?.push(screen.view, animated: true)
    }

    private func configureCustomPresenters(steamId: SteamID, gameId: SteamGameID) {
        gameInfoPresenter.tapSummaryNotifier.weakJoin(listener: { (self, _) in
            self.showDotaStatistics(for: steamId)
        }, owner: self)
    }
}
