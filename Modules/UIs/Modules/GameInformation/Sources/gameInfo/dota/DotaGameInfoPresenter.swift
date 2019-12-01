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
            return 3
        }
        return 0
    }

    func configure(steamId: SteamID, gameId: SteamGameID) {

        view?.addCustomSection(title: "Dota2", style: .dota, order: orders[0])
        view?.addCustomSection(title: "Dota10", style: .dota, order: orders[1])
        view?.addCustomSection(title: "Team fortres", style: .dota, order: orders[2])

        view?.failedCustomLoading(style: .dota, order: orders[1])

        view?.showCustom(CustomViewModel(), order: orders[2])
    }

    func refresh(steamId: SteamID, gameId: SteamGameID) {

    }
}
