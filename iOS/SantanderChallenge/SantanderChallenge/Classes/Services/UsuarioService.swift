//
//  UsuarioService.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 29/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import CryptoKit

class UsuarioService{
    
    public func login(usuario: String, contrasena: String, completion: @escaping (Int) -> Void){
        let usuarios = DBManager.sharedInstance.getUsuarios()
        for u in usuarios{
            if u.usuario == usuario && u.contrasena == contrasena.md5(){
                UserDefaults.standard.set(u.usuario, forKey: "usuarioActivoString")
                completion(u.rol)
                return
            }
        }
        completion(-1)
    }
    
    public func nuevoUsuario(usuario: String, contrasena: String, rol: Int, completion: @escaping () -> Void){
        let count = DBManager.sharedInstance.getUsuarios().count
        let usuarioR = UsuarioRealm()
        usuarioR.ID = count+1
        usuarioR.usuario = usuario
        usuarioR.contrasena = contrasena.md5()
        usuarioR.rol = rol
        DBManager.sharedInstance.addData(object: usuarioR)
        completion()
    }
    
    public func getUsuarios(completion: @escaping ([UsuarioRealm]) -> Void){
        let usuarios = Array(DBManager.sharedInstance.getUsuarios())
        completion(usuarios)
    }
    
    public func getUsuarioByName(name: String, completion: @escaping (UsuarioRealm?) -> Void){
        let usuario = DBManager.sharedInstance.getUsuarioByName(name: name)
        completion(usuario)
    }
}
