//
//  SteamProfileData.swift
//  Storage
//
//  Created by Alexander Ivlev on 28/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import RealmSwift
import Entities
import UseCases

final class SteamProfileData: Object, LimitedUpdated {
    @objc dynamic var _steamId: String = ""
    @objc dynamic var _profileURL: String? = nil
    @objc dynamic var _nickName: String = ""
    @objc dynamic var _avatarURL: String? = nil
    @objc dynamic var _mediumAvatarURL: String? = nil
    @objc dynamic var _lastlogoff: Date? = nil


    @objc dynamic var _hasCommunityProfile: Bool = false
    @objc dynamic var _visibleState: Int = 0
    @objc dynamic var _state: Int = 0
    @objc dynamic var _realName: String? = nil
    @objc dynamic var _timeCreated: Date? = nil

    @objc dynamic var lastUpdateTime: Date = Date()

    override static func primaryKey() -> String? {
        return "_steamId"
    }
}

extension SteamProfileData {
    convenience init(profile: SteamProfile) {
        self.init()
        _steamId = "\(profile.steamId)"
        _profileURL = profile.profileURL?.absoluteString
        _nickName = profile.nickName
        _avatarURL = profile.avatarURL?.absoluteString
        _mediumAvatarURL = profile.mediumAvatarURL?.absoluteString
        _lastlogoff = profile.lastlogoff

        switch profile.visibilityState {
        case .private:
            _visibleState = 0
        case .open(let openData):
            _visibleState = 1
            switch openData.state {
            case .offline: _state = 0
            case .online: _state = 1
            case .busy: _state = 2
            case .away: _state = 3
            case .snooze: _state = 4
            case .lookingToTrade: _state = 5
            case .lookingToPlay: _state = 6
            }
            _realName = openData.realName
            _timeCreated = openData.timeCreated
        }
    }

    var profile: SteamProfile? {
        guard let steamId = SteamID(_steamId) else {
            return nil
        }

        let visibleState: SteamProfile.VisibilityState
        switch _visibleState {
        case 0:
            visibleState = .private
        case 1:
            let state: SteamProfile.State
            switch _state {
            case 0: state = .offline
            case 1: state = .online
            case 2: state = .busy
            case 3: state = .away
            case 4: state = .snooze
            case 5: state = .lookingToTrade
            case 6: state = .lookingToPlay
            default:
                return nil
            }

            visibleState = .open(SteamProfile.OpenData(
                state: state,
                realName: _realName,
                timeCreated: _timeCreated
            ))
        default:
            return nil
        }

        return SteamProfile(
            steamId: steamId,
            profileURL: _profileURL.flatMap{ URL(string: $0) },
            nickName: _nickName,
            avatarURL: _avatarURL.flatMap{ URL(string: $0) },
            mediumAvatarURL: _mediumAvatarURL.flatMap{ URL(string: $0) },
            lastlogoff: _lastlogoff,
            hasCommunityProfile: _hasCommunityProfile,
            visibilityState: visibleState
        )
    }
}
