//
//  TimeInterval+minutes.swift
//  Storage
//
//  Created by Alexander Ivlev on 28/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Services

protocol LimitedUpdated {
    var lastUpdateTime: Date { get }
}

func dataToResult<D: LimitedUpdated, T>(_ data: D?, updateInterval: TimeInterval, map: (D) -> T?) -> StorageResult<T> {
    guard let data = data else {
        return .none
    }
    guard let object = map(data) else {
        return .none
    }

    // Если с момента последнего обновления, прошло мало времени, то говорим что объект актуален
    if data.lastUpdateTime.addingTimeInterval(updateInterval) > Date() {
        return .done(object)
    }
    return .noRelevant(object)
}
