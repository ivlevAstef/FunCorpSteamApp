//
//  SteamProfileService.swift
//  Services
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

public protocol SteamProfileServiceSubscriber: class {}

public protocol SteamProfileService: class
{
    /// return data from storage
    func fetch(by steamId: SteamID, completion: @escaping (SteamProfileResult) -> Void)
    /// return data from network and save to storage
    func update(by steamId: SteamID, completion: @escaping (SteamProfileResult) -> Void)

    /// join to profile. first if can return data from storage, next return data from network. After notify about profile changed
    func join(to steamId: SteamID, callback: @escaping (SteamProfileResult) -> Void) -> SteamProfileServiceSubscriber
}

extension SteamProfileService {
    public func update(by steamId: SteamID) {
        update(by: steamId, completion: { _ in })
    }
}
