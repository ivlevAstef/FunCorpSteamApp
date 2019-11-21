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
}

final class ProfileScreenView: ApViewController, ProfileScreenViewContract
{
    init() {
        super.init(navStatusBar: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
