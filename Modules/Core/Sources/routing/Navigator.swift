//
//  Navigator.swift
//  Core
//
//  Created by Alexander Ivlev on 26/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import SwiftLazy

public final class Navigator
{
    public var controller: UINavigationController {
        if let controller = _controller {
            return controller
        }

        let newController = controllerProvider.value
        _controller = newController
        return newController
    }

    private weak var _controller: UINavigationController?

    public var showNavigationBar: Bool = true {
        didSet {
            controller.setNavigationBarHidden(!showNavigationBar, animated: true)
        }
    }

    private var needReset: Bool = true
    private let controllerProvider: Provider<UINavigationController>

    public init(controllerProvider: Provider<UINavigationController>) {
        self.controllerProvider = controllerProvider
    }

    public func copy() -> Navigator {
        let navigator = Navigator(controllerProvider: controllerProvider)
        navigator.showNavigationBar = showNavigationBar

        return navigator
    }

    // MARK: - View Controllers

    public func push(_ vc: UIViewController, animated: Bool = true) {
        if controller.viewControllers.isEmpty {
            controller.setViewControllers([vc], animated: false)
        } else {
            if needReset {
                controller.setViewControllers([vc], animated: animated)
            } else {
                controller.pushViewController(vc, animated: animated)
            }
        }
        needReset = false

        log.info("push view controller: \(type(of: vc))")
    }

    public func pop(animated: Bool = true) {
        controller.popViewController(animated: animated)

        log.info("pop view controller")
    }

    public func popTo(_ vc: UIViewController, animated: Bool = true) {
        var found: Bool = false
        for iterVC in controller.viewControllers {
            if iterVC === vc {
                found = true
                break
            }
        }

        log.assert(found, "Call pop to vc, but view controller not found.")
        if found {
            controller.popToViewController(vc, animated: animated)

            log.info("pop to view controller: \(type(of: vc))")
        }
    }

    public func popToRoot(animated: Bool = true) {
        controller.popToRootViewController(animated: animated)

        log.info("pop to root")
    }

    public func reset() {
        needReset = true

        log.info("reset")
    }

    public func present(_ vc: UIViewController, animated: Bool = true) {
        controller.present(vc, animated: animated, completion: nil)

        log.info("present view controller: \(type(of: vc))")
    }

    public func dismiss(_ vc: UIViewController, animated: Bool = true) {
        vc.dismiss(animated: animated)

        log.info("dismiss view controller: \(type(of: vc))")
    }
}
