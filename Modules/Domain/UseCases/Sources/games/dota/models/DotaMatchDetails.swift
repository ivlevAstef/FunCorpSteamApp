//
//  DotaMatchDetails.swift
//  UseCases
//
//  Created by Alexander Ivlev on 02/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation
import Entities

public typealias DotaMatchDetailsResult = Result<DotaMatchDetails, ServiceError>

public struct DotaMatchDetails
{
    public struct Player {
        /// Иногда он не приходит, а иногда приходит равным UInt32.max... для простоты все к UInt32.max свожу
        public let accountId: AccountID
        public let heroId: DotaHeroID
        public let side: DotaSide
        /// 9 elements - [0-5] items, [6-8] backpack
        public let items: [DotaItemID]

        public let kills: UInt
        public let deaths: UInt
        public let assists: UInt
        public let lastHits: UInt
        public let denies: UInt
        /// gold per minute
        public let gpm: UInt
        /// xp per minute
        public let xpm: UInt

        public let level: UInt

        // And other

        private init() { fatalError("Not support empty initialization") }
    }

    public let matchId: DotaMatchID
    public let startTime: Date
    public let seqNumber: Int64
    public let winSide: DotaSide
    public let duration: TimeInterval
    public let lobby: DotaLobby?
    public let players: [Player]

    // And other

    private init() { fatalError("Not support empty initialization") }
}

extension DotaMatchDetails
{
    public init(
        matchId: DotaMatchID,
        startTime: Date,
        seqNumber: Int64,
        winSide: DotaSide,
        duration: TimeInterval,
        lobby: DotaLobby?,
        players: [Player]
    ) {
        self.matchId = matchId
        self.startTime = startTime
        self.seqNumber = seqNumber
        self.winSide = winSide
        self.duration = duration
        self.lobby = lobby
        self.players = players
    }
}

extension DotaMatchDetails.Player
{
    public init(
        accountId: AccountID,
        heroId: DotaHeroID,
        side: DotaSide,
        items: [DotaItemID],
        kills: UInt,
        deaths: UInt,
        assists: UInt,
        lastHits: UInt,
        denies: UInt,
        gpm: UInt,
        xpm: UInt,
        level: UInt
    ) {
        self.accountId = accountId
        self.heroId = heroId
        self.side = side
        self.items = items
        self.kills = kills
        self.deaths = deaths
        self.assists = assists
        self.lastHits = lastHits
        self.denies = denies
        self.gpm = gpm
        self.xpm = xpm
        self.level = level
    }
}
