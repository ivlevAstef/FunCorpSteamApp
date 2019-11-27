//
//  SteamRequest.swift
//  Network
//
//  Created by Alexander Ivlev on 27/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Services

class SteamRequest<Content: Decodable, APIContent>: Request<Content> {
    init(interface: String,
         method: String,
         version: Int,
         fields: [String: Any] = [:],
         parse: @escaping (Content) -> Result<APIContent, ServiceError>,
         completion: @escaping (Result<APIContent, ServiceError>) -> Void) {
        super.init(interface: interface, method: method, version: version, fields: fields, completion: { result in
            switch result {
            case .success(let content):
                completion(parse(content))
            case .failure(.cancelled):
                completion(.failure(.cancelled))
            case .failure(.notConnection), .failure(.timeout):
                completion(.failure(.notConnection))
            case .failure:
                completion(.failure(.incorrectResponse))
            }
        })
    }
}
