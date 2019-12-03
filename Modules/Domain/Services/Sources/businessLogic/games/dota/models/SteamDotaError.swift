//
//  SteamDotaError.swift
//  Services
//
//  Created by Alexander Ivlev on 03/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public enum SteamDotaError: Error
{
    /// Пользователь не разрешил просматривать данные по игре.
    case notAllowed
}
