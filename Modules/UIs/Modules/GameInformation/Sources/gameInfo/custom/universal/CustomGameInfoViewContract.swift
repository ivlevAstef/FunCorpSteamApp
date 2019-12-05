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

    func updateCustom(configurator: CustomTableCellConfigurator)

    func showError(_ text: String)
}
