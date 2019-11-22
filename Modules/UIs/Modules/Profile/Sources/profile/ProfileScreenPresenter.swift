//
//  ProfileScreenPresenter.swift
//  Profile
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Core
import Services

protocol ProfileScreenViewContract: class
{
    var needUpdateNotifier: Notifier<Void> { get }

    func beginLoading(_ text: String)
    func endLoading()

    func showError(_ text: String)

    func showProfile(_ profile: SteamProfile)
}

final class ProfileScreenPresenter
{
    private let view: ProfileScreenViewContract
    private let authService: SteamAuthService
    private let profileService: SteamProfileService
    private var subscriber: SteamProfileServiceSubscriber?

    init(view: ProfileScreenViewContract,
         authService: SteamAuthService,
         profileService: SteamProfileService) {
        self.view = view
        self.authService = authService
        self.profileService = profileService
    }

    func configure(steamId: SteamID) {
        var isLoading = true
        view.beginLoading("Подождите профиль подгружается")
        subscriber = profileService.join(to: steamId, callback: { [weak self, weak view] result in
            if isLoading {
                view?.endLoading()
                isLoading = false
            }
            self?.processProfileResult(result)
        })

        subscribeOnView(for: steamId)
    }

    private func subscribeOnView(for steamId: SteamID) {
        view.needUpdateNotifier.join(listener: { [profileService] in
            profileService.update(by: steamId)
        })
    }

    private func processProfileResult(_ result: SteamProfileResult) {
        switch result {
        case .failure(.cancelled):
            break

        case .failure(.notConnection):
            view.showError("Нет подключения к сети")

        case .failure(.notFound), .failure(.incorrectResponse):
            view.showError("Что-то пошло не так, повторите операцию позже")

        case .success(let profile):
            view.showProfile(profile)
        }
    }
}
