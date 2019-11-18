//
//  IRouter.swift
//  Services
//
//  Created by Alexander Ivlev on 22/09/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit

public protocol IRouter
{
    var rootViewController: UIViewController { get }

    @discardableResult
    func configure(parameters: RoutingParamaters) -> IRouter

    func start()
    func stop()
}

public extension IRouter
{
    @discardableResult
    func configure() -> IRouter {
        return configure(parameters: RoutingParamaters())
    }

    func start() {
    }
    func stop() {
    }
}
