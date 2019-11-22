//
//  SteamAuthNetwork.swift
//  Services
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public protocol SteamAuthNetwork: class
{
    var loginUrl: URL { get }

    func isRedirect(url: URL) -> Bool
    func parseRedirect(url: URL) -> SteamID?
}
