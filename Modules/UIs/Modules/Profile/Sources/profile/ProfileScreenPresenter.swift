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

    func setGamesSectionText(_ text: String)

    func beginLoading()

    func failedLoadingProfile()
    func failedLoadingGames()

    func showProfile(_ profile: ProfileViewModel)
    func showGamesInfo(_ games: [ProfileGameInfoViewModel])

    func showError(_ text: String)
}

final class ProfileScreenPresenter
{
    let tapOnProfileNotifier = Notifier<SteamID>()
    let tapOnGameNotifier = Notifier<(SteamID, SteamGameID)>()

    private weak var view: ProfileScreenViewContract?
    // TODO: из auth service можно свой steamId узнать, и понять твой профиль или нет - как-нибудь менять интерфейс.
    private let authService: SteamAuthService
    private let profileService: SteamProfileService
    private let profileGamesService: SteamProfileGamesService
    private let imageService: ImageService

    // При первом обновлении показываем индикацию, при всех последующих в фоне
    private var isFirstRefresh: Bool = true
    private var cachedProfileViewModel: ProfileViewModel?
    private var cachedGameInfoViewModels: [SteamGameID: ProfileGameInfoViewModel] = [:]

    init(view: ProfileScreenViewContract,
         authService: SteamAuthService,
         profileService: SteamProfileService,
         profileGamesService: SteamProfileGamesService,
         imageService: ImageService) {
        self.view = view
        self.authService = authService
        self.profileService = profileService
        self.profileGamesService = profileGamesService
        self.imageService = imageService
    }

    func configure(steamId: SteamID) {
        view?.setGamesSectionText(loc["SteamProfile.Games"])

        profileService.getNotifier(for: steamId).weakJoin(listener: { (self, result) in
            self.processProfileResult(result)
        }, owner: self)
        profileGamesService.getGamesNotifier(for: steamId).weakJoin(listener: { (self, result) in
            self.processProfileGamesInfoResult(result)
        }, owner: self)

        view?.needUpdateNotifier.join(listener: { [weak self] in
            self?.refresh(for: steamId)
        })
    }

    private func refresh(for steamId: SteamID) {
        if isFirstRefresh {
            view?.beginLoading()

            profileService.refresh(for: steamId) { [weak view] success in
                if !success {
                    view?.failedLoadingProfile()
                }
            }
            profileGamesService.refreshGames(for: steamId) { [weak view] success in
                if !success {
                    view?.failedLoadingGames()
                }
            }
        } else {
            profileService.refresh(for: steamId)
            profileGamesService.refreshGames(for: steamId)
        }
        isFirstRefresh = false
    }

    // MARK: - profile

    private func processProfileResult(_ result: SteamProfileResult) {
        switch result {
        case .failure(.cancelled), .failure(.incorrectResponse):
            break
        case .failure(.notConnection):
            view?.showError(loc["Errors.NotConnect"])

        case .success(let profile):
            processProfile(profile)
        }
    }

    private func processProfile(_ profile: SteamProfile) {
        guard let view = view else {
            return
        }

        var viewModel = ProfileViewModel(
            avatar: cachedProfileViewModel?.avatar ?? ChangeableImage(placeholder: nil, image: nil),
            avatarLetter: String(profile.nickName.prefix(2).uppercased()),
            nick: profile.nickName,
            tapNotifier: Notifier<Void>()
        )
        cachedProfileViewModel = viewModel

        viewModel.tapNotifier.weakJoin(tapOnProfileNotifier, owner: self) { (self, _) -> SteamID in
            return profile.steamId
        }

        switch profile.visibilityState {
        case .private:
            break
        case .open(let data):
            viewModel.realName = data.realName
        }

        view.showProfile(viewModel)

        imageService.fetch(url: profile.avatarURL, to: viewModel.avatar)
    }


    // MARK: - games

    private func processProfileGamesInfoResult(_ result: SteamProfileGamesInfoResult) {
        switch result {
        case .failure(.cancelled), .failure(.incorrectResponse):
            break
        case .failure(.notConnection):
            view?.showError(loc["Errors.NotConnect"])
        
        case .success(let games):
            processGamesInfo(games)
        }
    }

    private func processGamesInfo(_ profileGamesInfo: [SteamProfileGameInfo]) {
        guard let view = view else {
            return
        }

        let viewModels: [ProfileGameInfoViewModel] = profileGamesInfo.map { profileGame in
            let cachedViewModel = cachedGameInfoViewModels[profileGame.gameInfo.gameId]
            let viewModel = ProfileGameInfoViewModel(
                icon: cachedViewModel?.icon ?? ChangeableImage(placeholder: nil, image: nil),
                name: profileGame.gameInfo.name,
                playtimePrefix: loc["Game.PlayTimeForeverPrefix"],
                playtime: profileGame.playtimeForever,
                tapNotifier: Notifier<Void>()
            )
            cachedGameInfoViewModels[profileGame.gameInfo.gameId] = viewModel

            viewModel.tapNotifier.weakJoin(tapOnGameNotifier, owner: self) { (self, _) -> (SteamID, SteamGameID) in
                return (profileGame.steamId, profileGame.gameInfo.gameId)
            }

            imageService.deferredFetch(url: profileGame.gameInfo.iconUrl, to: viewModel.icon)

            return viewModel
        }

        let sortedViewModels = viewModels.sorted(by: { lhs, rhs in
            lhs.playtime > rhs.playtime
        })

        view.showGamesInfo(sortedViewModels)
    }
}
