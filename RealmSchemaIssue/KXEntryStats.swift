//
//  KXEntryStats.swift
//  RealmBuilder
//
//  Created by Aleksandar Trpeski on 9/7/15.
//  Copyright (c) 2015 Pristap. All rights reserved.
//

import Foundation
import RealmSwift

class KXEntryStats: Object {
    
    dynamic var index = ""

    dynamic var language = ""
    dynamic var length = 0
    dynamic var passed = false
    dynamic var timestamp = NSDate()
    
    override class func primaryKey() -> (String) {
        
        return "index"
    }
    
    override static func indexedProperties() -> [String] {
        
        return ["language", "length"]
    }
    
    convenience init(word: KXEntry, language: String, length: Int, passed: Bool) {
        
        
        self.init()
        
        self.index = word.index
        self.passed = passed
        self.language = language
        self.length = length
        self.timestamp = NSDate()
    }
    
    class func primaryKeys(realm: Realm, language: String, length: Int) -> ([String]) {
        
        let predicate = NSPredicate(format: "language = %@ AND length = %d", language, length)
        let primaryKeys = realm.objects(self).filter(predicate).valueForKey("index") as! [String]
        return primaryKeys
    }
}