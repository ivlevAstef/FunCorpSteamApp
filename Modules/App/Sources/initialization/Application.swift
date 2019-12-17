//
//  Application.swift
//  ApLife
//
//  Created by Alexander Ivlev on 22/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Core
import UseCases
import SwiftLazy

// Start point
final class Application
{
    private let router: AppRouter

    init(router: AppRouter) {
        self.router = router
    }

    func configureWindow(_ window: UIWindow) {
        window.rootViewController = router.rootViewController
    }

    func start(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // TODO: support parse launch options
        router.start(parameters: RoutingParamaters())
    }

    func openUrl(_ url: URL) -> Bool {
        // TODO: support parse url
        return false
    }
}
