//
//  ImageService.swift
//  UseCases
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common

public protocol ImageService: class
{
    func fetch(url: URL, to changeableImage: ChangeableImage)
}

extension ImageService
{
    public func fetch(url: URL?, to changeableImage: ChangeableImage) {
        if let url = url {
            fetch(url: url, to: changeableImage)
        }
    }

    public func deferredFetch(url: URL?, to changeableImage: ChangeableImage) {
        if let url = url {
            changeableImage.fetcher = { [weak self, weak changeableImage] in
                if let changeableImage = changeableImage {
                    self?.fetch(url: url, to: changeableImage)
                }
            }
        }
    }
}
