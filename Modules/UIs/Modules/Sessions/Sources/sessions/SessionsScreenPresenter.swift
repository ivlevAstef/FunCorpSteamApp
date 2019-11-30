//
//  SessionsScreenPresenter.swift
//  Sessions
//
//  Created by Alexander Ivlev on 24/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//


import Common

protocol SessionsScreenViewContract: class
{
}

final class SessionsScreenPresenter
{
    private weak var view: SessionsScreenViewContract?

    init(view: SessionsScreenViewContract) {
        self.view = view
    }
}

