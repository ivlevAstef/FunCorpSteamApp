//
//  SteamNavBarMaker.swift
//  AppUIComponents
//
//  Created by Alexander Ivlev on 25/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import UIComponents
import Services

/// Да. Это God Object. Ибо и данные грузит, и данные отображает... но что поделать если нужен во всех местах по задумке.
public final class SteamNavBar: NSObject {
    public let tapOnAvatarNotifier = Notifier<SteamID>()

    public private(set) lazy var view: StatusNavigationBar = {
        let navBar = StatusNavigationBar()
        navBar.initialDisplayMode = .large
        navBar.displayMode = .largeAuto
        navBar.rightItemsGlueBottom = true

        return navBar
    }()

    public weak var parentVC: ApViewController? {
        didSet { configure() }
    }

    private lazy var avatarView: NavigationSteamAvatarView = {
        let view = NavigationSteamAvatarView()
        view.setup(letter: "  ")
        return view
    }()
    private lazy var centerContentView = NavigationCenterTextView()

    private lazy var profileInfoView = NavigationSteamProfileAccessoryView()

    private let avatarService: AvatarService
    private let profileService: SteamProfileService

    private var steamId: SteamID?

    init(avatarService: AvatarService, profileService: SteamProfileService) {
        self.avatarService = avatarService
        self.profileService = profileService
        super.init()
    }

    public func setSteamID(_ steamId: SteamID) {
        self.steamId = steamId
        profileService.getNotifier(for: steamId).weakJoin(listener: { owner, result in
            owner.processProfileResult(result)
        }, owner: self)

        beginLoading()
        profileService.refresh(for: steamId, completion: { [weak self] success in
            self?.endLoading(success)
        })
    }

     private func configure() {
        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar)))
        view.rightItems = [avatarView]
        parentVC?.addViewForStylizing(avatarView)

        view.centerContentView = centerContentView
        parentVC?.addViewForStylizing(centerContentView)

        if let steamID = (parentVC?.navigationController as? SteamNavigationViewController)?.steamID {
            setSteamID(steamID)
        }

        view.accessoryItems = [profileInfoView]
        parentVC?.addViewForStylizing(profileInfoView)


//        let searchView = NavigationSearchBarAccessoryView()
//        searchView.placeholder = "Search"
//        navBar.accessoryItems = [searchView]
//        addViewForStylizing(searchView)
    }


    private func processProfileResult(_ result: SteamProfileResult) {
        switch result {
        case .failure(.cancelled):
            break

        case .failure(.notConnection):
            showError(loc["Errors.NotConnect"])

        case .failure(.notFound), .failure(.incorrectResponse):
            showError(loc["Errors.IncorrectResponse"])

        case .success(let profile):
            processProfile(profile)
        }
    }

    private func processProfile(_ profile: SteamProfile) {
        profileInfoView.setProfile(profile)

        let avatar = ChangeableImage(placeholder: nil, image: nil)
        avatarView.setup(avatar, letter: String(profile.nickName.prefix(2)))

        centerContentView.text = profile.nickName

        avatar.join(listener: { [weak view] _ in
            view?.update(force: true)
        })

        avatarService.fetch(url: profile.avatarURL, to: avatar)

        view.update(force: true)
    }


    private func beginLoading() {
//        parentVC?.addViewForStylizing(avatarView.startSkeleton())
//        parentVC?.addViewForStylizing(centerContentView.startSkeleton())
    }

    private func endLoading(_ success: Bool) {
//        if success {
//            avatarView.endSkeleton()
//            centerContentView.endSkeleton()
//        } else {
//            avatarView.failedSkeleton()
//            centerContentView.failedSkeleton()
//        }
    }

    private func showError(_ text: String) {
        //ErrorAlert.show(text, on: parentVC)
    }

    @objc
    private func tapOnAvatar() {
        if let steamId = self.steamId {
            tapOnAvatarNotifier.notify(steamId)
        }
    }
}
