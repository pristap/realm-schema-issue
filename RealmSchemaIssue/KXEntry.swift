//
//  KXEntry.swift
//  RealmBuilder
//
//  Created by Aleksandar Trpeski on 8/31/15.
//  Copyright (c) 2015 Pristap. All rights reserved.
//

import Foundation
import RealmSwift

class KXEntry: Object {
    
    dynamic var index = ""
    dynamic var wordCombinations = ""
    dynamic var gamesLost = 0
    dynamic var gamesWon = 0
    
    var words: [String] {
        
        return self.wordCombinations.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "."))
    }
    
    override class func primaryKey() -> (String) {
        
        return "index"
    }
    
//    override static func indexedProperties() -> [String] {
//        return ["language", "length"]
//    }
    
    convenience init(language: String, combinations: String, gamesWon: Int, gamesLost: Int) {
        
        self.init()
        
        self.wordCombinations = combinations
        self.gamesLost = gamesLost
        self.gamesWon = gamesWon
        self.index = KXEntry.generateKey(language, word: words.first!)
    }

//    required init() {
//        
//        super.init()
//    }
    
    class func generateKey(language: String, word: String) -> (String) {
        
        return "\(language)-\(String(String(word.characters.sort())).uppercaseString)"
    }
    
    class func newRandomEntry(realm: Realm, primaryKeys: [String]) -> (KXEntry?) {
        
        let predicate = NSPredicate(format: "NOT (index IN %@)", primaryKeys)
        let results = realm.objects(self).filter(predicate)
        print(primaryKeys.debugDescription, terminator: "")
        
        if results.count > 0 {
            
            let randomIndex = arc4random_uniform(UInt32(results.count))
            return results[Int(randomIndex)] as KXEntry
        }
        else { return nil }
    }
}