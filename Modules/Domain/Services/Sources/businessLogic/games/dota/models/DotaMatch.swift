//
//  DotaMatch.swift
//  Services
//
//  Created by Alexander Ivlev on 02/12/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

import Foundation

public typealias DotaMatchID = UInt64

public typealias DotaMatchHistoryResult = Result<[DotaMatch], ServiceError>

public struct DotaMatch
{
    public struct Player {
        /// Иногда он не приходит, а иногда приходит равным UInt32.max... для простоты все к UInt32.max свожу
        public let accountId: AccountID
        public let heroId: DotaHeroID
        public let side: DotaSide

        private init() { fatalError("Not support empty initialization") }
    }

    public let matchId: DotaMatchID
    public let startTime: Date
    public let seqNumber: Int64
    public let lobby: DotaLobby?
    public let players: [Player]

    private init() { fatalError("Not support empty initialization") }
}

extension DotaMatch
{
    public init(
        matchId: DotaMatchID,
        startTime: Date,
        seqNumber: Int64,
        lobby: DotaLobby?,
        players: [Player]
    ) {
        self.matchId = matchId
        self.startTime = startTime
        self.seqNumber = seqNumber
        self.lobby = lobby
        self.players = players
    }
}

extension DotaMatch.Player
{
    public init(
        accountId: AccountID,
        heroId: DotaHeroID,
        side: DotaSide
    ) {
        self.accountId = accountId
        self.heroId = heroId
        self.side = side
    }
}
