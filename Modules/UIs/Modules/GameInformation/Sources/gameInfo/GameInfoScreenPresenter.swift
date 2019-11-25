//
//  GameInfoScreenPresenter.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 26/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

protocol GameInfoScreenViewContract
{
}

final class GameInfoScreenPresenter
{
    private let view: GameInfoScreenViewContract

    init(view: GameInfoScreenViewContract) {
        self.view = view
    }
}
