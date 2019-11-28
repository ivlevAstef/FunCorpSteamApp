//
//  SteamAchievementServiceImpl.swift
//  ServicesImpl
//
//  Created by Alexander Ivlev on 27/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

final class SteamAchievementServiceImpl: SteamAchievementService
{
    private struct CompletionsKey: Hashable {
        let gameId: SteamGameID
        let steamId: SteamID
    }
    private var resultNotifiers: [CompletionsKey: Notifier<SteamAchievementsSummaryResult>] = [:]
    private var completions: [CompletionsKey: [(Bool) -> Void]] = [:]

    private let gameService: SteamGameService

    init(gameService: SteamGameService) {
        self.gameService = gameService
    }

    // MARK: - Achievements Summary

    func getAchievementsSummaryNotifier(for gameId: SteamGameID, steamId: SteamID) -> Notifier<SteamAchievementsSummaryResult> {
        log.assert(Thread.isMainThread, "Thread.isMainThread")
        let key = CompletionsKey(gameId: gameId, steamId: steamId)
        /// Если первый раз, то подписываем на обновления. Но это надо делать только один раз, дабы не заспамить
        if nil == resultNotifiers[key] {
            let gameProgressNotifier = gameService.getGameProgressNotifier(for: gameId, steamId: steamId)
            gameProgressNotifier.weakJoin(listener: { (self, result) in
                if self.hasListeners(key: key) {
                    self.processGameProgress(result, for: gameId, steamId: steamId)
                }
            }, owner: self)
        }

        let resultNotifier = resultNotifiers[key] ?? Notifier<SteamAchievementsSummaryResult>()
        resultNotifiers[key] = resultNotifier

        return resultNotifier
    }

    func refreshAchievementsSummary(for gameId: SteamGameID, steamId: SteamID, completion: ((Bool) -> Void)?) {
        log.assert(Thread.isMainThread, "Thread.isMainThread")
        if let completion = completion {
            let key = CompletionsKey(gameId: gameId, steamId: steamId)
            completions[key] = (completions[key] ?? []) + [completion]
        }

        gameService.refreshGameProgress(for: gameId, steamId: steamId)
    }

    /// Дабы лишний раз не дергать - так как игровой прогресс может обновляться в теории в тех случаях, когда суммарная информация не нужна
    private func hasListeners(key: CompletionsKey) -> Bool {
        log.assert(Thread.isMainThread, "Thread.isMainThread")
        let notifierHasListeners = resultNotifiers[key]?.hasListeners() ?? false
        let hasCompletions = (completions[key] ?? []).count > 0
        return notifierHasListeners && hasCompletions
    }

    private func processGameProgress(_ gameProgressResult: SteamGameProgressResult, for gameId: SteamGameID, steamId: SteamID) {
        switch gameProgressResult {
        case .failure(let serviceError):
            completeAchievementsSummary(.failure(serviceError), for: gameId, steamId: steamId)
        case .success(let gameProgress):
            // Тут локализация не имеет значения, поэтому пускай будет английская
            gameService.getScheme(for: gameProgress.gameId, loc: .en) { [weak self] schemeResult in
                self?.processScheme(schemeResult, gameProgress: gameProgress, for: gameId, steamId: steamId)
            }
        }
    }

    private func processScheme(_ schemeResult: SteamGameSchemeResult,
                               gameProgress: SteamGameProgress,
                               for gameId: SteamGameID,
                               steamId: SteamID) {
        switch schemeResult {
        case .failure(let serviceError):
            completeAchievementsSummary(.failure(serviceError), for: gameId, steamId: steamId)
        case .success(let scheme):
            let any = scheme.achivements.map { $0.id }
            let onlyVisible = scheme.achivements.compactMap { $0.hidden ? nil : $0.id }
            let current = gameProgress.achievements.compactMap { (key, value) in
                value.achieved ? key: nil
            }
            let result = SteamAchievementsSummary(current: Set(current),
                                                  any: Set(any),
                                                  onlyVisible: Set(onlyVisible))
            completeAchievementsSummary(.success(result), for: gameId, steamId: steamId)
        }
    }

    private func completeAchievementsSummary(_ result: SteamAchievementsSummaryResult, for gameId: SteamGameID, steamId: SteamID) {
        DispatchQueue.mainSync {
            let key = CompletionsKey(gameId: gameId, steamId: steamId)
            resultNotifiers[key]?.notify(result)

            var success: Bool = false
            if case .success = result {
                success = true
            }

            completions[key]?.forEach { competion in
                competion(success)
            }
            completions[key]?.removeAll()
        }
    }
}
