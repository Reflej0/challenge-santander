//
//  UsuarioManager.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 30/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import RealmSwift

extension DBManager {

    public func getUsuarios() -> Results<UsuarioRealm> {
        
        let results: Results<UsuarioRealm> = database.objects(UsuarioRealm.self)
        return results
    }

    public func getUsuarioByName(name: String) -> UsuarioRealm?{
        let usuario = database.objects(UsuarioRealm.self)
        .filter("usuario == %@", name)
        if usuario.count == 0{
            return nil
        }
        return usuario[0]
    }

}
