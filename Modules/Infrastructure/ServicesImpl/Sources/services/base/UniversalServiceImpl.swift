//
//  UniversalServiceImpl.swift
//  ServicesImpl
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

final class UniversalServiceImpl<ResultType, Params: Hashable>
{
    typealias UniversalResult = Result<ResultType, ServiceError>

    private class SubscribeInfo {
        let notifier = Notifier<UniversalResult>()
        var isWorked: Bool = false
        var completions: [(Bool) -> Void] = []

        func notify(result: UniversalResult) {
            log.assert(Thread.isMainThread, "Thread.isMainThread")

            /// игнорируем ошибки что в БД нет данных - всеравно будет сетевой запрос
            if case .failure(.notFound) = result {
                return
            }

            notifier.notify(result)
        }
    }

    private let fetcher: (Params) -> UniversalResult
    private let updater: (Params, @escaping (UniversalResult) -> Void) -> Void

    private var subscribers: [Params: SubscribeInfo] = [:]

    init(fetcher: @escaping (Params) -> UniversalResult,
         updater: @escaping (Params, @escaping (UniversalResult) -> Void) -> Void) {
        self.fetcher = fetcher
        self.updater = updater
    }

    func refresh(for params: Params, completion: ((Bool) -> Void)?) {
        log.assert(Thread.isMainThread, "Thread.isMainThread")

        let subscribeInfo = getOrMakeSubscriber(for: params)

        if let completion = completion {
            subscribeInfo.completions.append(completion)
        }

        if subscribeInfo.isWorked {
            return
        }

        subscribeInfo.isWorked = true
        fetch(by: params) { [weak self] cacheResult in
            subscribeInfo.notify(result: cacheResult)
            self?.update(by: params) { result in
                subscribeInfo.notify(result: result)

                var success: Bool = false
                if case .success = cacheResult {
                    success = true
                } else if case .success = result {
                    success = true
                }

                subscribeInfo.completions.forEach { $0(success) }
                subscribeInfo.completions.removeAll()

                subscribeInfo.isWorked = false
            }
        }
    }

    func getNotifier(for params: Params) -> Notifier<UniversalResult> {
        log.assert(Thread.isMainThread, "Thread.isMainThread")

        return getOrMakeSubscriber(for: params).notifier
    }

    private func getOrMakeSubscriber(for params: Params) -> SubscribeInfo {
        let subscribeInfo = subscribers[params] ?? SubscribeInfo()
        subscribers[params] = subscribeInfo

        return subscribeInfo
    }

    private func fetch(by params: Params, completion: @escaping (UniversalResult) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [fetcher] in
            let result = fetcher(params)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    private func update(by params: Params, completion: @escaping (UniversalResult) -> Void) {
        updater(params) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
