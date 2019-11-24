//
//  SteamAuthModels.swift
//  Services
//
//  Created by Alexander Ivlev on 20/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//


public typealias SteamID = UInt64
public typealias AccountID = UInt32

public enum SteamLoginError: Error
{
    case yourLoggedIn
    case userCancel
    case applicationIncorrectConfigured
    case incorrectResponse
}

public enum SteamLogoutError: Error
{
    case yourLoggedOut
}
