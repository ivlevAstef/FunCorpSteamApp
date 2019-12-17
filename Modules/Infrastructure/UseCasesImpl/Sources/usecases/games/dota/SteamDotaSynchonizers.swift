//
//  SteamDotaSynchronizer.swift
//  UseCasesImpl
//
//  Created by Alexander Ivlev on 04/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Entities
import UseCases
import SwiftLazy

final class SteamDotaSynchronizers {
    private let historySynchronizerProvider: Provider1<SteamDotaHistorySynchronizer, AccountID>
    private let detailsSynchronizerProvider: Provider1<SteamDotaDetailsSynchronizer, AccountID>

    private var historySynchonizersByAccount: [AccountID: SteamDotaHistorySynchronizer] = [:]
    private var detailsSynchonizersByAccount: [AccountID: SteamDotaDetailsSynchronizer] = [:]

    private var lock = FastLock()

    init(historySynchronizerProvider: Provider1<SteamDotaHistorySynchronizer, AccountID>,
         detailsSynchronizerProvider: Provider1<SteamDotaDetailsSynchronizer, AccountID>) {
        self.historySynchronizerProvider = historySynchronizerProvider
        self.detailsSynchronizerProvider = detailsSynchronizerProvider
    }

    func historySynchronizer(for accountId: AccountID) -> SteamDotaHistorySynchronizer {
        lock.lock()
        defer { lock.unlock() }

        if let synchronizer = historySynchonizersByAccount[accountId] {
            return synchronizer
        }
        let synchronizer = historySynchronizerProvider.value(accountId)
        historySynchonizersByAccount[accountId] = synchronizer

        return synchronizer
    }

    func detailsSynchronizer(for accountId: AccountID) -> SteamDotaDetailsSynchronizer {
           lock.lock()
           defer { lock.unlock() }

           if let synchronizer = detailsSynchonizersByAccount[accountId] {
               return synchronizer
           }
           let synchronizer = detailsSynchronizerProvider.value(accountId)
           detailsSynchonizersByAccount[accountId] = synchronizer

           return synchronizer
       }
}
