//
//  ErrorAlert.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 21/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common

public final class ErrorAlert
{
    private static var isShown: Bool = false

    public static func show(_ text: String, on viewController: UIViewController) {
        log.assert(Thread.isMainThread, "Thread.isMainThread")

        if isShown {
            return
        }

        // Да не модно и не молодежно, но зато писать или подключать ничего не надо
        let alertController = UIAlertController(title: loc["Alert.Error"],
                                                message: text,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(
            title: loc["Alert.Ok"],
            style: .default,
            handler: { _ in
                isShown = false
            }
        ))
        
        isShown = true
        (viewController.navigationController ?? viewController).present(alertController, animated: true)
    }
}
