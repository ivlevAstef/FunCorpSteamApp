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

    func beginLoading()
    func endLoading(_ success: Bool)

    func showError(_ text: String)
    func showProfile(_ profile: ProfileViewModel)

    func showGames(_ games: [ProfileGameViewModel])
}

final class ProfileScreenPresenter
{
    private let view: ProfileScreenViewContract
    private let authService: SteamAuthService
    private let profileService: SteamProfileService
    private let profileGamesService: SteamProfileGamesService
    private let avatarService: AvatarService

    init(view: ProfileScreenViewContract,
         authService: SteamAuthService,
         profileService: SteamProfileService,
         profileGamesService: SteamProfileGamesService,
         avatarService: AvatarService) {
        self.view = view
        self.authService = authService
        self.profileService = profileService
        self.profileGamesService = profileGamesService
        self.avatarService = avatarService
    }

    func configure(steamId: SteamID) {
        profileService.getNotifier(for: steamId).weakJoin(listener: { (self, result) in
            self.processProfileResult(result)
        }, owner: self)

        profileGamesService.getNotifier(for: steamId).weakJoin(listener: { (self, result) in
            self.processProfileGamesResult(result)
        }, owner: self)


        view.beginLoading()
        profileService.refresh(for: steamId) { [weak view] success in
            view?.endLoading(success)
        }

        view.needUpdateNotifier.join(listener: { [profileService, profileGamesService] in
            profileService.refresh(for: steamId)
            profileGamesService.refresh(for: steamId)
        })
    }

    // MARK: - profile

    private func processProfileResult(_ result: SteamProfileResult) {
        switch result {
        case .failure(.cancelled):
            break

        case .failure(.notConnection):
            view.showError(loc["Errors.NotConnect"])

        case .failure(.notFound), .failure(.incorrectResponse):
            view.showError(loc["Errors.IncorrectResponse"])

        case .success(let profile):
            processProfile(profile)
        }
    }

    private func processProfile(_ profile: SteamProfile) {
        var viewModel = ProfileViewModel(
            avatar: ChangeableImage(placeholder: nil, image: nil),
            nick: profile.nickName
        )

        switch profile.visibilityState {
        case .private:
            break
        case .open(let data):
            viewModel.realName = data.realName
        }

        view.showProfile(viewModel)

        avatarService.fetch(url: profile.avatarURL, to: viewModel.avatar)
    }

    // MARK: - games

    private func processProfileGamesResult(_ result: SteamProfileGamesResult) {
        switch result {
        case .failure:
            break

        case .success(let games):
            processGames(games)
        }
    }

    private func processGames(_ games: [SteamProfileGame]) {
        let viewModels: [ProfileGameViewModel] = games.map { game in
            let viewModel = ProfileGameViewModel(
                icon: ChangeableImage(placeholder: nil, image: nil),
                name: game.name,
                playtimePrefix: loc["SteamProfile.Game.PlayTimePrefix"],
                playtime: game.playtimeForever
            )

            avatarService.fetch(url: game.iconUrl, to: viewModel.icon)

            return viewModel
        }

        let sortedViewModels = viewModels.sorted(by: { lhs, rhs in
            lhs.playtime > rhs.playtime
        })

        view.showGames(sortedViewModels)
    }
}
