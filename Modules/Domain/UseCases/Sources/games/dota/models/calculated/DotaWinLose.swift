//
//  DotaWinLose.swift
//  UseCases
//
//  Created by Alexander Ivlev on 05/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public struct DotaWinLose
{
    public let win: Int
    public let lose: Int
    public let unknown: Int

    private init() { fatalError("Not support empty initialization") }
}

extension DotaWinLose
{
    public init(
        win: Int,
        lose: Int,
        unknown: Int
    ) {
        self.win = win
        self.lose = lose
        self.unknown = unknown
    }
}
