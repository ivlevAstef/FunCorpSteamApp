//
//  ProfileTableView.swift
//  Profile
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common
import UIKit
import SnapKit
import Design
import UIComponents

final class ProfileTableView: ApTableView
{
    private var profileViewModel: SkeletonViewModel<ProfileViewModel> = .loading

    // TODO: вообще есть более красивое уже решение, но переписывать некогда
    private var sectionTitles: [String?] = [nil, nil]
    private var gamesViewModels: [SkeletonViewModel<ProfileGameInfoViewModel>] = []

    init() {
        super.init(frame: .zero, style: .grouped)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setGamesSectionTitle(_ text: String) {
        sectionTitles[1] = text
    }

    func updateProfile(_ viewModel: SkeletonViewModel<ProfileViewModel>) {
        log.assert(Thread.isMainThread, "Thread.isMainThread")

        profileViewModel = viewModel
        reloadData()
    }

    func updateGames(_ viewModels: [SkeletonViewModel<ProfileGameInfoViewModel>]) {
        log.assert(Thread.isMainThread, "Thread.isMainThread")

        gamesViewModels = viewModels
        reloadData()
    }

    private func commonInit() {
        register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        register(ProfileGameCell.self, forCellReuseIdentifier: ProfileGameCell.identifier)
        self.dataSource = self
        self.delegate = self

        self.tableFooterView = UIView(frame: .zero)
    }
}

extension ProfileTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 0 == section {
            return 1
        }
        return gamesViewModels.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateHeight(for: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateHeight(for: indexPath)
    }

    private func calculateHeight(for indexPath: IndexPath) -> CGFloat {
        if 0 == indexPath.section {
            return ProfileCell.preferredHeight
        }
        return ProfileGameCell.preferredHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return nil != sectionTitles[section] ? ApSectionTitleView.preferredHeight : 0.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let text = sectionTitles[section] else {
            return nil
        }

        let view = ApSectionTitleView(text: text)
        addViewForStylizing(view)

        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if 0 == indexPath.section {
            return tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath)
        }
        return tableView.dequeueReusableCell(withIdentifier: ProfileGameCell.identifier, for: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let profileCell = cell as? ProfileCell {
            profileCell.configure(profileViewModel)
            addViewForStylizing(profileCell)
        }

        if let gameCell = cell as? ProfileGameCell {
            let viewModel = gamesViewModels[indexPath.row]

            gameCell.configure(viewModel)

            addViewForStylizing(gameCell)
        }
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return shouldHighlightRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if shouldHighlightRow(at: indexPath) {
            return indexPath
        }
        return nil
    }

    private func shouldHighlightRow(at indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            if case .done(let viewModel) = profileViewModel {
                return !viewModel.isPrivate
            }
            return false
        }

        if case .done = gamesViewModels[indexPath.row] {
            return true
        }
        return false
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if case let .done(viewModel) = profileViewModel {
                DispatchQueue.main.async {
                    viewModel.tapNotifier.notify(())
                }
            }
        } else {
            if case let .done(viewModel) = gamesViewModels[indexPath.row] {
                DispatchQueue.main.async {
                    viewModel.tapNotifier.notify(())
                }
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
