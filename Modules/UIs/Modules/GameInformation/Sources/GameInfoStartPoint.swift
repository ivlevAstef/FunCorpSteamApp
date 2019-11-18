//
//  GameInfoStartPoint.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Core
import DITranquillity
import SwiftLazy

public final class GameInfoStartPoint: UIStartPoint
{
    public static let name: UIModuleName = .gameInfo

//    private var routerProvider = Provider<NewsRouter>()

    public init() {

    }
    
    public func configure() {

    }

    public func reg(container: DIContainer) {
//        container.append(framework: NewsDependency.self)
//        routerProvider = container.resolve()
    }

    public func initialize() {

    }

    public func isSupportOpen(with parameters: RoutingParamaters) -> Bool {
        return parameters.moduleName == Self.name
    }

    public func makeRouter() -> IRouter {
        fatalError("")
//        return routerProvider.value
    }

}
