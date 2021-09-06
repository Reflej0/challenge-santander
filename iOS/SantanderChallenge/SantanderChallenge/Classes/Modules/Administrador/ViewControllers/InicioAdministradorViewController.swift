//
//  InicioAdministradorViewController.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 29/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class InicioAdministradorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    
    // MARK: CONNECTIONS
    
    @IBOutlet weak var imageClima: UIImageView!
    @IBOutlet weak var labelLocalizacion: UILabel!
    @IBOutlet weak var labelFecha: UILabel!
    @IBOutlet weak var labelTemperatura: UILabel!
    @IBOutlet weak var labelTemperaturaValor: UILabel!
    @IBOutlet weak var labelCantidadBirras: UILabel!
    @IBOutlet weak var labelCantidadBirrasValor: UILabel!
    @IBOutlet weak var labelProximasMeet: UILabel!
    @IBOutlet weak var tableMeets: UITableView!
    @IBOutlet weak var indicatorSpinner: UIActivityIndicatorView!
    
    // MARK: SERVICES / AUX
    
    var locationService = LocationService()
    var climaService = ClimaService()
    var meetService = MeetService()
    var meetsArray : [MeetRealm]?
    var meetHoy : MeetRealm?
    var meetSeleccionada : MeetRealm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDelegates()
        self.getMeets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.initCurrentWeather()
        self.initDelegates()
        self.getMeets()
    }
    
    private func getMeets(){
        self.meetsArray = self.meetService.getMeets()
        self.tableMeets.reloadData()
    }
    
    private func initDelegates(){
        self.tableMeets.delegate = self
        self.tableMeets.dataSource = self
        self.locationService.locManager.delegate = self
    }
    
    private func initCurrentWeather(){
        let coordinates = self.locationService.getLocation()
        self.climaService.getByLatLon(lat: coordinates.0, lon: coordinates.1, completion: self.doCompletionGetClima)
    }
    
    private func doCompletionGetClima(clima: Clima){
        self.imageClima.image = UIImage(named: clima.icono)
        self.labelLocalizacion.text = clima.nombre
        self.labelFecha.text = clima.fecha
        self.labelTemperaturaValor.text = clima.temperatura.trunc(length: 4) + "ºc"
        self.indicatorSpinner.stopAnimating()
        self.logicaCantidadBirras(temperatura: clima.temperatura)
    }
    
    private func hayMeetHoy(meet: MeetRealm){
        let calendar = Calendar.current
        if calendar.isDateInToday(meet.fecha!){
            self.meetHoy = meet
        }
    }
    
    private func logicaCantidadBirras(temperatura: String){
        if(self.meetHoy != nil){
            let personasMeet = self.meetHoy!.usuarios.count
            let temperatura = Double(temperatura)!
            var cantidadCervezas : Double = 0.0
            if temperatura < 20.0{
                cantidadCervezas = 0.75 * Double(personasMeet)
            }
            else if temperatura >= 20.0 && temperatura <= 24.0{
                cantidadCervezas = 1 * Double(personasMeet)
            }
            else if temperatura > 24.0{
                cantidadCervezas = 2 * Double(personasMeet)
            }
            cantidadCervezas = (cantidadCervezas / 6.0).rounded(.up)
            self.labelCantidadBirrasValor.text = String(Int(cantidadCervezas))
            self.labelCantidadBirras.isHidden = false
            self.labelCantidadBirrasValor.isHidden = false
        }
    }
    
    // MARK: ACTIONS

    @IBAction func buttonNuevaMeetClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "segueNuevaMeet", sender: nil)
    }
    
    
    @IBAction func buttonExitClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Sesión", message: "Desea cerrar sesión?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cerrar sesión", style: UIAlertAction.Style.destructive, handler: { action in
                self.navigationController?.popViewController(animated: true)

            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: TABLE DELEGATES
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.meetsArray?.count ?? 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meet = self.meetsArray![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "meetCell") as? CustomTableViewCell
        cell!.setMeet(meet: meet)
        self.hayMeetHoy(meet: meet)
        return cell!
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.meetSeleccionada = self.meetsArray![indexPath.row]
        self.performSegue(withIdentifier: "segueVerMeetAdministrador", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueVerMeetAdministrador" {
            if let destinationVC = segue.destination as? VerMeetAdministradorViewController {
                destinationVC.meetSeleccionada = self.meetSeleccionada
            }
        }
    }
    
    //To save the first start of the application when the permissions are not given yet
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self.locationService.locManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            self.indicatorSpinner.startAnimating()
            self.initCurrentWeather()
        default:
            print("Not Location")
        }
    }
    
}
