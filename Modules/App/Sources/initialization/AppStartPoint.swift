//
//  AppStartPoint.swift
//  ApLife
//
//  Created by Alexander Ivlev on 23/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import DITranquillity

final class AppStartPoint
{
    static var app: Application {
        return container.resolve()
    }

    private static let container = DIContainer()

    static func configure() {
        LogInitialization.configure()
        AppDependency.configure()

        for startPoint in StartPoints.common + StartPoints.ui.values.map({ $0 as CommonStartPoint }) {
            startPoint.configure()
        }
    }

    static func reg() {
        AppDependency.reg(container: container)

        for startPoint in StartPoints.common + StartPoints.ui.values.map({ $0 as CommonStartPoint }) {
            startPoint.reg(container: container)
        }

        AppDependency.validate(container: container)
    }

    static func initialize() {
        for startPoint in StartPoints.common + StartPoints.ui.values.map({ $0 as CommonStartPoint }) {
            startPoint.initialize()
        }
    }
}
