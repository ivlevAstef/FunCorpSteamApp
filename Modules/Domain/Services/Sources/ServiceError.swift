//
//  ServiceError.swift
//  Services
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public enum ServiceError: Error {
    case notFound
    case notConnection
    case incorrectResponse
    case cancelled
}
