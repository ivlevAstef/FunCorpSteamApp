//
//  DotaNavigator.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 06/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import Services
import SwiftLazy

/// И тут откуда не возьмись навигатор. Ну что поделаешь, если прокидывать для потенциально кучи кастомных ячеек данные на верх, как у ротинга, точно не вариант?
protocol DotaNavigator: class
{
    func showDotaStatistics(for steamId: SteamID)
}

typealias DotaStatisticsScreen = Screen<DotaStatisticsScreenView, DotaStatisticsScreenPresenter>

/// Да он не является наследником протокола, в силу не возможности получения обычного навигатора. Поэтому протокол реализует другой класс - Router.
final class DotaNavigatorImpl
{
    /*dependency*/var statisticsProvider = Provider<DotaStatisticsScreen>()

    init() {
    }

    func showDotaStatistics(for steamId: SteamID, on navigator: Navigator) {
        let screen = statisticsProvider.value

        screen.presenter.configure(steamId: steamId)

        navigator.push(screen.view, animated: true)
    }
}
