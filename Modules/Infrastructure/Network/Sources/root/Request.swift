//
//  Request.swift
//  Network
//
//  Created by Alexander Ivlev on 27/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

protocol RequestInfo {
    var interface: String { get }
    var method: String { get }
    var version: Int { get }

    var fields: [String: Any] { get }
}

class Request<Success: Decodable>: RequestInfo {
    let interface: String
    let method: String
    let version: Int

    let fields: [String: Any]
    let completion: (Result<Success, NetworkError>) -> Void

    init(interface: String,
         method: String,
         version: Int,
         fields: [String: Any] = [:],
         completion: @escaping (Result<Success, NetworkError>) -> Void) {
        self.interface = interface
        self.method = method
        self.version = version
        self.fields = fields
        self.completion = completion
    }
}
