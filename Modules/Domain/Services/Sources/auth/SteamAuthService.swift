//
//  SteamAuthService.swift
//  Services
//
//  Created by Alexander Ivlev on 20/11/2019.
//  Copyright © 2019 ApostleLife. All rights reserved.
//

/// Протокол содержащий бизнес логику авторизации через стим.
public protocol SteamAuthService: class
{
    /// Залогинен ли пользователь
    var isLogined: Bool { get }
    /// Уникальный id пользователя. Пустое только если пользователь не залогинен
    var steamId: SteamID? { get }
    /// Уникальный id пользователя - используется в играх. Пустое только если пользователь не залогинен
    var accountId: AccountID? { get }

    /// Позволяет начать процесс авторизации в стим.
    /// - Parameter completion: Результат авторизации. В случае успеха вернется SteamID
    func login(completion: @escaping (Result<SteamID, SteamLoginError>) -> Void)
    /// Позволяет разлогинится из steam.
    /// - Parameter completion: оповещает об завершении выхода.  В случае успеха вернет SteamID с которого был произведен выход
    func logout(completion: @escaping (Result<SteamID, SteamLogoutError>) -> Void)
}
