//
//  ProfileScreenPresenter.swift
//  Profile
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Core
import Services

protocol ProfileScreenViewContract: class
{

}

final class ProfileScreenPresenter
{
    private let view: ProfileScreenViewContract
    private let authService: SteamAuthService

    init(view: ProfileScreenViewContract, authService: SteamAuthService) {
        self.view = view
        self.authService = authService
    }

    func configure(steamId: SteamID) {
        print("STEAMID \(steamId)")
    }
}
