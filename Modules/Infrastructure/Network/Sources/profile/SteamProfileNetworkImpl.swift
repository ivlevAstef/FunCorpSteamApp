//
//  SteamProfileNetworkImpl.swift
//  Network
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Common
import Services

class SteamProfileNetworkImpl: SteamProfileNetwork
{
    private let session: NetworkSession

    init(session: NetworkSession) {
        self.session = session
    }

    func request(by steamId: SteamID, completion: @escaping (SteamProfileResult) -> Void) {
        session.requestOnUser(
            method: "GetPlayerSummaries",
            version: "0002",
            fields: ["steamids": "\(steamId)"],
            completion: { (result: Result<Response<Players>, NetworkError>) in
                completion(Self.map(result))
        })
    }

    private static func map(_ result: Result<Response<Players>, NetworkError>) -> SteamProfileResult {
        switch result {
        case .success(let response):
            guard let player = response.response.players.first else {
                return .failure(.incorrectResponse)
            }
            guard let steamId = SteamID(player.steamid) else {
                return .failure(.incorrectResponse)
            }

            return .success(map(player, steamId: steamId))
        case .failure(.cancelled):
            return .failure(.cancelled)
        case .failure(.notConnection), .failure(.timeout):
            return .failure(.notConnection)
        case .failure:
            return .failure(.incorrectResponse)
        }
    }

    private static func map(_ result: Player, steamId: SteamID) -> SteamProfile {
        let visibilityState: SteamProfile.VisibilityState

        if 3 != result.communityvisibilitystate {
            visibilityState = .private
        } else {
            let state: SteamProfile.State
            switch result.personastate {
            case 0: state = .offline
            case 1: state = .online
            case 2: state = .busy
            case 3: state = .away
            case 4: state = .snooze
            case 5: state = .lookingToTrade
            case 6: state = .lookingToPlay
            default: state = .offline
            }

            visibilityState = .open(SteamProfile.OpenData(
                state: state,
                realName: result.realname,
                timeCreated: result.timecreated?.unixTimeToDate
            ))
        }

        return SteamProfile(
            steamId: steamId,
            profileURL: URL(string: result.profileurl),
            nickName: result.personaname,
            avatarURL: URL(string: result.avatarfull),
            lastlogoff: result.lastlogoff.unixTimeToDate,
            visibilityState: visibilityState
        )
    }
}

// MARK: - data

private struct Players: Decodable {
    let players: [Player]
}

private struct Player: Decodable {
    let steamid: String

    // Public

    let personaname: String
    let profileurl: String

    /// 1 - private, 3 - public
    let communityvisibilitystate: Int
    /// 0 - Offline, 1 - Online, 2 - Busy, 3 - Away, 4 - Snooze, 5 - looking to trade, 6 - looking to play.
    /// Always 0 if communityvisibilitystate = 3 private
    let personastate: Int

    /// Have community profile or not. 1	- have
    let profilestate: Int
    /// unix time
    let lastlogoff: Int64

    /// 32x32
    let avatar: String
    /// 64x64
    let avatarmedium: String
    /// 184x184
    let avatarfull: String

    // Private

    /// unix time
    let timecreated: Int64?

    let realname: String?
    /// if user in game then have game id
    //let gameid: Any?

    //let gameextrainfo: Any?
}

//            "primaryclanid":"103582791429521408",
//            "timecreated":1350317088,
//            "personastateflags":0,

//            "loccountrycode":"RU",
//            "locstatecode":"53",
//            "loccityid":41723
