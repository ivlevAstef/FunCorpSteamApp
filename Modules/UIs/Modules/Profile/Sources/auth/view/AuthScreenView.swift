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

let key = ""

final class AuthScreenView: ApViewController, AuthScreenViewContract
{
    init() {
        super.init(navStatusBar: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        // Do any additional setup after loading the view.
    }
}
