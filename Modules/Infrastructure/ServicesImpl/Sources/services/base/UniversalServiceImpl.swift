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

final class UniversalServiceImpl<Content, Params: Hashable>
{
    typealias CompletionResult = ServiceCompletion<Content>
    typealias UniversalResult = Result<Content, ServiceError>
    typealias UpdateResult = Result<Content, ServiceError>
    typealias FetchResult = StorageResult<Content>

    private class SubscribeInfo {
        let notifier = Notifier<UniversalResult>()

        var contentCompletions: [(CompletionResult) -> Void] = []
        var completions: [(Bool) -> Void] = []

        private(set) var isWorked: Bool = false

        func start() {
            isWorked = true
        }

        func notify(result: UniversalResult) {
           log.assert(Thread.isMainThread, "Thread.isMainThread")

           notifier.notify(result)
        }

        func contentCompletion(result: CompletionResult) {
            log.assert(Thread.isMainThread, "Thread.isMainThread")
            contentCompletions.forEach { $0(result) }
        }

        func end(result: UniversalResult) {
            log.assert(Thread.isMainThread, "Thread.isMainThread")

            contentCompletions.removeAll()

            if case .success = result {
                completions.forEach { $0(true) }
            } else {
                completions.forEach { $0(false) }
            }
            completions.removeAll()

            isWorked = false
        }
    }

    private let fetcher: (Params) -> FetchResult
    private let updater: (Params, @escaping (UpdateResult) -> Void) -> Void
    private let saver: (Params, Content) -> Void

    private var subscribers: [Params: SubscribeInfo] = [:]

    /// - Parameter fetcher: Функция получения данных из хранилища
    /// - Parameter updater: Функция для запроса данных по сети
    /// - Parameter saver: Функция записи данных в хранилище
    init(fetcher: @escaping (Params) -> FetchResult,
         updater: @escaping (Params, @escaping (UpdateResult) -> Void) -> Void,
         saver: @escaping (Params, Content) -> Void) {
        self.fetcher = fetcher
        self.updater = updater
        self.saver = saver
    }

    func refresh(for params: Params,
                 contentCompletion: ((CompletionResult) -> Void)? = nil,
                 completion: ((Bool) -> Void)? = nil) {
        log.assert(Thread.isMainThread, "Thread.isMainThread")

        let subscribeInfo = getOrMakeSubscriber(for: params)

        if let contentCompletion = contentCompletion {
            subscribeInfo.contentCompletions.append(contentCompletion)
        }

        if let completion = completion {
            subscribeInfo.completions.append(completion)
        }

        if subscribeInfo.isWorked {
            return
        }

        subscribeInfo.start()
        fetch(by: params) { [weak self] fetchResult in
            switch fetchResult {
            case .none: // Если в хранище пусто, то пытаемся получить по сети
                break
            case .noRelevant(let content): // Если данные не актуальны, то оповещаем, и запускаем закачку
                subscribeInfo.notify(result: .success(content))
                subscribeInfo.contentCompletion(result: .notRelevant(content))
                break
            case .done(let content): // Если данные актуальные, то оповещаем, и завершаем
                subscribeInfo.notify(result: .success(content))
                subscribeInfo.contentCompletion(result: .db(content))
                subscribeInfo.end(result: .success(content))
                return
            }

            self?.update(by: params) { result in
                if case .success(let content) = result {
                    self?.saver(params, content)
                    subscribeInfo.notify(result: result)
                    subscribeInfo.contentCompletion(result: .network(content))
                    subscribeInfo.end(result: result)
                } else if case .noRelevant(let content) = fetchResult {
                    // Уже оповещали о этих результатах
                    subscribeInfo.end(result: .success(content))
                } else { // все данные не удачные
                    subscribeInfo.notify(result: result)
                    if case .failure(let error) = result {
                        subscribeInfo.contentCompletion(result: .failure(error))
                    }
                    subscribeInfo.end(result: result)
                }
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

    private func fetch(by params: Params, completion: @escaping (FetchResult) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [fetcher] in
            let result = fetcher(params)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    private func update(by params: Params, completion: @escaping (UpdateResult) -> Void) {
        updater(params) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
