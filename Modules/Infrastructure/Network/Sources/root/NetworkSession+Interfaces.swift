//
//  NetworkSession+Interfaces.swift
//  Network
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//


extension NetworkSession
{
     func requestOnUser<Success: Decodable>(
           method: String,
           version: String,
           fields: [String: String] = [:],
           completion: @escaping (Result<Success, NetworkError>) -> Void) {
        request(interface: "ISteamUser",
                method: method,
                version: version,
                fields: fields,
                completion: completion)
    }
}
