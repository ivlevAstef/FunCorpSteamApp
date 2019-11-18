//
//  Logger.swift
//  Logger
//
//  Created by Alexander Ivlev on 22/02/2019.
//

import Foundation

/// Базовый экземпляр логгера
public let log = Logger.global

/// Класс предназначенный для логирования. Использовать через глобальную переменную `log`
public class Logger
{
    public static let global: Logger = Logger()

    private var destinations: [LogDestination] = []
    private var queue = Queue()

    /// Добавляет поток вывода информации. То есть в переданный объект будут приходить готовые сообщения от логгера.
    ///
    /// - Parameter destination: обработчик готовых сообщений от логера
    public func addDestination(_ destination: LogDestination) {
        destinations.append(destination)
    }

    /// Удаляет поток вывода информации.
    ///
    /// - Parameter destination: обработчик готовых сообщений от логера
    public func removeDestination(_ destination: LogDestination) {
        destinations.removeAll { $0 === destination }
    }

    /// Основная универсальная функция логирования. Все остальные функции вызывают её.
    /// Так как сообщение сделано на `autoclosure` надо быть аккуратней и использовать в сообщениях только не изменяемые поля.
    /// Причина этого в том, что сам closure может вычислиться намного позже чем вызов функции.
    ///
    /// - Parameters:
    ///   - level: Уровень логирования. Для большей информации см. `LogLevel`
    ///   - msgClosure: сообщение которое будет выведено. Сделано `autoclosure` для более быстрого исполнения.
    ///   - path: путь до файла - генерируется автоматически
    ///   - line: строчка кода в файле - генерируется автоматически
    ///   - fun: название функции в файле - генерируется автоматически
    public func other(_ level: LogLevel, _ msgClosure: @escaping @autoclosure () -> String, path: StaticString = #file, line: UInt = #line, fun: StaticString = #function) {
        let messageFormatter = MessageFormatter(level: level, path: path, line: line, fun: fun, date: Date())
        queue.addProcess {
            var msg: String?
            for destination in self.destinations {
                if destination.limitOutputLevel.priority < level.priority {
                    continue
                }

                let message = msg ?? msgClosure()
                msg = message
                let formattedMsg = messageFormatter.formatMessage(format: destination.format, msg: message)
                destination.process(formattedMsg, level: level)
            }
        }
    }

    /// Функция которая ожидает завершения всех выводов логирования
    /// Имеет побочный эффект - если в лог будут писаться бесконечно сообщения, то функция никогда не закончит исполнение
    /// Функция предназначена в первую очередь для дозаписи всех сообщение перед уничтожение приложения в случае краша
    public func waitUntilAllOperationsAreFinished() {
        self.queue.syncExecuteAllProcess()
    }
}


/// Класс для форматирования сообщения согласно некоторому формату
private class MessageFormatter
{
    private static let debugFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss.SSS"
        return formatter
    }()
    private static let nanoFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
    private static let anyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
    private static let fileFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm:ss"
        return formatter
    }()

    private let level: LogLevel
    private let path: StaticString
    private let line: UInt
    private let fun: StaticString
    private let date: Date

    private lazy var file: String = {
        return ("\(path)" as NSString).lastPathComponent
    }()

    internal init(level: LogLevel, path: StaticString, line: UInt, fun: StaticString, date: Date) {
        self.level = level
        self.path = path
        self.line = line
        self.fun = fun
        self.date = date
    }

    internal func formatMessage(format: String, msg: String) -> String {
        var result = format
        // В принципе это можно серьезно ускорить, но зачем? - всеравно не в главном потоке
        replaceIfNeed(in: &result, find: "%Dd", on: MessageFormatter.debugFormatter.string(from: self.date))
        replaceIfNeed(in: &result, find: "%Dn", on: MessageFormatter.nanoFormatter.string(from: self.date))
        replaceIfNeed(in: &result, find: "%Da", on: MessageFormatter.anyFormatter.string(from: self.date))
        replaceIfNeed(in: &result, find: "%Df", on: MessageFormatter.fileFormatter.string(from: self.date))
        replaceIfNeed(in: &result, find: "%s", on: "\(self.level.shortName)")
        replaceIfNeed(in: &result, find: "%L", on: "\(self.level.name)")
        replaceIfNeed(in: &result, find: "%e", on: "\(self.level.emoji)")
        replaceIfNeed(in: &result, find: "%F", on: self.file)
        replaceIfNeed(in: &result, find: "%l", on: "\(self.line)")
        replaceIfNeed(in: &result, find: "%M", on: "\(self.fun)")
        replaceIfNeed(in: &result, find: "%m", on: msg)

        return result
    }

    private func replaceIfNeed(in text: inout String, find: String, on substringClosure: @autoclosure () -> String) {
        var substring: String?
        while let range = text.range(of: find) {
            let subtext = substring ?? substringClosure()
            substring = subtext
            text.replaceSubrange(range, with: subtext)
        }
    }

}

