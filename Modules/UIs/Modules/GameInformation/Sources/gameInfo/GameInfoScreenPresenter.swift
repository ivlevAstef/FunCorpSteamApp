//
//  GameInfoScreenPresenter.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 26/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Services

protocol GameInfoScreenViewContract: class
{
    var needUpdateNotifier: Notifier<Void> { get }

    func beginLoading()

    func endLoadingGameInfo(_ success: Bool)

    func showGameInfo(_ gameInfo: GameInfoViewModel)

    func showError(_ text: String)
}

final class GameInfoScreenPresenter
{
    private let view: GameInfoScreenViewContract

    private let profileGamesService: SteamProfileGamesService
    private let imageService: ImageService

    private var cachedGameInfoViewModel: GameInfoViewModel?
    private var isFirstRefresh: Bool = true

    init(view: GameInfoScreenViewContract,
         profileGamesService: SteamProfileGamesService,
         imageService: ImageService) {
        self.view = view
        self.profileGamesService = profileGamesService
        self.imageService = imageService
    }

    func configure(steamId: SteamID, gameId: SteamGameID) {
        profileGamesService.getGameNotifier(for: steamId, gameId: gameId).weakJoin(listener: { (self, result) in
            self.processProfileGameInfoResult(result)
        }, owner: self)

        view.needUpdateNotifier.join(listener: { [weak self] in
            self?.refresh(for: steamId, gameId: gameId)
        })
    }

    private func refresh(for steamId: SteamID, gameId: SteamGameID) {
        if isFirstRefresh {
            view.beginLoading()

            profileGamesService.refreshGame(for: steamId, gameId: gameId) { [weak view] success in
                view?.endLoadingGameInfo(success)
            }
        } else {
            profileGamesService.refreshGame(for: steamId, gameId: gameId)
        }
        isFirstRefresh = false
    }

    // MARK: - game

    private func processProfileGameInfoResult(_ result: SteamProfileGameInfoResult) {
        switch result {
        case .failure(.cancelled):
            break
        case .failure(.notConnection):
            view.showError(loc["Errors.NotConnect"])
        case .failure(.notFound), .failure(.incorrectResponse):
            view.showError(loc["Errors.IncorrectResponse"])

        case .success(let game):
            processGameInfo(game)
        }
    }

    private func processGameInfo(_ profileGameInfo: SteamProfileGameInfo) {
        let viewModel = GameInfoViewModel(
            icon: cachedGameInfoViewModel?.icon ?? ChangeableImage(placeholder: nil, image: nil),
            name: profileGameInfo.gameInfo.name,
            playtimeForeverPrefix: loc["SteamGame.PlayTimeForeverPrefix"],
            playtimeForever: profileGameInfo.playtimeForever,
            playtime2weeksPrefix: loc["SteamGame.PlayTime2weeksPrefix"],
            playtime2weeks: profileGameInfo.playtime2weeks
        )
        cachedGameInfoViewModel = viewModel

        imageService.fetch(url: profileGameInfo.gameInfo.iconUrl, to: viewModel.icon)

        view.showGameInfo(viewModel)
    }
}
