//
//  RibbonScreenPresenter.swift
//  News
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

protocol RibbonScreenViewContract: class
{
}

final class RibbonScreenPresenter
{
    private weak var view: RibbonScreenViewContract?

    init(view: RibbonScreenViewContract) {
        self.view = view
    }
}
