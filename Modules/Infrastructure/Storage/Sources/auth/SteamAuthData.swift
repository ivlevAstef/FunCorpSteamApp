//
//  SteamAuthData.swift
//  Storage
//
//  Created by Alexander Ivlev on 28/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import RealmSwift
import Services

final class SteamAuthData: Object {
    static let singlePrimaryKey = 1
    // sessionId нужен просто, чтобы сохранять один объект. Ну или в будущем возможно сделать мульти вход...
    @objc dynamic var _sessionId: Int = singlePrimaryKey

    @objc dynamic var _steamId: String = ""

    override static func primaryKey() -> String? {
        return "_sessionId"
    }
}

extension SteamAuthData {
    convenience init(steamId: SteamID) {
        self.init()
        _steamId = "\(steamId)"
    }

    var steamId: SteamID? {
        return SteamID(_steamId)
    }
}
