//
//  CustomGameInfoViewContract.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

protocol CustomGameInfoViewContract: class
{
    func addCustomSection(title: String?, order: UInt, configurators: [CustomTableCellConfigurator])
    func removeCustomSection(order: UInt)

    func beginCustomLoading(order: UInt, row: UInt)
    func failedCustomLoading(order: UInt, row: UInt)

    func showCustom(order: UInt, row: UInt)

    func showError(_ text: String)
}
