//
//  ProfileScreenPresenter.swift
//  Profile
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Core
import Services
import UIComponents

protocol ProfileScreenViewContract: class
{
    var needUpdateNotifier: Notifier<Void> { get }

    func showError(_ text: String)

    func setGamesSectionText(_ text: String)
    func beginLoadingGames()
    func endLoadingGames(_ success: Bool)

    func showGamesInfo(_ games: [ProfileGameInfoViewModel])
}

final class ProfileScreenPresenter
{
    private let view: ProfileScreenViewContract
    private let authService: SteamAuthService
    private let profileGamesService: SteamProfileGamesService
    private let avatarService: AvatarService

    init(view: ProfileScreenViewContract,
         authService: SteamAuthService,
         profileGamesService: SteamProfileGamesService,
         avatarService: AvatarService) {
        self.view = view
        self.authService = authService
        self.profileGamesService = profileGamesService
        self.avatarService = avatarService
    }

    func configure(steamId: SteamID) {
        view.setGamesSectionText("Ваши игры")

        profileGamesService.getNotifier(for: steamId).weakJoin(listener: { (self, result) in
            self.processProfileGamesInfoResult(result)
        }, owner: self)

        view.needUpdateNotifier.join(listener: { [profileGamesService] in
            profileGamesService.refresh(for: steamId)
        })
    }

    // MARK: - games

    private func processProfileGamesInfoResult(_ result: SteamProfileGamesInfoResult) {
        switch result {
        case .failure:
            break

        case .success(let games):
            processGamesInfo(games)
        }
    }

    private func processGamesInfo(_ profileGamesInfo: [SteamProfileGameInfo]) {
        let viewModels: [ProfileGameInfoViewModel] = profileGamesInfo.map { profileGame in
            let viewModel = ProfileGameInfoViewModel(
                icon: ChangeableImage(placeholder: nil, image: nil),
                name: profileGame.gameInfo.name,
                playtimePrefix: loc["SteamProfile.Game.PlayTimePrefix"],
                playtime: profileGame.playtimeForever
            )

            avatarService.fetch(url: profileGame.gameInfo.iconUrl, to: viewModel.icon)

            return viewModel
        }

        let sortedViewModels = viewModels.sorted(by: { lhs, rhs in
            lhs.playtime > rhs.playtime
        })

        view.showGamesInfo(sortedViewModels)
    }
}
