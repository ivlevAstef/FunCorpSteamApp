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

final class SteamAuthServiceImpl: SteamAuthService {
    var isLogined: Bool {
        return false
    }

    var steamId: SteamID? {
        return nil
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

        let steamLoginVC = SteamLoginViewController(nibName: nil, bundle: nil)
        steamLoginVC.successNotifier.join(listener: {  [weak steamLoginVC] steamId in
            // TODO: save
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

        rootVC.present(steamLoginVC, animated: true)
    }

    func logout(completion: @escaping (Result<SteamID, SteamLogoutError>) -> Void) {
        log.assert(Thread.isMainThread, "steam auth logout worked only from main thread")

        if !isLogined {
            completion(.failure(.yourLoggedOut))
            return
        }

        completion(.success(0))
    }
}

private final class SteamLoginViewController: UIViewController, WKNavigationDelegate {
    let successNotifier = Notifier<SteamID>()
    let failureNotifier = Notifier<Void>()
    let closeNotifier = Notifier<Void>()

    private static let appRedirectName = "funcorp.steam.app"

    private lazy var webView: WKWebView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        // дурацкий webview с кучей ошибок про констрейны... и главное как чинить не понятно
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: webView.leftAnchor),
            view.rightAnchor.constraint(equalTo: webView.rightAnchor),

            view.topAnchor.constraint(lessThanOrEqualTo: webView.topAnchor),
            view.bottomAnchor.constraint(equalTo: webView.bottomAnchor)
        ])

        webView.navigationDelegate = self

        let url = steamopenIdUrl()
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        closeNotifier.notify(())
        cleanNotifiers()
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if let url = navigationAction.request.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            if components.host == Self.appRedirectName {
                decisionHandler(.cancel)

                if let steamId = parseRedirectResult(components) {
                    successNotifier.notify(steamId)
                } else {
                    // TODO: тут можно еще при желании распарсить причину отказа
                    failureNotifier.notify(())
                }
                cleanNotifiers()

                return
            }
        }

        decisionHandler(.allow)
    }

    private func parseRedirectResult(_ components: URLComponents) -> SteamID? {
        // also maybe need openid.sig=WDPVq743zqTGeLXqn/RZ/SYfyBM=
        for queryItem in components.queryItems ?? [] {
            guard let value = queryItem.value else {
                continue
            }
            if queryItem.name != "openid.claimed_id" && queryItem.name != "openid.identity" {
                continue
            }
            guard let paramComponents = URLComponents(string: value) else {
                continue
            }
            if !paramComponents.path.hasPrefix("/openid/id/") {
                continue
            }

            let lastComponent = (paramComponents.path as NSString).lastPathComponent
            if let steamId = SteamID(lastComponent) {
                return steamId
            }
        }

        return nil
    }

    private func steamopenIdUrl() -> URL {
        // TODO: hardcode - fix
        var components = URLComponents(string: "https://steamcommunity.com/openid/login")!
        let items = [
            URLQueryItem(name: "openid.ns", value: "http://specs.openid.net/auth/2.0"),
            URLQueryItem(name: "openid.claimed_id", value: "http://specs.openid.net/auth/2.0/identifier_select"),
            URLQueryItem(name: "openid.identity", value: "http://specs.openid.net/auth/2.0/identifier_select"),
            URLQueryItem(name: "openid.return_to", value: "https://\(Self.appRedirectName)"),
            URLQueryItem(name: "openid.mode", value: "checkid_setup")
        ]

        let allowedChars = CharacterSet(charactersIn: ":/").inverted
        components.percentEncodedQuery = items.map { item in
            item.name + "=" + (item.value?.addingPercentEncoding(withAllowedCharacters: allowedChars) ?? "")
        }.joined(separator: "&")

        guard let url = components.url else {
            log.fatal("Can't make steam open id url")
        }

        return url
    }

    private func cleanNotifiers() {
        successNotifier.clean()
        failureNotifier.clean()
        closeNotifier.clean()
    }
}
