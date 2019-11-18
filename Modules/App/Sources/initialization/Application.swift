//
//  Application.swift
//  ApLife
//
//  Created by Alexander Ivlev on 22/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Core

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
    }

    func configureAndInitialization(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // TODO: support parse launch options
        router.configure(parameters: RoutingParamaters())
    }
}
