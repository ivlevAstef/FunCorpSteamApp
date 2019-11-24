//
//  SteamAuthStorage.swift
//  Services
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public protocol SteamAuthStorage: class
{
    var steamId: SteamID? { set get }
}
