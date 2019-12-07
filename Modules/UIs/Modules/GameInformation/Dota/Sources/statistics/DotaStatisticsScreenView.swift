//
//  DotaStatisticsScreenView.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 06/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import Design
import UIComponents

final class DotaStatisticsScreenView: ApViewController, DotaStatisticsScreenViewContract
{
    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = loc["Games.Dota2.GameStatistic.title"]
    }
}
