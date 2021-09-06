//
//  DBManager.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 29/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import RealmSwift

class DBManager {
    
    internal var database:Realm
    public static let sharedInstance = DBManager()
    
    private init() {
        
        database = try! Realm()
        
    }
    
    public func addData(object: Object) {
        
        try! database.write {
            database.add(object)
            print("Added new object")
        }
    }
    
    public func deleteAllDatabase()  {
        try! database.write {
            database.deleteAll()
        }
    }
    
    public func deleteFromDb(object: Object) {
        
        try! database.write {
            
            database.delete(object)
        }
    }
     
}


