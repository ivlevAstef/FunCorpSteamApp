//
//  FriendsScreenView.swift
//  Profile
//
//  Created by Alexander Ivlev on 26/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import AppUIComponents
import UIComponents
import Common
import Design
import SnapKit
import Services

final class FriendsScreenView: ApViewController, FriendsScreenViewContract
{
    let needUpdateNotifier = Notifier<Void>()

    private let tableView = FriendsTableView()

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = loc["SteamFriends.Title"]

        configureViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        needUpdateNotifier.notify(())
    }

    func setTitle(_ text: String) {
        title = text
    }

    func beginLoading() {
        tableView.updateFriends(Array(repeating: FriendViewModel(empty: .loading), count: 8))
    }

    func failedLoading() {
        tableView.updateFriends(Array(repeating: FriendViewModel(empty: .failed), count: 8))
    }

    func updateFriends(_ friends: [FriendViewModel]) {
        tableView.updateFriends(friends)
    }

    func updateFriend(_ friend: FriendViewModel) {
        tableView.updateFriend(friend)
    }

    // MARK: - other

    func showError(_ text: String) {
        ErrorAlert.show(text, on: self)
    }

    private func configureViews() {
        view.addSubview(tableView)

        tableView.clipsToBounds = true
        tableView.backgroundColor = .clear

        addViewForStylizing(tableView)

        tableView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }

}
