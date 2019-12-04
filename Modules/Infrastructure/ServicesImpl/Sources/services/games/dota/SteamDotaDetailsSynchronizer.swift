//
//  SteamDotaDetailsSynchronizer.swift
//  ServicesImpl
//
//  Created by Alexander Ivlev on 04/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

private let synchronizationCooldown: TimeInterval = 60.0/*sec*/ * 4.0/*min*/

final class SteamDotaDetailsSynchronizer
{
    enum DetailsWaiterResult {
        case first
        case response(matchId: DotaMatchID, result: DotaMatchDetailsResult)
    }

    private var inProgress: Set<DotaMatchID> = []
    private let inProgressLock = FastLock()

    private var lastSynchonizationDate: Date = Date(timeIntervalSince1970: 0)
    private let synchronizationQueue = DispatchQueue(label: "dota details synchronization", qos: .default)
    private let synchronizationMonitor: NSObject = NSObject()
    /// Те кто ожидают изменений в деталях. Оповещаются о любом изменении. Если вернул true, то это означает, что его нужно удалить.
    /// При добавлении, вызовется с событием .failed(.cancelled) и nil в matchId - сделано для "удобства", чтобы проверить есть ли нужные данные.
    private var waiters: [(DetailsWaiterResult) -> Bool] = []
    private let waitersMonitor = NSObject()

    private let network: SteamDotaNetwork
    private let storage: SteamDotaStorage

    private let accountId: AccountID

    init(network: SteamDotaNetwork, storage: SteamDotaStorage, accountId: AccountID) {
        self.network = network
        self.storage = storage
        self.accountId = accountId
    }

    func synchronize(waiter: @escaping (DetailsWaiterResult) -> Bool) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.notThreadSynchronize(waiter: waiter)
        }
    }

    private func notThreadSynchronize(waiter: @escaping (DetailsWaiterResult) -> Bool) {
        objc_sync_enter(synchronizationMonitor)
        defer { objc_sync_exit(synchronizationMonitor) }

        func updateWaiters() -> Bool {
            objc_sync_enter(self.waitersMonitor)
            defer { objc_sync_exit(self.waitersMonitor) }

            let isNeedRemove = waiter(.first)
            if isNeedRemove {
                /// Если все данные и так есть, то и смысл запускать синхронизацию?
                /// Но проверить за пределами нельзя - так как иначе можно случайно получить ситуацию, что данных не было, а пока запускали синхронизацию,
                /// они уже пришли, и второй раз они уже точно не прийдут - это приведет к бесконечному ожиданию
                return false
            }

            waiters.append(waiter)
            return true
        }

        if !updateWaiters() {
            return
        }

        /// Если недавно уже запускалась синхронизация, то лучше отдохнуть - зачем снова дергать, и с 99% вероятностью ничего не сделать
        if lastSynchonizationDate.timeIntervalSinceNow + synchronizationCooldown > 0 {
            return
        }

        let matches = storage.fetchMatches(for: accountId)
        /// Сортируем матчи, так чтобы последнии были первыми, дабы их быстрее подгрузить
        let sortedMatches = matches.sorted(by: { $0.startTime > $1.startTime })

        let loadedMatches = Set(storage.fetchDetailsList(for: accountId).map { $0.matchId })

        for match in sortedMatches {
            /// Если данные уже загружены, или они находятся в процессе загрузки, то заново их запрашивать смысла нет
            if loadedMatches.contains(match.matchId) {
                continue
            }

            inProgressLock.lock()
            defer { inProgressLock.unlock() }
            if inProgress.contains(match.matchId) {
                continue
            }
            inProgress.insert(match.matchId)

            synchronizationQueue.async { [weak self] in
                self?.loadDetails(matchId: match.matchId)
            }
        }
    }

    private func loadDetails(matchId: DotaMatchID) {
        /// Специально дожидаемся завершения запроса. Нужно чисто, чтобы сервер не заспамить...
        let waitResultSemaphore = DispatchSemaphore(value: 0)
        network.requestDetails(matchId: matchId) { [weak self] result in
            defer { waitResultSemaphore.signal() }
            guard let self = self else {
                return
            }

            if case .success(let details) = result {
                self.storage.put(details: details, for: self.accountId)
            }

            self.notifyDetails(matchId: matchId, result: result)

            self.inProgressLock.lock()
            self.inProgress.remove(matchId)
            self.inProgressLock.unlock()
        }
        waitResultSemaphore.wait()
    }

    private func notifyDetails(matchId: DotaMatchID, result: DotaMatchDetailsResult) {
        objc_sync_enter(waitersMonitor)
        defer { objc_sync_exit(waitersMonitor) }

        // Не очень красиво объединять вызов, и удаление, но зато эффективно
        waiters.removeAll { waiter in
            return waiter(.response(matchId: matchId, result: result))
        }
    }

}
