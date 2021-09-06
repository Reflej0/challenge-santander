//
//  UsuarioRealm.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 29/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class UsuarioRealm: Object {
    
    @objc dynamic var ID = 0
    @objc dynamic var usuario : String = ""
    @objc dynamic var contrasena : String = ""
    @objc dynamic var rol : Int = 0
    
    override static func primaryKey() -> String? {
        return "ID"
    }
}
