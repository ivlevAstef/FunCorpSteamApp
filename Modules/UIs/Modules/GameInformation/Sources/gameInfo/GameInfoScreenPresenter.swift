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

    func setTitles(gameInfo: String, achievementsSummary: String)

    func beginLoading()

    func endLoadingGameInfo(_ success: Bool)
    func showGameInfo(_ gameInfo: GameInfoViewModel)

    func endLoadingAchievementsSummary(_ success: Bool)
    func showAchievementsSummary(_ achievementsSummary: AchievementsSummaryViewModel?)

    func showError(_ text: String)
}

final class GameInfoScreenPresenter
{
    private let view: GameInfoScreenViewContract

    private let profileGamesService: SteamProfileGamesService
    private let gameService: SteamGameService
    private let achievementService: SteamAchievementService
    private let imageService: ImageService

    private var cachedGameInfoViewModel: GameInfoViewModel?
    private var isFirstRefresh: Bool = true

    init(view: GameInfoScreenViewContract,
         profileGamesService: SteamProfileGamesService,
         gameService: SteamGameService,
         achievementService: SteamAchievementService,
         imageService: ImageService) {
        self.view = view
        self.profileGamesService = profileGamesService
        self.gameService = gameService
        self.achievementService = achievementService
        self.imageService = imageService
    }

    func configure(steamId: SteamID, gameId: SteamGameID) {
        view.setTitles(gameInfo: "", achievementsSummary: loc["SteamGame.AchievementsSummaryTitle"])

        profileGamesService.getGameNotifier(for: steamId, gameId: gameId).weakJoin(listener: { (self, result) in
            self.processProfileGameInfoResult(result)
        }, owner: self)
        achievementService.getAchievementsSummaryNotifier(for: gameId, steamId: steamId).weakJoin(listener: { (self, result) in
            self.processAchievementsSummaryResult(result)
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

            achievementService.refreshAchievementsSummary(for: gameId, steamId: steamId) { [weak view] success in
                view?.endLoadingAchievementsSummary(success)
            }
        } else {
            profileGamesService.refreshGame(for: steamId, gameId: gameId)
            achievementService.refreshAchievementsSummary(for: gameId, steamId: steamId)
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
        case .failure(.incorrectResponse):
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

    // MARK: - achievements summary

    private func processAchievementsSummaryResult(_ result: SteamAchievementsSummaryResult) {
        switch result {
        case .failure(.cancelled):
            break
        case .failure(.notConnection):
            view.showError(loc["Errors.NotConnect"])
        case .failure(.incorrectResponse):
            view.showError(loc["Errors.IncorrectResponse"])

        case .success(let achievementsSummary):
            processAchievementsSummary(achievementsSummary)
        }
    }

    private func processAchievementsSummary(_ achievementsSummary: SteamAchievementsSummary) {
        // у игры нет достижений - тогда можно вообще не показывать о них информацию
        if achievementsSummary.any.isEmpty {
            view.showAchievementsSummary(nil)
            return
        }

        let viewModel = AchievementsSummaryViewModel(
            prefix: loc["SteamGame.AchievementsSummaryPrefix"],
            current: achievementsSummary.current.count,
            any: achievementsSummary.any.count
        )

        view.showAchievementsSummary(viewModel)
    }
}
