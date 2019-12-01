//
//  CustomGameInfoPresenterConfigurator.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Services

final class CustomGameInfoPresenterConfigurator
{
    private weak var view: CustomGameInfoViewContract?
    private let customPresenters: [CustomGameInfoPresenter]

    init(view: CustomGameInfoViewContract, customPresenters: [CustomGameInfoPresenter]) {
        self.view = view
        self.customPresenters = customPresenters.sorted(by: { $0.priority > $1.priority })
    }

    func configure(steamId: SteamID, gameId: SteamGameID) {
        var order: UInt = 0

        for presenter in customPresenters {
            var sectionCount = presenter.requestSectionsCount(gameId: gameId)
            presenter.orders = []
            while sectionCount > 0 {
                presenter.orders.append(order)
                order += 1
                sectionCount -= 1
            }
        }

        for presenter in customPresenters {
            if !presenter.orders.isEmpty {
                presenter.configure(steamId: steamId, gameId: gameId)
            }
        }
    }

    func refresh(steamId: SteamID, gameId: SteamGameID) {
        for presenter in customPresenters {
           if !presenter.orders.isEmpty {
               presenter.refresh(steamId: steamId, gameId: gameId)
           }
       }
    }
}
