//
//  ProfileGamesTableView.swift
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

final class ProfileGamesTableView: ApTableView
{
    private var sectionTitle: String?
    private var viewModels: [ProfileGameInfoViewModel] = []
    private var designStyle: Design.Style?

    init() {
        super.init(frame: .zero, style: .plain)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSectionTitle(_ text: String) {
        sectionTitle = text
    }

    func update(_ viewModels: [ProfileGameInfoViewModel]) {
        log.assert(Thread.isMainThread, "Thread.isMainThread")

        self.viewModels = viewModels
        reloadData()
    }

    private func commonInit() {
        register(ProfileGameCell.self, forCellReuseIdentifier: ProfileGameCell.identifier)
        self.dataSource = self
        self.delegate = self

        self.tableFooterView = UIView(frame: .zero)

        estimatedRowHeight = 60.0
        rowHeight = 60.0
        sectionHeaderHeight = 30.0
    }
}

extension ProfileGamesTableView: StylizingView {
    func apply(use style: Design.Style) {
        self.designStyle = style
        self.backgroundColor = style.colors.background
        self.separatorColor = style.colors.separator
        reloadData()
    }
}

extension ProfileGamesTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let style = designStyle, let text = sectionTitle else {
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
        return tableView.dequeueReusableCell(withIdentifier: ProfileGameCell.identifier, for: indexPath)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let style = self.designStyle else {
            log.assert("use table without setup style - please setup style")
            return
        }

        if let gameCell = cell as? ProfileGameCell {
            let viewModel = viewModels[indexPath.row]

            gameCell.configure(viewModel, style: style)
        }
    }
}

private final class ProfileGameCell: UITableViewCell {
    static let identifier = "\(ProfileGameCell.self)"

    private let iconImageView = IdImageView(image: nil)
    private let nameLabel = UILabel(frame: .zero)
    private let timeLabel = UILabel(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ viewModel: ProfileGameInfoViewModel, style: Design.Style) {
        // TODO: в идеале можно убедиться что style не менялся...
        relayout(use: style.layout)
        setStyle(style: style)

        viewModel.icon.join(imageView: iconImageView)

        nameLabel.text = viewModel.name
        timeLabel.text = viewModel.playtimePrefix + viewModel.playtime.adaptiveString
    }

    private func commonInit() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)

        nameLabel.text = " "
        timeLabel.text = " "
    }

    private func setStyle(style: Style) {
        nameLabel.font = style.fonts.title
        nameLabel.textColor = style.colors.mainText
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.numberOfLines = 1

        timeLabel.font = style.fonts.subtitle
        timeLabel.textColor = style.colors.notAccentText
        timeLabel.numberOfLines = 1
    }

    private func relayout(use layout: Style.Layout) {
        iconImageView.snp.remakeConstraints { maker in
            maker.size.equalTo(CGSize(width: 50.0, height: 50.0))
            maker.top.equalToSuperview().offset(5.0)
            maker.left.equalToSuperview().offset(layout.cellInnerInsets.left)
        }

        nameLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(iconImageView.snp.top)
            maker.left.equalTo(iconImageView.snp.right).offset(8.0)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
        }

        timeLabel.snp.remakeConstraints { maker in
            maker.top.equalTo(nameLabel.snp.bottom).offset(4.0)
            maker.left.equalTo(iconImageView.snp.right).offset(8.0)
            maker.right.equalToSuperview().offset(-layout.cellInnerInsets.right)
        }
   }
}
