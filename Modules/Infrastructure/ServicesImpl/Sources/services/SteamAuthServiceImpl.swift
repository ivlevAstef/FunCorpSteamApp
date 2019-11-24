//
//  SteamAuthServiceImpl.swift
//  ServicesImpl
//
//  Created by Alexander Ivlev on 20/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Services
import UIKit
import WebKit

private enum Consts {
    static let magicSteamIDMapNumber: SteamID = 76561197960265728
}

final class SteamAuthServiceImpl: SteamAuthService
{
    var isLogined: Bool { steamId != nil }
    var steamId: SteamID? {
        return authStorage.steamId
    }

    var accountId: AccountID? {
        return steamId.flatMap { AccountID($0 - Consts.magicSteamIDMapNumber) }
    }

    private let authStorage: SteamAuthStorage
    private let authNetwork: SteamAuthNetwork

    init(authStorage: SteamAuthStorage, authNetwork: SteamAuthNetwork) {
        self.authStorage = authStorage
        self.authNetwork = authNetwork
    }

    func login(completion: @escaping (Result<SteamID, SteamLoginError>) -> Void) {
        log.assert(Thread.isMainThread, "steam auth login worked only from main thread")
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            completion(.failure(.applicationIncorrectConfigured))
            return
        }

        if isLogined {
            completion(.failure(.yourLoggedIn))
            return
        }

        let steamLoginVC = SteamLoginViewController(authNetwork: authNetwork)
        steamLoginVC.successNotifier.join(listener: { [weak steamLoginVC, authStorage] steamId in
            authStorage.steamId = steamId
            completion(.success(steamId))
            steamLoginVC?.dismiss(animated: true)
        })
        steamLoginVC.failureNotifier.join(listener: { [weak steamLoginVC] in
            completion(.failure(.incorrectResponse))
            steamLoginVC?.dismiss(animated: true)
        })
        steamLoginVC.closeNotifier.join(listener: { [weak steamLoginVC] in
            completion(.failure(.userCancel))
            steamLoginVC?.dismiss(animated: true)
        })

        // На 13 оси и так все красиво смотриться
        if #available(iOS 13.0, *) {
            rootVC.present(steamLoginVC, animated: true)
        } else {
            // А вот на более старых стоит сделать покрасивее
            let navController = UINavigationController(rootViewController: steamLoginVC)

            steamLoginVC.title = loc["SteamAuth.Title"]
            steamLoginVC.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: steamLoginVC,
                action: #selector(SteamLoginViewController.clickCloseButton)
            )
            navController.navigationBar.isTranslucent = false
            navController.navigationBar.tintColor = .white
            navController.navigationBar.titleTextAttributes = [
                .foregroundColor : UIColor.white
            ]
            navController.navigationBar.barTintColor = UIColor(red: 0.0902,
                                                               green: 0.1019,
                                                               blue: 0.1294,
                                                               alpha: 1.0)

            rootVC.present(navController, animated: true)
        }
    }

    func logout(completion: @escaping (Result<SteamID, SteamLogoutError>) -> Void) {
        log.assert(Thread.isMainThread, "steam auth logout worked only from main thread")

        guard let steamId = steamId else {
            completion(.failure(.yourLoggedOut))
            return
        }

        authStorage.steamId = nil
        completion(.success(steamId))
    }
}

// MARK: - Login View
private final class SteamLoginViewController: UIViewController, WKUIDelegate, WKNavigationDelegate
{
    let successNotifier = Notifier<SteamID>()
    let failureNotifier = Notifier<Void>()
    let closeNotifier = Notifier<Void>()

    private static let appRedirectName = "funcorp.steam.app"

    private lazy var webView: WKWebView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())

    private let authNetwork: SteamAuthNetwork

    // Просто лень, в идеале конечно наверх прокидывать события
    init(authNetwork: SteamAuthNetwork) {
        self.authNetwork = authNetwork
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self

        webView.load(URLRequest(url: authNetwork.loginUrl))
        webView.allowsBackForwardNavigationGestures = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closeNotifier.notify(())
        cleanNotifiers()
    }

    @objc
    func clickCloseButton() {
        closeNotifier.notify(())
        cleanNotifiers()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let url = navigationAction.request.url, authNetwork.isRedirect(url: url) {
            decisionHandler(.cancel)

            if let steamId = authNetwork.parseRedirect(url: url) {
                successNotifier.notify(steamId)
            } else {
                // TODO: тут можно еще при желании распарсить причину отказа
                failureNotifier.notify(())
            }
            cleanNotifiers()

            return
        }

        decisionHandler(.allow)
    }

    private func cleanNotifiers() {
        successNotifier.clean()
        failureNotifier.clean()
        closeNotifier.clean()
    }
}
