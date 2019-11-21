//
//  ProfileStartPoint.swift
//  Profile
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import DITranquillity
import SwiftLazy

public final class ProfileStartPoint: UIStartPoint
{
    public enum RoutingOptions {
        public static let steamId = "ProfileSteamId"
    }

    public static let name: UIModuleName = .profile

    private var routerProvider = Provider<ProfileRouter>()

    public init() {

    }
    
    public func configure() {

    }

    public func reg(container: DIContainer) {
        container.append(framework: ProfileDependency.self)
        routerProvider = container.resolve()
    }

    public func initialize() {

    }

    public func isSupportOpen(with parameters: RoutingParamaters) -> Bool {
        return parameters.moduleName == Self.name
    }

    public func makeRouter() -> IRouter {
        return routerProvider.value
    }

}
