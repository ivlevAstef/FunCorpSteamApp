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
    private let dotaService: SteamDotaService
    private let dotaCalculator: SteamDotaServiceCalculator
    private let imageService: ImageService
    private var isFirstRefresh: Bool = true

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
        let configurators: [CustomTableCellConfigurator] = [
            DotaTableCellConfigurator(),
            DotaTableCellConfigurator(),
        ]

        view?.addCustomSection(title: "Dota2", order: orders[0], configurators: configurators)
        view?.addCustomSection(title: "Team fortres", order: orders[1], configurators: configurators)

        view?.failedCustomLoading(order: orders[0], row: 0)
        view?.showCustom(order: orders[1], row: 1)
    }

    func refresh(steamId: SteamID, gameId: SteamGameID) {
        dotaService.matchesInLast2weeks(for: steamId.accountId) { result in
            switch result {
            case .actual(let count):
                print("!!DOTA actual: \(count)")
            case .notActual(let count):
                print("!!DOTA not actual: \(count)")
            case .failure(let error):
            print("!!DOTA failure: \(error)")
            }
        }

        dotaService.lastMatch(for: steamId.accountId) { result in
            switch result {
                case .actual(let details):
                    print("!!DOTA LAST actual: \(details)")
                case .notActual(let details):
                    print("!!DOTA LAST not actual: \(details)")
                case .failure(let error):
                print("!!DOTA LAST failure: \(error)")
            }
        }

        dotaService.detailsInLast2weeks(for: steamId.accountId) { [dotaCalculator] result in
            var resultDetails: [DotaMatchDetails] = []
            switch result {
                case .actual(let details):
                    resultDetails = details
                    print("!!DOTA Details actual: \(details.count)")
                case .notActual(let details):
                    resultDetails = details
                    print("!!DOTA Details not actual: \(details.count)")
                case .failure(let error):
                print("!!DOTA WIN/LOSE failure: \(error)")
            }

            let (win, lose, unknown) = dotaCalculator.winLoseCount(for: steamId.accountId, details: resultDetails)
            print("!!DOTA w/s/u: \(win), \(lose), \(unknown)")
        }
    }
}
