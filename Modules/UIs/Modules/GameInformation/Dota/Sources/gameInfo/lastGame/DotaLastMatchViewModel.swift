//
//  DotaLastMatchViewModel.swift
//  Dota
//
//  Created by Alexander Ivlev on 05/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common

struct DotaLastMatchViewModel
{
    let heroImage: ChangeableImage
    let heroName: String

    /// kills, deaths, assists
    let kdaText: String
    let kills: Int
    let deaths: Int
    let assists: Int

    let startTime: Date
    let durationText: String
    let duration: TimeInterval

    let resultText: String
    let isWin: Bool
    let winText: String
    let loseText: String
}
