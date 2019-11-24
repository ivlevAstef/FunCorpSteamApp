//
//  SteamNavigationController.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 25/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import UIKit
import UIComponents
import Services

import Foundation

/// Просто объект который позволяет всем SteamNavBar автоматически получать steamID, если в роутере был установлен
class SteamNavigationViewController: ApNavigationController {
    var steamID: SteamID?
}


public protocol SteamNavigationController: class
{
    func setSteamId(_ steamId: SteamID)

}

extension NavigationController: SteamNavigationController
{
    public func setSteamId(_ steamId: SteamID) {
        (uiController as? SteamNavigationViewController)?.steamID = steamId
    }
}
