//
//  DotaStatisticsScreenPresenter.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 06/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import Services

protocol DotaStatisticsScreenViewContract: class
{
}

final class DotaStatisticsScreenPresenter
{
    private weak var view: DotaStatisticsScreenViewContract?

    init(view: DotaStatisticsScreenViewContract) {
        self.view = view
    }

    func configure(steamId: SteamID) {
        
    }
}

