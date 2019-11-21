//
//  AuthScreenPresenter.swift
//  Profile
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Core
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
    let authSuccessNotifier = Notifier<Void>()

    private let view: AuthScreenViewContract
    private let authService: SteamAuthService

    init(view: AuthScreenViewContract, authService: SteamAuthService) {
        self.view = view
        self.authService = authService

        subscribeOn(view)
        view.setInformationText(loc["SteamAuth.Information"])
    }

    private func subscribeOn(_ view: AuthScreenViewContract) {
        view.startSteamAuthNotifier.join(listener: { [weak self, authService] in
            self?.view.blockUI()
            log.info("Start authorization in steam")
            authService.login { result in
                self?.processLoginResult(result)
                self?.view.unblockUI()
            }
        })
    }

    private func processLoginResult(_ result: Result<SteamID, SteamLoginError>) {
        switch result {
        case .success(_):
            log.info("Success authorization in steam")
            authSuccessNotifier.notify(())

        case .failure(.yourLoggedIn):
            log.assert("Call login, but your logged in")
            view.showError(loc["SteamAuth.Error.YourLoggedIn"])
            authSuccessNotifier.notify(())

        case .failure(.applicationIncorrectConfigured):
            log.assert("... but application correct configured :)")
            view.showError(loc["SteamAuth.Error.UnsupportAuth"])

        case .failure(.incorrectResponse):
            log.info("Failed authorization in steam")
            view.showError(loc["SteamAuth.Error.FailedAuth"])

        case .failure(.userCancel):
            log.info("Cancel authorization in steam")
        }
    }
}
