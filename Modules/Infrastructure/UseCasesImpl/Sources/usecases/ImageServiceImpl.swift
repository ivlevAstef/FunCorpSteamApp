//
//  ImageServiceImpl.swift
//  UseCasesImpl
//
//  Created by Alexander Ivlev on 23/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import UIKit
import Common
import UseCases

final class ImageServiceImpl: ImageService
{
    private let imageCache = ImageCache.shared

    func fetch(url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .default).async { [imageCache] in
            var avatar: UIImage? = imageCache.fetch(url: url)
            if nil == avatar, let avatarData = try? Data(contentsOf: url) {
                avatar = UIImage(data: avatarData)

                if let avatar = avatar {
                    imageCache.put(image: avatar, url: url)
                }
            }

            DispatchQueue.main.async {
                completion(avatar)
            }
        }
    }

    func fetch(url: URL, to changeableImage: ChangeableImage) {
        fetch(url: url, completion: { image in
            changeableImage.updateImage(image)
        })
    }
}

private class ImageCache
{
    fileprivate static let shared: ImageCache = ImageCache()
    private let folderPath: String? = {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    }()

    func put(image: UIImage, url: URL) {
        guard let fileUrl = folderFileURL(netUrl: url) else {
            return
        }

        guard let data = image.pngData() else {
            return
        }

        do {
            try data.write(to: fileUrl, options: .atomic)
        } catch {
            log.warning("Can't write image cache to file: \(fileUrl.absoluteString) error: \(error)")
        }
    }

    func fetch(url: URL) -> UIImage? {
        guard let fileUrl = folderFileURL(netUrl: url) else {
            return nil
        }

        guard let data = try? Data(contentsOf: fileUrl) else {
            return nil
        }

        return UIImage(data: data)
    }

    private func folderFileURL(netUrl: URL) -> URL? {
        guard let folderPath = folderPath else {
            return nil
        }

        let name = urlToName(url: netUrl)
        return URL(fileURLWithPath: folderPath + "/" + name + ".png")
    }

    private func urlToName(url: URL) -> String {
        let invalidCharacters = CharacterSet.alphanumerics.union(CharacterSet.letters).inverted
        return url.absoluteString.components(separatedBy: invalidCharacters).joined()
    }
}
