//
//  File.swift
//  
//
//  Created by Alexander Ivlev on 29/11/2019.
//

import Foundation
import RealmSwift
import Common

extension Realm {
    var ts: Realm? { threadSafe }

    var threadSafe: Realm? {
        if Thread.isMainThread {
            return self
        }

        guard let realm = try? Realm(configuration: self.configuration) else {
            log.assert("Can't make realm for thread safe")
            return nil
        }
        return realm
    }

    func threadSafeWrite(_ closure: (_ realm: Realm) -> Void) {
        guard let realm = self.threadSafe else {
            return
        }
        try? realm.write {
            closure(realm)
        }
    }
}
