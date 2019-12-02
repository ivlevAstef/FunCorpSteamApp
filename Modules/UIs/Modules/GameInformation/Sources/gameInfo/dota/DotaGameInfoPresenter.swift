//
//  DotaGameInfoPresenter.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Services


final class DotaGameInfoPresenter: CustomGameInfoPresenter
{
    let priority: Int = 0
    var orders: [UInt] = []

    private weak var view: CustomGameInfoViewContract?
    private var isFirstRefresh: Bool = true

    init(view: CustomGameInfoViewContract) {
        self.view = view
    }


    func requestSectionsCount(gameId: SteamGameID) -> UInt {
        if gameId == 570 {
            return 2
        }
        return 0
    }

    func configure(steamId: SteamID, gameId: SteamGameID) {

        view?.addCustomSection(title: "Dota2", order: orders[0], styles: [.dota, .dota])
        view?.addCustomSection(title: "Team fortres", order: orders[1], styles: [.dota, .dota])

        view?.failedCustomLoading(order: orders[0], row: 0)
        view?.showCustom(CustomViewModel(), order: orders[1], row: 1)
    }

    func refresh(steamId: SteamID, gameId: SteamGameID) {

    }
}
