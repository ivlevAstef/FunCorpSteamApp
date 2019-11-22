//
//  SteamProfileStorage.swift
//  Services
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public protocol SteamProfileStorage: class
{
    func put(_ profile: SteamProfile)

    func fetch(by steamId: SteamID) -> SteamProfile?
}
