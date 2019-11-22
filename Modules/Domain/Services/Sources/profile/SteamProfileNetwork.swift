//
//  SteamProfileNetwork.swift
//  Services
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public protocol SteamProfileNetwork: class
{
    func request(by steamId: SteamID, completion: @escaping (SteamProfileResult) -> Void)
}
