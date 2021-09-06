//
//  MeetManager.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 30/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import RealmSwift

extension DBManager {

    public func getMeets() -> Results<MeetRealm> {
        
        let results: Results<MeetRealm> = database.objects(MeetRealm.self)
        return results
    }
    
    public func getFuturesMeets() -> Results<MeetRealm>  {
        let date = Date()
        let meets = database.objects(MeetRealm.self)
            .filter("fecha >= %@", date)
            .sorted(byKeyPath: "fecha", ascending: true)
        return meets
    }
    
    public func updateMeet(object: MeetRealm, invitados: RealmSwift.List<UsuarioRealm>) {
        do {
          try database.write {
            object.setValue(invitados, forKey: "usuarios")
          }
        } catch {
          print("Unable to update object.")
        }
    }
}
