//
//  Clima.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 29/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation

class Clima{
    var nombre : String
    var fecha : String
    var temperatura: String
    var icono: String
    
    public init (nombre: String, fecha: String, temperatura: String, icono: String){
        self.nombre = nombre
        self.fecha = fecha
        self.temperatura = temperatura
        self.icono = icono
    }
}
