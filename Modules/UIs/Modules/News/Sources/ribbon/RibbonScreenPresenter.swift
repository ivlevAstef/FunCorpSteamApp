//
//  RibbonScreenPresenter.swift
//  Blog
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

protocol RibbonScreenViewContract
{
    var needFullRefreshNotifier: Notifier<Void> { get }
    var needNextPageNotifier: Notifier<Void> { get }

    /// Fully update ribbon.
    /// - Parameter viewModels: new models
    func update(_ viewModels: [RibbonElementViewModel], animated: Bool)
    /// Add next elements to ribbon.
    /// - Parameter viewModels: new models
    func add(_ viewModels: [RibbonElementViewModel], animated: Bool)

    func showFullActivity()
    func showNextPageActivity()
}

final class RibbonScreenPresenter
{
    private let view: RibbonScreenViewContract

    init(view: RibbonScreenViewContract) {
        self.view = view
    }

    private func subscribeOn(_ view: RibbonScreenViewContract) {

    }
}
