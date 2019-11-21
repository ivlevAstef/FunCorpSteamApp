//
//  AuthScreenPresenter.swift
//  Profile
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Services

protocol AuthScreenViewContract: class
{
    var startSteamAuthNotifier: Notifier<Void> { get }

    func blockUI()
    func unblockUI()

    func setInformationText(_ text: String)
    func showError(_ text: String)
}

final class AuthScreenPresenter
{
    private let view: AuthScreenViewContract
    private let steamAuthService: SteamAuthService

    init(view: AuthScreenViewContract, steamAuthService: SteamAuthService) {
        self.view = view
        self.steamAuthService = steamAuthService

        subscribeOn(view)
        view.setInformationText("Для того чтобы залогинится в стим надо нажать кнопку :)")
    }

    private func subscribeOn(_ view: AuthScreenViewContract) {
        view.startSteamAuthNotifier.join(listener: { [weak self, steamAuthService] in
            self?.view.blockUI()
            steamAuthService.login { result in
                self?.processLoginResult(result)
                self?.view.unblockUI()
            }
        })
    }

    private func processLoginResult(_ result: Result<SteamID, SteamLoginError>) {
        switch result {
        case .success(let steamId):
            print("Success")
        case .failure(.yourLoggedIn):
            log.assert("Call login, but your logged in")
            view.showError("Вы уже залогинены")
        case .failure(.applicationIncorrectConfigured):
            log.assert("... but application correct configured :)")
            view.showError("К сожалению функция входа в steam не доступна")
        case .failure(.incorrectResponse):
            view.showError("Steam Не смог вас авторизовать")
        case .failure(.userCancel):
            break
        }
    }
}
