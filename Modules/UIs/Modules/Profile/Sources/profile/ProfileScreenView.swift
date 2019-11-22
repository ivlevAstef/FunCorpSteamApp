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

/// Лень и времени не много, чтобы еще модель во ViewModel мапить
import Services
import ServicesImpl

private enum Consts {
}

final class ProfileScreenView: ApViewController, ProfileScreenViewContract
{
    let needUpdateNotifier = Notifier<Void>()

    private let waitRequestFinishView = WaitRequestFinishedView()

    init() {
        super.init(navStatusBar: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(waitRequestFinishView)
        addViewForStylizing(waitRequestFinishView)

        waitRequestFinishView.snp.makeConstraints { maker in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        needUpdateNotifier.notify(())
    }

    func beginLoading(_ text: String) {
        waitRequestFinishView.show(text, animateDuration: style.animation.animationTime)
    }

    func endLoading() {
        waitRequestFinishView.hide(animateDuration: style.animation.animationTime)
    }

    func showError(_ text: String) {
        ErrorAlert.show(text, on: self)
    }

    func showProfile(_ profile: SteamProfile) {

    }

}
