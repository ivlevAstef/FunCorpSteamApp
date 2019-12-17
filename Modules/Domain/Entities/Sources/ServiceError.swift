//
//  ServiceError.swift
//  UseCases
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public enum ServiceError: Error {
    case notConnection
    case incorrectResponse
    case customError(Error)
    case cancelled
}
