//
//  SkeletonViewModel.swift
//  UIComponents
//
//  Created by Alexander Ivlev on 26/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//


public enum SkeletonViewModel<ViewModel>
{
    case loading
    case done(ViewModel)
    case failed
}
