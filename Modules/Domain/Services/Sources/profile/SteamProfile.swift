//
//  SteamProfile.swift
//  Services
//
//  Created by Alexander Ivlev on 22/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public typealias SteamProfileResult = Result<SteamProfile, SteamProfileError>

public enum SteamProfileError: Error {
    case notFound
    case notConnection
    case incorrectResponse
    case cancelled
}


public struct SteamProfile: Equatable
{
    public enum State: Equatable {
        case offline
        case online
        case busy
        case away
        case snooze
        case lookingToTrade
        case lookingToPlay
    }

    public struct OpenData: Equatable {
        public let state: State
        public let realName: String?
        /// Когда был создан аккаунт
        public let timeCreated: Date?

        private init() { fatalError("Not support empty initialization") }
    }

    /// Профиль пользователя может быть открыт или скрыт. В открытом состоянии доступно больше информации
    public enum VisibilityState: Equatable {
        case `private`
        case `open`(OpenData)
    }

    public let steamId: SteamID
    public let profileURL: URL?

    public let nickName: String
    public let avatarURL: URL?
    /// Когда пользователь был последний раз онлайн
    public let lastlogoff: Date

    public let visibilityState: VisibilityState

    private init() { fatalError("Not support empty initialization") }
}

extension SteamProfile {
    public init(
        steamId: SteamID,
        profileURL: URL?,
        nickName: String,
        avatarURL: URL?,
        lastlogoff: Date,
        visibilityState: VisibilityState
    ) {
        self.steamId = steamId
        self.profileURL = profileURL
        self.nickName = nickName
        self.avatarURL = avatarURL
        self.lastlogoff = lastlogoff
        self.visibilityState = visibilityState
    }
}

extension SteamProfile.OpenData {
    public init(
        state: SteamProfile.State,
        realName: String?,
        timeCreated: Date?
    ) {
        self.state = state
        self.realName = realName
        self.timeCreated = timeCreated
    }
}
