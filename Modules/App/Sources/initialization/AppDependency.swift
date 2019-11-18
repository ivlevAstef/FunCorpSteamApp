//
//  AppDependency.swift
//  ApLife
//
//  Created by Alexander Ivlev on 22/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import DITranquillity
import Core
import Common

final class AppDependency
{
    static func configure() {
        DISetting.Defaults.injectToSubviews = false
        DISetting.Defaults.lifeTime = .prototype
        DISetting.Log.level = .verbose
        DISetting.Log.tab = "   "
        DISetting.Log.fun = Self.logMethod
    }

    static func reg(container: DIContainer) {
        container.append(framework: AppFramework.self)
    }

    static func validate(container: DIContainer) {
        #if DEBUG
        if !container.validate(checkGraphCycles: false) {
            fatalError("DI graph validation failed")
        }
        #endif
    }

    private static func logMethod(level: DILogLevel, msg: String) {
        switch level {
        case .error:
            log.error(msg)
        case .warning:
            log.warning(msg)
        case .info:
            log.debug(msg)
        case .verbose:
            log.trace(msg)
        case .none:
            break
        }

    }
}

private class AppFramework: DIFramework
{
    static func load(container: DIContainer) {
        container.register(Application.init)
            .lifetime(.perRun(.strong))

        container.register(AppRouter.init)
            .as(IRouter.self)
            .lifetime(.objectGraph)
    }
}
