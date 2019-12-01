//
//  SteamAuthNetworkImpl.swift
//  Network
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

final class SteamAuthNetworkImpl: SteamAuthNetwork
{
    private let appRedirectName = "funcorp.steam.app"

    var loginUrl: URL {
        var components = URLComponents(string: "https://steamcommunity.com/openid/login")!
        let items = [
            URLQueryItem(name: "openid.ns", value: "http://specs.openid.net/auth/2.0"),
            URLQueryItem(name: "openid.claimed_id", value: "http://specs.openid.net/auth/2.0/identifier_select"),
            URLQueryItem(name: "openid.identity", value: "http://specs.openid.net/auth/2.0/identifier_select"),
            URLQueryItem(name: "openid.return_to", value: "https://\(appRedirectName)"),
            URLQueryItem(name: "openid.mode", value: "checkid_setup")
        ]

        let allowedChars = CharacterSet(charactersIn: ":/").inverted
        components.percentEncodedQuery = items.map { item in
            item.name + "=" + (item.value?.addingPercentEncoding(withAllowedCharacters: allowedChars) ?? "")
        }.joined(separator: "&")

        guard let url = components.url else {
            log.fatal("Can't make steam open id url")
        }

        return url
    }

    func isRedirect(url: URL) -> Bool {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.host == appRedirectName
    }

    func parseRedirect(url: URL) -> SteamID? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        for queryItem in components.queryItems ?? [] {
            guard let value = queryItem.value else {
                continue
            }
            if queryItem.name != "openid.claimed_id" && queryItem.name != "openid.identity" {
                continue
            }
            guard let paramComponents = URLComponents(string: value) else {
                continue
            }
            if !paramComponents.path.hasPrefix("/openid/id/") {
                continue
            }

            let lastComponent = (paramComponents.path as NSString).lastPathComponent
            if let steamId = SteamID(lastComponent) {
                return steamId
            }
        }

        return nil
    }
}
