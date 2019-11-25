//
//  FriendsScreenPresenter.swift
//  Friends
//
//  Created by Alexander Ivlev on 26/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

protocol FriendsScreenViewContract
{
}

final class FriendsScreenPresenter
{
    private let view: FriendsScreenViewContract

    init(view: FriendsScreenViewContract) {
        self.view = view
    }
}
