//
//  AppUIComponentsStartPoint.swift
//  AppUIComponents
//
//  Created by Alexander Ivlev on 25/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import DITranquillity
import Core
import UIComponents

public final class AppUIComponentsStartPoint: CommonStartPoint
{
    public init() {

    }

    public func configure() {

    }

    public func reg(container: DIContainer) {
        container.register(SteamNavBar.init)
            .lifetime(.prototype)

        container.register {
            NavigationController(controller: SteamNavigationViewController(nibName: nil, bundle: nil))
            as (NavigationController & SteamNavigationController)
        }.lifetime(.prototype)
    }

    public func initialize() {
    }
}
