//
//  LogFileDestination.swift
//  Logger
//
//  Created by Alexander Ivlev on 25/02/2019.
//

import Foundation
import Common

final class LogFileDestination: LogDestination
{
    let format: String
    let limitOutputLevel: LogLevel

    private let fileHandler: FileHandle?

    init(format: String = "%Df [%s]: %m", limitOutputLevel: LogLevel = .info) {
        self.format = format
        self.limitOutputLevel = limitOutputLevel
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            self.fileHandler = nil
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let fileURL = documentsURL.appendingPathComponent("log_\(dateFormatter.string(from: Date())).log")

        if !FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil) {
            self.fileHandler = nil
            return
        }

        self.fileHandler = try? FileHandle(forWritingTo: fileURL)
    }

    deinit {
        self.fileHandler?.synchronizeFile()
        self.fileHandler?.closeFile()
    }

    func process(_ msg: String, level: LogLevel) {
        guard let fileHandler = self.fileHandler, let data = "\(msg)\n".data(using: .utf8) else {
            return
        }

        fileHandler.write(data)
    }

}
