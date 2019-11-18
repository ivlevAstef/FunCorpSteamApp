//
//  SettingsScreenPresenter.swift
//  Settings
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//


import Common

protocol SettingsScreenViewContract
{
}

final class SettingsScreenPresenter
{
    private let view: SettingsScreenViewContract

    init(view: SettingsScreenViewContract) {
        self.view = view
    }
}

