//
//  ClimaService.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 29/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ClimaService{
    let ENDPOINT = "https://api.openweathermap.org/data/2.5/"
    let API_KEY = "ea3dd3f72755d09e509dff542c200869"
    
    public func getByLatLon(lat: String, lon: String, completion: @escaping (Clima) -> Void){
        let url = "\(ENDPOINT)weather?lat=\(lat)&lon=\(lon)&appid=\(API_KEY)&units=metric&lang=es"
        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(encodedURL!, method: .get).responseJSON {
          response in
            guard let data = response.value else {return }
            if response.response!.statusCode == 200 {
                let jsonData = JSON(data)
                let nombre = jsonData["name"].stringValue
                let icono = jsonData["weather"][0]["icon"].stringValue
                let temperatura = jsonData["main"]["temp"].stringValue
                let fecha = Utils.now()
                let response = Clima(nombre: nombre, fecha: fecha, temperatura: temperatura, icono: icono)
                completion(response)
            }
        }
    }
}
