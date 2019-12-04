//
//  SteamDotaService.swift
//  Services
//
//  Created by Alexander Ivlev on 24/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

/// Позволяет получить более подробную информацию о Dota 2
public protocol SteamDotaService: class
{
    /// Возвращает идентификатор игры "Dota 2"
    var gameId: SteamGameID { get }

    /// Возвращает сколько игр было сыграно за последние две недели
    func matchesInLast2weeks(for accountId: AccountID, completion: @escaping (SteamDotaCompletion<Int>) -> Void)

    /// Возвращает информацию по последней сыгранной игре. nil если игр нет
    func lastMatch(for accountId: AccountID, completion: @escaping (SteamDotaCompletion<DotaMatchDetails?>) -> Void)

    /// Возвращает детализацию за последние две недели
    func detailsInLast2weeks(for accountId: AccountID, completion: @escaping (SteamDotaCompletion<[DotaMatchDetails]>) -> Void)

    /// Возвращает описание героя. nil если по запрашиваему id героя нет
    func getHero(for heroId: DotaHeroID, loc: SteamLocalization, completion: @escaping (SteamDotaCompletion<DotaHero?>) -> Void)

    /// Возвращает популярного героя, за последние 100 игр, или за две недели (в зависимости от того каких данных больше).
    func popularHero(for accountId: AccountID, completion: @escaping (SteamDotaCompletion<DotaPopularHero>) -> Void)
}
