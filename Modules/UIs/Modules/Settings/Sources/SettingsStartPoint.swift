//
//  SettingsStartPoint.swift
//  Settings
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import DITranquillity
import Design
import SwiftLazy

public final class SettingsStartPoint: UIStartPoint
{
    public static let name: UIModuleName = .settings

    private var routerProvider = Provider<SettingsRouter>()

    public init() {

    }

    public func configure() {
    }

    public func reg(container: DIContainer) {
        container.append(framework: SettingsDependency.self)
        routerProvider = container.resolve()
    }

    public func initialize() {
        // TODO: setup style
    }

    public func isSupportOpen(with parameters: RoutingParamaters) -> Bool {
       return parameters.moduleName == Self.name
   }

   public func makeRouter() -> IRouter {
       return routerProvider.value
   }

}
