//
//  UIComponentsStartPoint.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 04/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import DITranquillity
import Core

public final class UIComponentsStartPoint: CommonStartPoint
{
    public init() {

    }

    public func configure() {

    }

    public func reg(container: DIContainer) {
        container.register {
            NavigationController(controller: ApNavigationController(nibName: nil, bundle: nil))
        }.lifetime(.perContainer(.weak))
    }

    public func initialize() {
    }
}
