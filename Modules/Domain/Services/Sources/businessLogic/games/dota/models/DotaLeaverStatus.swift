//
//  DotaLeaverStatus.swift
//  Services
//
//  Created by Alexander Ivlev on 02/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public enum DotaLeaverStatus
{
    case notLeave
    case disconnected
    case disconnectedTooLong // more 5 minutes
    case abandoned
    case afk
    case neverConnected
    case neverConnectedTooLong
}
