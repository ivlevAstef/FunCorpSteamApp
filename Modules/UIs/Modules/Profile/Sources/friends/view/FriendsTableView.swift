//
//  FriendsTableView.swift
//  Friends
//
//  Created by Alexander Ivlev on 30/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import UIKit
import SnapKit
import Design
import UIComponents

final class FriendsTableView: ApTableView
{
    private var friendsViewModels: [FriendViewModel] = []

    init() {
        super.init(frame: .zero, style: .grouped)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func updateFriends(_ viewModels: [FriendViewModel]) {
        log.assert(Thread.isMainThread, "Thread.isMainThread")

        friendsViewModels = viewModels
        reloadData()
    }

    private func commonInit() {
        register(FriendCell.self, forCellReuseIdentifier: FriendCell.identifier)
        self.dataSource = self
        self.delegate = self

        self.tableFooterView = UIView(frame: .zero)
    }
}

extension FriendsTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsViewModels.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateHeight(for: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateHeight(for: indexPath)
    }

    private func calculateHeight(for indexPath: IndexPath) -> CGFloat {
        return FriendCell.preferredHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let friendCell = cell as? FriendCell {
            friendCell.configure(friendsViewModels[indexPath.row])
            addViewForStylizing(friendCell)
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if case .done = friendsViewModels[indexPath.row].state {
            return indexPath
        }
        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case let .done(content) = friendsViewModels[indexPath.row].state {
            DispatchQueue.main.async {
                content.tapNotifier.notify(())
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
