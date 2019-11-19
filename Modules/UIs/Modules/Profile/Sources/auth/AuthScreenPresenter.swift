//
//  AuthScreenPresenter.swift
//  Profile
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

protocol AuthScreenViewContract
{
}

final class AuthScreenPresenter
{
    private let view: AuthScreenViewContract

    init(view: AuthScreenViewContract) {
        self.view = view
    }

    private func subscribeOn(_ view: AuthScreenViewContract) {

    }
}
