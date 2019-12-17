//
//  SteamDotaCompletion.swift
//  UseCases
//
//  Created by Alexander Ivlev on 03/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Entities

public enum SteamDotaCompletion<T>
{
    case notActual(T)
    case actual(T)
    case failure(ServiceError)
}
