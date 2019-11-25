//
//  ProfileViewModel.swift
//  Profile
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Common

struct ProfileViewModel
{
    let avatar: ChangeableImage
    let avatarLetter: String

    let nick: String
    var realName: String?

    let tapNotifier: Notifier<Void>
}
