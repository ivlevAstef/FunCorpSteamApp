//
//  SteamProfileServiceImpl.swift
//  ServicesImpl
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

final class SteamProfileServiceImpl: SteamProfileService
{
    private class ProfileSubscribeInfo {
        let notifier = Notifier<SteamProfileResult>()
        var profile: SteamProfile?
        var notifyAboutError: Bool = true
        var isWorked: Bool = false

        func notify(result: SteamProfileResult) {
           log.assert(Thread.isMainThread, "Thread.isMainThread")

           /// игнорируем ошибки что в БД нет данных - всеравно будет сетевой запрос
           if case .failure(.notFound) = result {
               return
           }

           var newProfile: SteamProfile?
           if case let .success(profile) = result {
               newProfile = profile
           }

           /// Если надо сообщить об ошибке, и это ошибка, то сообщаем
           if notifyAboutError && nil == newProfile {
               notifier.notify(result)
           /// Если прошло состояние не равно новому, и новое при этом не ошибка, то сохраняем и оповещаем
           } else if profile != newProfile && newProfile != nil {
               profile = newProfile
               notifier.notify(result)
           }

           notifyAboutError = false
        }
    }

    private let network: SteamProfileNetwork
    private let storage: SteamProfileStorage

    private var subscribers: [SteamID: ProfileSubscribeInfo] = [:]

    init(network: SteamProfileNetwork, storage: SteamProfileStorage) {
        self.network = network
        self.storage = storage
    }

    func refresh(for steamId: SteamID) {
        log.assert(Thread.isMainThread, "Thread.isMainThread")

        guard let subscribeInfo = subscribers[steamId] else {
            return
        }

        if subscribeInfo.isWorked {
            return
        }

        subscribeInfo.isWorked = true
        fetch(by: steamId) { [weak self] result in
            subscribeInfo.notify(result: result)
            self?.update(by: steamId) { result in
                subscribeInfo.notify(result: result)
                subscribeInfo.isWorked = false
            }
        }
    }

    func getNotifier(for steamId: SteamID) -> Notifier<SteamProfileResult> {
        log.assert(Thread.isMainThread, "Thread.isMainThread")
        let subscribeInfo = subscribers[steamId] ?? ProfileSubscribeInfo()
        subscribers[steamId] = subscribeInfo

        return subscribeInfo.notifier
    }

    private func fetch(by steamId: SteamID, completion: @escaping (SteamProfileResult) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak storage] in
            guard let profile = storage?.fetch(by: steamId) else {
                DispatchQueue.main.async {
                    completion(.failure(.notFound))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(profile))
            }
        }
    }

    private func update(by steamId: SteamID, completion: @escaping (SteamProfileResult) -> Void) {
        network.request(by: steamId, completion: { [weak storage] result in
            if case let .success(profile) = result {
                storage?.put(profile)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        })
    }
}
