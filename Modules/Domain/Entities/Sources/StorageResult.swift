//
//  StorageResult.swift
//  UseCases
//
//  Created by Alexander Ivlev on 28/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

public enum StorageResult<Content>: ExpressibleByNilLiteral
{
    case none
    case noRelevant(Content)
    case done(Content)

    public init(nilLiteral: ()) {
        self = .none
    }
}
