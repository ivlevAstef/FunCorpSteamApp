//
//  SteamDotaHeroData.swift
//  Storage
//
//  Created by Alexander Ivlev on 03/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import RealmSwift
import Services

final class SteamDotaHeroData: Object, LimitedUpdated {
    static func generatePrimaryKey(heroId: DotaHeroID, loc: SteamLocalization) -> String {
        return "\(heroId)_\(loc)"
    }

    @objc dynamic var _primaryKey: String = ""
    @objc dynamic var _heroId: Int = 0
    @objc dynamic var _loc: String = ""
    @objc dynamic var _name: String = ""

    @objc dynamic var _iconURL: String? = nil
    @objc dynamic var _iconFullHorizontalURL: String? = nil
    @objc dynamic var _iconFullVerticalURL: String? = nil

    @objc dynamic var lastUpdateTime: Date = Date()

    override static func primaryKey() -> String? {
        return "_primaryKey"
    }
}


extension SteamDotaHeroData
{
    convenience init(hero: DotaHero, loc: SteamLocalization) {
        self.init()

        _primaryKey = Self.generatePrimaryKey(heroId: hero.id, loc: loc)
        _heroId = Int(hero.id)
        _loc = "\(loc)"
        _name = hero.name

        _iconURL = hero.iconURL?.absoluteString
        _iconFullHorizontalURL = hero.iconFullHorizontalURL?.absoluteString
        _iconFullVerticalURL = hero.iconFullVerticalURL?.absoluteString
    }

    var hero: DotaHero? {
        return DotaHero(id: DotaHeroID(_heroId),
                        name: _name,
                        iconURL: _iconURL.flatMap { URL(string: $0) },
                        iconFullHorizontalURL: _iconFullHorizontalURL.flatMap { URL(string: $0) },
                        iconFullVerticalURL: _iconFullVerticalURL.flatMap { URL(string: $0) })
    }
}
