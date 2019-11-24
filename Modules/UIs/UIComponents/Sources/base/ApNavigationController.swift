//
//  ApNavigationController.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 03/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit

open class ApNavigationController: UINavigationController, UIGestureRecognizerDelegate
{
    open override func viewDidLoad() {
        super.viewDidLoad()

        interactivePopGestureRecognizer?.delegate = self
    }

    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
