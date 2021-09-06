//
//  MeetService.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 29/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class MeetService{
    
    public func getMeets() -> [MeetRealm]{
        let meets = DBManager.sharedInstance.getFuturesMeets()
        return Array(meets)
    }
    
    public func newMeet(nombre: String, descripcion: String, fecha: Date, invitados: [UsuarioRealm], completion: @escaping () -> Void){
        let count = DBManager.sharedInstance.getMeets().count
        let meet = MeetRealm()
        meet.ID = count+1
        meet.nombre = nombre
        meet.descripcion = descripcion
        meet.fecha = fecha
        meet.usuarios.append(objectsIn: invitados)
        DBManager.sharedInstance.addData(object: meet)
        completion()
    }
    
    public func updateMeet(meet: MeetRealm, usuarioNuevo: UsuarioRealm){
        var invitadosArray = Array(meet.usuarios)
        invitadosArray.append(usuarioNuevo)
        let invitadosList = RealmSwift.List<UsuarioRealm>()
        invitadosList.append(objectsIn: invitadosArray)
        DBManager.sharedInstance.updateMeet(object: meet, invitados: invitadosList)
    }
}
