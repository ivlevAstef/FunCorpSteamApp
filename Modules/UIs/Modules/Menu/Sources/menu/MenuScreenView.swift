//
//  MenuScreenView.swift
//  Menu
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import Common
import UIComponents
import Design

final class MenuScreenView: ApViewController, MenuScreenViewContract
{
    var viewModels: [MenuViewModel] = []

    public init() {
        super.init(navStatusBar: nil)

        view.backgroundColor = .red
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func styleDidChange(_ style: Style) {
        super.styleDidChange(style)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
