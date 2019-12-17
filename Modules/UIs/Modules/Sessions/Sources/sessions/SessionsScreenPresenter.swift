//
//  SessionsScreenPresenter.swift
//  Sessions
//
//  Created by Alexander Ivlev on 24/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//


import Common
import Entities
import UseCases

protocol SessionsScreenViewContract: class
{
    var needUpdateNotifier: Notifier<Void> { get }

    func beginLoading()

    func failedLoadingSessions()
    func showSessions(_ sessions: [SessionViewModel])

    func showError(_ text: String)
}

final class SessionsScreenPresenter
{
    let tapOnGameNotifier = Notifier<(SteamID, SteamGameID)>()

    private weak var view: SessionsScreenViewContract?
    private let sessionsService: SteamSessionsService
    private let imageService: ImageService

    private var isFirstRefresh: Bool = true
    private var cachedSessionViewModels: [SteamGameID: SessionViewModel] = [:]

    init(view: SessionsScreenViewContract,
         sessionsService: SteamSessionsService,
         imageService: ImageService) {
        self.view = view
        self.sessionsService = sessionsService
        self.imageService = imageService
    }

    func configure(steamId: SteamID) {
        sessionsService.getSessionsNotifier(for: steamId).weakJoin(listener: { (self, result) in
            self.processSessionsResult(result, steamId: steamId)
        }, owner: self)

        view?.needUpdateNotifier.join(listener: { [weak self] in
            self?.refresh(for: steamId)
        })
    }

    private func refresh(for steamId: SteamID) {
        if isFirstRefresh {
            view?.beginLoading()

            sessionsService.refreshSessions(for: steamId) { [weak view] success in
                if !success {
                    view?.failedLoadingSessions()
                }
            }
        } else {
            sessionsService.refreshSessions(for: steamId)
        }
        isFirstRefresh = false
    }

    // MARK: - sessions

    private func processSessionsResult(_ result: SteamSessionsResult, steamId: SteamID) {
        switch result {
        case .failure(.cancelled), .failure(.incorrectResponse), .failure(.customError):
            break
        case .failure(.notConnection):
            view?.showError(loc["Errors.NotConnect"])

        case .success(let sessions):
            processSessions(sessions, steamId: steamId)
        }
    }

    private func processSessions(_ sessions: [SteamSession], steamId: SteamID) {
        guard let view = view else {
            return
        }

        let viewModels: [SessionViewModel] = sessions.map { session in
            let cachedViewModel = cachedSessionViewModels[session.gameInfo.gameId]
            let viewModel = SessionViewModel(
                icon: cachedViewModel?.icon ?? ChangeableImage(placeholder: nil, image: nil),
                name: session.gameInfo.name,
                playtimeForeverPrefix: loc["Game.PlayTimeForeverPrefix"],
                playtimeForever: session.playtimeForever,
                playtime2weeksPrefix: loc["Game.PlayTime2weeksPrefix"],
                playtime2weeks: session.playtime2weeks,
                playtime2weeksSuffix: loc["Game.PlayTime2weeksSuffix"],
                tapNotifier: Notifier<Void>()
            )
            cachedSessionViewModels[session.gameInfo.gameId] = viewModel

            viewModel.tapNotifier.weakJoin(tapOnGameNotifier, owner: self) { (self, _) -> (SteamID, SteamGameID) in
                return (steamId, session.gameInfo.gameId)
            }

            imageService.deferredFetch(url: session.gameInfo.iconUrl, to: viewModel.icon)

            return viewModel
        }

        view.showSessions(viewModels)
    }
}