extension LogLevel
{
    internal var name: String {
        switch self {
        case .fatal: return "FATAL"
        case .assert: return "ASSERT"
        case .error: return "ERROR"
        case .warning: return "WARNING"
        case .info: return "INFO"
        case .debug: return "DEBUG"
        case .trace: return "TRACE"
        case .none: return ""
        }
    }

    internal var shortName: String {
        switch self {
        case .fatal: return "FTL"
        case .assert: return "AST"
        case .error: return "ERR"
        case .warning: return "WRG"
        case .info: return "INF"
        case .debug: return "DBG"
        case .trace: return "TRC"
        case .none: return ""
        }
    }

    internal var emoji: String {
        switch self {
        case .fatal: return "🛑"
        case .assert: return "⁉️"
        case .error: return "❗️"
        case .warning: return "⚠️"
        case .info: return "🔹"
        case .debug: return "▶️"
        case .trace: return "🗯"
        case .none: return ""
        }
    }
}

// Некоторая замена DispatchQueue но сделанная специально под логгер.
// Добавление элементов в очередь быстрее на 2 порядка!
// Исполнение очереди быстрее в 2-3 раза
// среднее время на добавление элемента: 286 * 10^-9 = 0.000000286 секунды или по другому за секунду около 3500000 добавлений
private class Queue: NSObject
{
    private class Element {
        internal let process: () -> Void
        internal var next: Element? = nil

        internal init(process: @escaping () -> Void) {
            self.process = process
        }
    }

    private var head: Element?
    private var tail: Element?

    private let operationLocker = FastLock()
    private let syncCounter = DispatchSemaphore(value: 0)
    private lazy var thread = Thread(target: self, selector: #selector(executor), object: nil)

    // Переменная чтобы можно было дождаться завершения исполнения всех операций
    private var waitingForSynchronization: [DispatchSemaphore] = []

    internal override init() {
        super.init()
        self.thread.name = "LoggerQueue"
        self.thread.start()
    }

    deinit {
        syncExecuteAllProcess()
    }

    internal func addProcess(_ process: @escaping () -> Void) {
        let newElement = Element(process: process)
        // На самом деле тут есть некоторая проблема - если у нас будет слишком много вызов этой функции, то есть шанс,
        // что порядок логов перемешается - так как у любого лока нет гарантии, что первый подошел первый и зашел
        // Эту проблему можно избежать сделав атомарный счетчик, у каждого узла хранить номер, и при исполнении не перескакивать
        // Но это серьезно усложнит решение, и пока можно забить - эта проблема возникнет ток при большом количестве логов.
        // Тем более на тесте в 50к элементов в цикле порядок не ломается
        operationLocker.lock()
        if let tail = self.tail {
            tail.next = newElement
            self.tail = newElement
        } else {
            self.head = newElement
            self.tail = newElement
        }
        operationLocker.unlock()
        syncCounter.signal()
    }

    internal func syncExecuteAllProcess() {
        // Не частая операция - в идеале вызывается только перед крашем.
        operationLocker.lock()
        // Дабы не уйти в бесконечное ожидание если операций нет
        var waiter: DispatchSemaphore? = nil
        if head != nil {
            // Это жеское потребление ресурсов - но скорей всего больше одного никогда не будет, ктомуже мы всеравно падаем :)
            let newWaiter = DispatchSemaphore(value: 0)
            waiter = newWaiter
            waitingForSynchronization.append(newWaiter)
        }
        operationLocker.unlock()

        waiter?.wait()
    }

    @objc
    private func executor() {
        while !thread.isCancelled {
            syncCounter.wait()

            operationLocker.lock()
            let element = head
            head = head?.next

            var waitingForSynchronization: [DispatchSemaphore] = []
            if head == nil {
                waitingForSynchronization = self.waitingForSynchronization
                tail = nil
            }
            operationLocker.unlock()

            if let element = element {
                element.process()

                // Если кто-то ждет завершения всех операций, то оповестим что это произошло.
                waitingForSynchronization.forEach { $0.signal() }
                continue
            }
        }
    }

}
