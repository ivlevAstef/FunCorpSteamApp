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

    static let avatarSize: CGSize = CGSize(width: 92, height: 92)

    static let textAvatarSpace: CGFloat = 16.0
    static let textSpace: CGFloat = 8.0
}

final class ProfileScreenView: ApViewController, ProfileScreenViewContract
{
    let needUpdateNotifier = Notifier<Void>()

    private let waitRequestFinishView = WaitRequestFinishedView()

    private let topView = UIView(frame: .zero)
    private let avatarView = UIImageView(image: nil)
    private let nickNameLabel = UILabel(frame: .zero)
    private let realNameLabel = UILabel(frame: .zero)

    init() {
        super.init(navStatusBar: nil)
        _ = self.view // load view
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func styleDidChange(_ style: Style) {
        super.styleDidChange(style)

        avatarView.layer.borderColor = style.colors.accent.cgColor
        avatarView.layer.borderWidth = 2.0

        nickNameLabel.font = style.fonts.large
        nickNameLabel.textColor = style.colors.mainText

        realNameLabel.font = style.fonts.large
        nickNameLabel.textColor = style.colors.mainText

        waitRequestFinishView.apply(use: style)
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
        profile.avatar.join(imageView: avatarView)
        nickNameLabel.text = profile.nick
        realNameLabel.text = profile.realName
    }

    func showGames(_ games: [ProfileGameViewModel]) {
        
    }

    private func configureViews() {
        view.addSubview(topView)
        topView.addSubview(avatarView)
        topView.addSubview(nickNameLabel)
        topView.addSubview(realNameLabel)

        view.addSubview(waitRequestFinishView)

        nickNameLabel.text = " "
        realNameLabel.text = " "

        topView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(style.layout.innerInsets.top + Consts.topOffset)
            maker.left.equalToSuperview().offset(style.layout.innerInsets.left)
            maker.right.equalToSuperview().offset(-style.layout.innerInsets.right)
        }

        avatarView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.size.equalTo(Consts.avatarSize)
        }

        nickNameLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.left.equalTo(avatarView.snp.right).offset(Consts.textAvatarSpace)
            maker.right.equalToSuperview()
        }

        realNameLabel.snp.makeConstraints { maker in
            maker.top.equalTo(nickNameLabel.snp.bottom).offset(Consts.textSpace)
            maker.left.equalTo(nickNameLabel.snp.left)
            maker.right.equalTo(nickNameLabel.snp.right)
        }

        waitRequestFinishView.snp.makeConstraints { maker in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }

}
