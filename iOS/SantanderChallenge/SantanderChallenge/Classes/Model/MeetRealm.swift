//
//  Meet.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 29/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class MeetRealm: Object {
    
    @objc dynamic var ID = 0
    @objc dynamic var nombre : String = ""
    @objc dynamic var descripcion : String = ""
    @objc dynamic var fecha : Date?
    dynamic var usuarios = RealmSwift.List<UsuarioRealm>()
    
    override static func primaryKey() -> String? {
        return "ID"
    }
}

