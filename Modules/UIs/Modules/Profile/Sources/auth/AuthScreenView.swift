//
//  AuthScreenView.swift
//  Profile
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import UIComponents
import Common
import Design
import SnapKit

private enum Consts {
    static let steamAuthIcon = ConstImage(named: "steamAuth")
    static let buttonSize = CGSize(width: 223, height: 33)
}

final class AuthScreenView: ApViewController, AuthScreenViewContract
{
    let startSteamAuthNotifier = Notifier<Void>()

    private let containerView: UIView = UIView(frame: .zero)
    private let informationText: UILabel = UILabel(frame: .zero)
    private let steamAuthButton: UIButton = UIButton(frame: .zero)

    init() {
        super.init(navStatusBar: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }

    override func styleDidChange(_ style: Style) {
        super.styleDidChange(style)

        containerView.backgroundColor = .clear

        informationText.numberOfLines = 0
        informationText.textAlignment = .center
        informationText.font = style.fonts.title
        informationText.textColor = style.colors.mainText

        steamAuthButton.setImage(Consts.steamAuthIcon.image, for: .normal)
    }

    func blockUI() {
        steamAuthButton.isEnabled = false
    }

    func unblockUI() {
        steamAuthButton.isEnabled = true
    }

    func setInformationText(_ text: String) {
        informationText.text = text
    }

    func showError(_ text: String) {
        ErrorAlert.show(text, on: self)
    }

    private func configureViews() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        informationText.translatesAutoresizingMaskIntoConstraints = false
        steamAuthButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.addSubview(informationText)
        containerView.addSubview(steamAuthButton)

        steamAuthButton.addTarget(self, action: #selector(clickOnSteamAuthButton), for: .touchDown)

        containerView.snp.makeConstraints { maker in
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.centerY.equalToSuperview()
        }

        informationText.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
        }

        steamAuthButton.snp.makeConstraints { maker in
            maker.top.equalTo(informationText.snp.bottom).offset(32.0)

            maker.centerX.equalToSuperview()
            maker.size.equalTo(Consts.buttonSize)
            maker.bottom.equalToSuperview()
        }
    }

    @objc
    private func clickOnSteamAuthButton() {
        startSteamAuthNotifier.notify(())
    }
}
