//
//  CustomGameInfoViewContract.swift
//  GameInformation
//
//  Created by Alexander Ivlev on 01/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

protocol CustomGameInfoViewContract: class
{
    func addCustomSection(title: String?, style: CustomViewModelStyle, order: UInt)
    func removeCustomSection(order: UInt)

    func beginCustomLoading(style: CustomViewModelStyle, order: UInt)
    func failedCustomLoading(style: CustomViewModelStyle, order: UInt)

    func showCustom(_ viewModel: CustomViewModel, order: UInt)

    func showError(_ text: String)
}
