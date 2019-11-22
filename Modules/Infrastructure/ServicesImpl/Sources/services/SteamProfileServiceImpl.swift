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
    private class ProfileNotifier: SteamProfileServiceSubscriber {
        private let callback: (SteamProfileResult) -> Void
        var profile: SteamProfile?
        var notifyAboutError: Bool = true

        init(_ callback: @escaping (SteamProfileResult) -> Void) {
            self.callback = callback
        }

        func notify(_ result: SteamProfileResult) {
            /// ignore BD errors
            if case .failure(.notFound) = result {
                return
            }
            callback(result)
        }
    }

    private let network: SteamProfileNetwork
    private let storage: SteamProfileStorage

    private var subscribers: [SteamID: [Weak<ProfileNotifier>]] = [:]

    init(network: SteamProfileNetwork, storage: SteamProfileStorage) {
        self.network = network
        self.storage = storage
    }

    func fetch(by steamId: SteamID, completion: @escaping (SteamProfileResult) -> Void) {
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

    func update(by steamId: SteamID, completion: @escaping (SteamProfileResult) -> Void) {
        network.request(by: steamId, completion: { [weak storage] result in
            if case let .success(profile) = result {
                storage?.put(profile)
            }
            DispatchQueue.main.async { [weak self] in
                completion(result)
                self?.notifySubscribers(for: steamId, result: result)
            }
        })
    }


    func join(to steamId: SteamID, callback: @escaping (SteamProfileResult) -> Void) -> SteamProfileServiceSubscriber {
        log.assert(Thread.isMainThread, "Thread.isMainThread")
        let profileNotifier = ProfileNotifier(callback)
        subscribers[steamId, default: []].append(Weak(profileNotifier))

        fetch(by: steamId) { [weak self] result in
            self?.notifySubscribers(for: steamId, result: result)
            self?.update(by: steamId)
        }
        
        return profileNotifier
    }

    private func notifySubscribers(for steamId: SteamID, result: SteamProfileResult) {
        log.assert(Thread.isMainThread, "Thread.isMainThread")
        subscribers[steamId]?.removeAll(where: {
            return $0.value == nil
        })

        var newProfile: SteamProfile?
        if case let .success(profile) = result {
            newProfile = profile
        }

        for notifier in subscribers[steamId] ?? [] {
            guard let notifier = notifier.value else {
                continue
            }

            defer { notifier.notifyAboutError = false }
            /// Если надо сообщить об ошибке, и это ошибка, то сообщаем
            if notifier.notifyAboutError && nil == newProfile {
                notifier.notify(result)
                continue
            }

            /// Если прошло состояние не равно новому, и новое при этом не ошибка, то сохраняем и оповещаем
            if notifier.profile != newProfile && newProfile != nil {
                notifier.profile = newProfile
                notifier.notify(result)
            }
        }
    }
}
