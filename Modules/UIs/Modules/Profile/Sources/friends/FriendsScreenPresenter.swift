//
//  FriendsScreenPresenter.swift
//  Profile
//
//  Created by Alexander Ivlev on 26/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

protocol FriendsScreenViewContract: class
{
    var needUpdateNotifier: Notifier<Void> { get }

    func beginLoading()
    func failedLoading()

    func updateFriends(_ friends: [FriendViewModel])

    func showError(_ text: String)
}

// Чаще чем раз в 15 секунд, не пытаемся обновить ячейку, дабы бесконечно не пытаться загружать не загружаемое
private let profileLoadCooldown: TimeInterval = 15.0

final class FriendsScreenPresenter
{
    let tapOnProfileNotifier = Notifier<SteamID>()

    private weak var view: FriendsScreenViewContract?
    private let profileService: SteamProfileService
    private let friendsService: SteamFriendsService
    private let imageService: ImageService

    // При первом обновлении показываем индикацию, при всех последующих в фоне
    private var isFirstRefresh: Bool = true

    private var friends: [FriendViewModel] = []
    // Дабы слишком часто не дергать запросы
    private var lastLoadingProfiles: [SteamID: Date] = [:]

    init(view: FriendsScreenViewContract,
         profileService: SteamProfileService,
         friendsService: SteamFriendsService,
         imageService: ImageService) {
        self.view = view
        self.profileService = profileService
        self.friendsService = friendsService
        self.imageService = imageService
    }

    func configure(steamId: SteamID) {
        friendsService.getNotifier(for: steamId).weakJoin(listener: { (self, result) in
            self.processFriendsResult(result)
        }, owner: self)

        view?.needUpdateNotifier.join(listener: { [weak self] in
            self?.refresh(for: steamId)
        })
    }

    private func refresh(for steamId: SteamID) {
        if isFirstRefresh {
            view?.beginLoading()
            friendsService.refresh(for: steamId) { [weak view] success in
                if !success {
                    view?.failedLoading()
                }
            }
        } else {
            friendsService.refresh(for: steamId)
        }

        isFirstRefresh = false
    }

    // MARK: - friends

    private func processFriendsResult(_ result: SteamFriendsResult) {
        switch result {
        case .failure(.cancelled):
            break
        case .failure(.notConnection):
            view?.showError(loc["Errors.NotConnect"])
        case .failure(.incorrectResponse):
            view?.showError(loc["Errors.IncorrectResponse"])

        case .success(let friends):
            processFriends(friends)
        }
    }

    private func processFriends(_ result: [SteamFriend]) {
        friends = result.map { friend in
            // Если до этого была уже модель, то не будем её терять
            if let viewModel = friends.first(where: { $0.steamId == friend.steamId }) {
                return viewModel
            }

            return makeFriendViewModel(steamId: friend.steamId, state: .loading)
        }

        view?.updateFriends(friends)
    }

    private func updateFriend(on viewModel: FriendViewModel) {
        guard let index = friends.firstIndex(where: { $0.steamId == viewModel.steamId }) else {
            log.warning("update friend, but not found id in friend list")
            return
        }

        if case .done = friends[index].state {
            // Если старое состояние, что все хорошо, а новое нет, то зачем перетирать хорошие данные?
            if case .done = viewModel.state { } else {
                return
            }
        }

        friends[index] = viewModel
        view?.updateFriends(friends)
    }

    private func makeFriendViewModel(steamId: SteamID, state: FriendViewModel.State) -> FriendViewModel {
        FriendViewModel(steamId: steamId, state: state, needUpdateCallback: { [weak self] in
            self?.reloadProfile(steamId: steamId)
        })
    }

    // MARK: - profile

    private func reloadProfile(steamId: SteamID) {
        // Защита от того, чтобы лишний раз не грузить.
        // Без подобного хака, во первых уйдет в бесконечную перезагрузку, а во вторых дергать по любому поводу, тоже не ок.
        if let date = lastLoadingProfiles[steamId], date.timeIntervalSinceNow + profileLoadCooldown > 0 {
            return
        }

        lastLoadingProfiles[steamId] = Date()
        profileService.getProfile(for: steamId) { [weak self] result in
            self?.processProfileResult(result, steamId: steamId)
        }
    }


    private func processProfileResult(_ result: SteamProfileResult, steamId: SteamID) {
        if case .success(let profile) = result {
            processProfile(profile)
        } else {
            updateFriend(on: makeFriendViewModel(steamId: steamId, state: .failed))
        }
    }

    private func processProfile(_ profile: SteamProfile) {
        var cachedContent: FriendViewModel.Content?
        if let viewModel = friends.first(where: { $0.steamId == profile.steamId }),
           case let .done(content) = viewModel.state {
            cachedContent = content
        }

        let content = FriendViewModel.Content(
            avatar: cachedContent?.avatar ?? ChangeableImage(placeholder: nil, image: nil),
            avatarLetter: String(profile.nickName.prefix(2)),
            nick: profile.nickName,
            tapNotifier: Notifier<Void>()
        )

        content.tapNotifier.weakJoin(tapOnProfileNotifier, owner: self) { (_, _) -> SteamID in
            return profile.steamId
        }

        imageService.fetch(url: profile.avatarURL, to: content.avatar)

        updateFriend(on: makeFriendViewModel(steamId: profile.steamId, state: .done(content)))
    }
}
