//
//  NetworkSession.swift
//  Network
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Entities

private enum Consts
{
    static let apiBaseURL = URL(string: "https://api.steampowered.com")!
    static let apiMediaURL = URL(string: "http://media.steampowered.com")!
    static let key = "4A90F8A38B026CAF2588190E5DBBCF04"
    static let format = "json"
}

enum NetworkError: Error {
    case unknown

    case incorrectURL

    case cancelled
    case badResponse
    case timeout
    case notConnection
    case custom(Error)

    case failureParse
}

enum Support {
    static func gameImageUrl(gameId: SteamGameID, hash: String) -> URL? {
        var urlString = Consts.apiMediaURL.absoluteString
        urlString += "/steamcommunity/public/images/apps"
        urlString += "/\(gameId)"
        urlString += "/\(hash)"
        urlString += ".jpg"
        return URL(string: urlString)
    }
}

final class NetworkSession {
    private let session: URLSession = URLSession.shared

    func request<Success: Decodable>(_ request: Request<Success>, useJson: Bool = false) {
        guard let url = makeURL(request: request, useJson: useJson) else {
            log.error("can't start request by method: \(request.method) on interface: \(request.interface)")
            request.completion(.failure(.incorrectURL))
            return
        }

        log.debug("start request on url: \(url.absoluteString)")
        let task = session.dataTask(with: url) { (data, response, error) in
            log.debug("receive response on url: \(url.absoluteString)")
            request.completion(Self.parseResult(data: data, response: response, error: error))
        }
        task.resume()
    }

    private func makeURL(request: RequestInfo, useJson: Bool = false) -> URL? {
        var urlString = Consts.apiBaseURL.absoluteString
        urlString += "/" + request.interface
        urlString += "/" + request.method
        urlString += "/v\(request.version)"
        urlString += "/?key=" + Consts.key
        urlString += "&format=" + Consts.format
        if useJson {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: request.fields, options: []) else {
                log.assert("can't generate json data for fields")
                return nil
            }
            guard let json = String(data: jsonData, encoding: .utf8) else {
                log.assert("can't generate json data for fields")
                return nil
            }

            let encodingJson = json.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? json

            urlString += "&input_json=" + encodingJson
        } else {
            for field in request.fields {
                urlString += "&\(field.key)=\(field.value)"
            }
        }

        guard let url = URL(string: urlString) else {
            log.assert("can't generate url: \(urlString)")
            return nil
        }

        return url
    }

    private static func parseResult<Success: Decodable>(
        data: Data?,
        response: URLResponse?,
        error: Error?) -> Result<Success, NetworkError> {

        guard let data = data else {
            log.info("Failure response")
            if let error = error as NSError? {
                log.info("Failure response with error: \(error)")
                if error.code == NSURLErrorCancelled {
                    return .failure(.cancelled)
                }
                if error.code == NSURLErrorTimedOut {
                    return .failure(.timeout)
                }
                if error.code == NSURLErrorBadServerResponse {
                    return .failure(.badResponse)
                }
                if error.code == NSURLErrorNotConnectedToInternet
                || error.code == NSURLErrorNetworkConnectionLost
                || error.code == NSURLErrorCannotFindHost
                || error.code == NSURLErrorCannotConnectToHost {
                    return .failure(.notConnection)
                }

                return .failure(.custom(error))
            }
            log.warning("Failure response with unknown error")
            return .failure(.unknown)
        }

        log.trace("Response data: \(String(describing: String(data: data, encoding: .utf8)))")
        do {
            let object = try JSONDecoder().decode(Success.self, from: data)
            return .success(object)
        } catch {
            log.warning("Failure parse data: \(error)")
            return .failure(.failureParse)
        }
    }
}
