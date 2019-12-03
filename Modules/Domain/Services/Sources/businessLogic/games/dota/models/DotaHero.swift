//
//  DotaHero.swift
//  Services
//
//  Created by Alexander Ivlev on 02/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public typealias DotaHeroID = UInt16

public typealias DotaHeroesResult = Result<[DotaHero], ServiceError>

public struct DotaHero
{
    public let id: DotaHeroID
    public let name: String

    /// 205x105
    public let iconURL: URL?
    /// 256x144
    public let iconFullHorizontalURL: URL?
    /// 235x272
    public let iconFullVerticalURL: URL?

    private init() { fatalError("Not support empty initialization") }
}

extension DotaHero
{
    public init(
        id: DotaHeroID,
        name: String,
        iconURL: URL?,
        iconFullHorizontalURL: URL?,
        iconFullVerticalURL: URL?
    ) {
        self.id = id
        self.name = name
        self.iconURL = iconURL
        self.iconFullHorizontalURL = iconFullHorizontalURL
        self.iconFullVerticalURL = iconFullVerticalURL
    }
}
