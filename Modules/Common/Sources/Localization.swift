//
//  Localization.swift
//  Common
//
//  Created by Alexander Ivlev on 28/10/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public let loc = Localization()

/// Простецкая локализация
public final class Localization
{
    private let notFound = "!@#can_not_found_key!@#"

    public subscript(_ key: String) -> String {
        let result = NSLocalizedString(key, value: notFound, comment: key)
        if result == notFound {
            log.assert("can't found localization for key: \(key)")
            return key
        }

        return result
    }

    public var languageCode: String {
        return Locale.current.languageCode ?? "en"
    }
}
