//
//  AvatarServiceImpl.swift
//  ServicesImpl
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import UIKit
import Common
import Services

final class AvatarServiceImpl: AvatarService
{
    func fetch(url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .default).async {
            var avatar: UIImage?
            if let avatarData = try? Data(contentsOf: url) {
                avatar = UIImage(data: avatarData)
            }

            DispatchQueue.main.async {
                completion(avatar)
            }
        }
    }

    func fetch(url: URL, to changeableImage: ChangeableImage) {
        fetch(url: url, completion: { image in
            changeableImage.updateImage(image: image)
        })
    }
}
