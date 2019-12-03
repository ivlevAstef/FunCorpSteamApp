//
//  ServiceCompletion.swift
//  Services
//
//  Created by Alexander Ivlev on 03/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//


public enum ServiceCompletion<T>
{
    // Данные взяты из базы данных

    case notRelevant(T)
    case db(T)

    // Данные взяты по сети

    case network(T)
    case failure(ServiceError)

    public var content: T? {
        switch self {
        case .notRelevant(let content):
            return content
        case .db(let content):
            return content
        case .network(let content):
            return content
        case .failure:
            return nil
        }
    }
}
