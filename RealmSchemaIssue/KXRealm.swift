//
//  KXRealm.swift
//  Guess5
//
//  Created by Aleksandar Trpeski on 9/8/15.
//  Copyright (c) 2015 AlGaChiEta. All rights reserved.
//

import Foundation
import RealmSwift

class KXRealm {
    
    let statsConfig: Realm.Configuration
    
    static let Manager = KXRealm()
    
    init() {
        
        let realmPath = NSURL(fileURLWithPath: Realm.Configuration.defaultConfiguration.path!).URLByDeletingLastPathComponent?.URLByAppendingPathComponent("WordStats.realm").path
        self.statsConfig = Realm.Configuration(path: realmPath, readOnly: false, objectTypes: [KXEntryStats.self])
        print(realmPath)
    }
    
    func getRandomEntry(language language: String, length: Int) -> (KXEntry?) {
        
        let statsRealm = try! Realm(configuration: self.statsConfig)
        let entriesRealm = self.entriesRealm(language: language, length: length)
        let primaryKeys = KXEntryStats.primaryKeys(statsRealm, language: language, length: length)
        let entry = KXEntry.newRandomEntry(entriesRealm, primaryKeys: primaryKeys)
        
        return entry
    }

    func finished(entry entry: KXEntry, passed: Bool, language: String, length: Int) {
        
        let statsRealm = try! Realm(configuration: self.statsConfig)
        let entryStats = KXEntryStats(word: entry, language: language, length: length, passed: passed)
        
        try! statsRealm.write {
        
            statsRealm.add(entryStats, update: false)
        }
    }
    
    //  MARK:   Private Methods
    
    private func entriesRealm(language language: String, length: Int) -> (Realm) {
        
        let identifier = "\(language)\(length).realm"
        let rootPath = NSBundle.mainBundle().resourcePath!
        let path = NSURL(fileURLWithPath: rootPath).URLByAppendingPathComponent("/Words/\(identifier)").path
        let config = Realm.Configuration(path: path, readOnly: true, objectTypes: [KXEntry.self])
        
        return try! Realm(configuration: config)
    }
}