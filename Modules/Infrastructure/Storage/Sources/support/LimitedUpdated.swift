//
//  TimeInterval+minutes.swift
//  Storage
//
//  Created by Alexander Ivlev on 28/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services
import RealmSwift

protocol LimitedUpdated {
    var lastUpdateTime: Date { get }
}

func dataToResult<D: Object & LimitedUpdated, T>(_ data: D?,
                                                 updateInterval: TimeInterval,
                                                 map: (D) -> T?) -> StorageResult<T> {
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

func dataArrayToResult<D: Object & LimitedUpdated, T>(_ dataArray: Results<D>?,
                                                      updateInterval: TimeInterval,
                                                      map: (D) -> T?) -> StorageResult<[T]> {
    guard let dataArray = dataArray else {
        return .none
    }

    if dataArray.isEmpty {
        return .none
    }

    // Принцип устаревания - если хотябы один устарел, значит все нужно обновить
    var isDone: Bool = true
    var objectArray: [T] = []

    for data in dataArray {
        let localResult = dataToResult(data, updateInterval: updateInterval, map: map)
        switch localResult {
        case .none:
            break
        case .noRelevant(let object):
            objectArray.append(object)
            isDone = false
        case .done(let object):
            objectArray.append(object)
        }
    }

    if objectArray.isEmpty {
        return .none
    }

    log.assert(objectArray.count == dataArray.count, "While convert data to object in array, miss objects")

    if isDone {
        return .done(objectArray)
    }
    return .noRelevant(objectArray)
}
