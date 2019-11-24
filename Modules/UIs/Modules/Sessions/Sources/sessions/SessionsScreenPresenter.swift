//
//  SessionsScreenPresenter.swift
//  Sessions
//
//  Created by Alexander Ivlev on 24/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//


import Common

protocol SessionsScreenViewContract
{
}

final class SessionsScreenPresenter
{
    private let view: SessionsScreenViewContract

    init(view: SessionsScreenViewContract) {
        self.view = view
    }
}

