//
//  Response.swift
//  Network
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

struct Response<Type: Decodable>: Decodable {
    let response: Type
}
