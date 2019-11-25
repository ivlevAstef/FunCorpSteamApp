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
    func start(parameters: RoutingParamaters)
}

public extension IRouter
{
    func start() {
        start(parameters: RoutingParamaters())
    }
}
