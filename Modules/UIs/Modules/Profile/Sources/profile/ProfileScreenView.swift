//
//  ProfileScreenView.swift
//  Profile
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import UIComponents
import Common
import Design
import SnapKit

private enum Consts {
    static let topOffset: CGFloat = 32.0
}

final class ProfileScreenView: ApViewController, ProfileScreenViewContract
{
    let needUpdateNotifier = Notifier<Void>()

    private let topView = ProfileTopView()
    private let gamesView = ProfileGamesTableView()

    init() {
        super.init(navStatusBar: nil)
        _ = self.view // load view
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        needUpdateNotifier.notify(())
    }

    func beginLoading() {
        for subview in topView.subviews {
            addViewForStylizing(subview.startSkeleton())
        }
    }

    func endLoading(_ success: Bool) {
        if success {
            for subview in topView.subviews {
                subview.endSkeleton()
            }
        } else {
            for subview in topView.subviews {
                subview.failedSkeleton()
            }
        }
    }

    func showError(_ text: String) {
        ErrorAlert.show(text, on: self)
    }

    func showProfile(_ profile: ProfileViewModel) {
        topView.update(profile: profile)
    }

    func showGames(_ games: [ProfileGameViewModel]) {
        gamesView.update(games)
    }

    private func configureViews() {
        view.addSubview(gamesView)
        view.addSubview(topView)

        gamesView.clipsToBounds = true
        gamesView.backgroundColor = .clear

        addViewForStylizing(topView)
        addViewForStylizing(gamesView)

        topView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(Consts.topOffset)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
        }
        gamesView.snp.makeConstraints { maker in
            maker.top.equalTo(topView.snp.bottom)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }

}
