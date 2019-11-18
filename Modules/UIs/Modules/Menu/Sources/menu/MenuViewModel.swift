//
//  MenuViewModel.swift
//  Menu
//
//  Created by Alexander Ivlev on 19/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

struct MenuViewModel {
    let icon: ConstImage
    let title: String

    let show: Notifier<Void>
}
