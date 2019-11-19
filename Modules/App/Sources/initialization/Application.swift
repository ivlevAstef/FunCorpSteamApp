//
//  Application.swift
//  ApLife
//
//  Created by Alexander Ivlev on 22/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Core
import Services
import SwiftLazy

// Start point
final class Application
{
    private let router: AppRouter

    init(router: AppRouter) {
        self.router = router
    }

    func start(_ window: UIWindow) {
        window.rootViewController = router.rootViewController
        router.start()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let parent = (window.rootViewController as! UINavigationController).topViewController!

            let steamVC = SteamLoginViewController(nibName: nil, bundle: nil)
            parent.present(steamVC, animated: true, completion: nil)

            steamVC.completionNotifier.join(listener: { steamId in
                print("received steam id: \(steamId)")
                steamVC.dismiss(animated: true, completion: nil)
            })
        }
    }

    func configureAndInitialization(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // TODO: support parse launch options
        router.configure(parameters: RoutingParamaters())
    }

    func openUrl(_ url: URL) -> Bool {
        return false
    }
}
