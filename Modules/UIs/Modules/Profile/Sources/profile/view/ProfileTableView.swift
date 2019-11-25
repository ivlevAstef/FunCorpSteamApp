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

final class ProfileTableView: UITableView
{
    private var profileViewModel: CellViewModel<ProfileViewModel> = .loading

    private var sectionTitles: [String?] = [nil, nil]
    private var gamesViewModels: [CellViewModel<ProfileGameInfoViewModel>] = []
    private var designStyle: Design.Style?

    init() {
        super.init(frame: .zero, style: .plain)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setGamesSectionTitle(_ text: String) {
        sectionTitles[1] = text
    }

    func updateProfile(_ viewModel: CellViewModel<ProfileViewModel>) {
        log.assert(Thread.isMainThread, "Thread.isMainThread")

        profileViewModel = viewModel
        reloadData()
    }

    func updateGames(_ viewModels: [CellViewModel<ProfileGameInfoViewModel>]) {
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

extension ProfileTableView: StylizingView {
    func apply(use style: Design.Style) {
        self.designStyle = style
        self.backgroundColor = style.colors.background
        self.separatorColor = style.colors.separator
        reloadData()
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
        return nil != sectionTitles[section] ? 30.0 : 0.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let style = designStyle else {
            return nil
        }
        guard let text = sectionTitles[section] else {
            return nil
        }

        let view = UIView()
        let titleLabel = UILabel(frame: .zero)
        view.addSubview(titleLabel)

        view.backgroundColor = style.colors.background

        titleLabel.font = style.fonts.title
        titleLabel.textColor = style.colors.mainText
        titleLabel.text = text

        titleLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(4.0)
            maker.left.equalToSuperview().offset(style.layout.cellInnerInsets.left)
            maker.right.equalToSuperview().offset(-style.layout.cellInnerInsets.right)
            maker.bottom.equalToSuperview().offset(-4.0)
        }

        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if 0 == indexPath.section {
            return tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath)
        }
        return tableView.dequeueReusableCell(withIdentifier: ProfileGameCell.identifier, for: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let style = self.designStyle else {
            log.assert("use table without setup style - please setup style")
            return
        }

        if let profileCell = cell as? ProfileCell {
            profileCell.configure(profileViewModel, style: style)
        }

        if let gameCell = cell as? ProfileGameCell {
            let viewModel = gamesViewModels[indexPath.row]

            gameCell.configure(viewModel, style: style)
        }
    }
}
