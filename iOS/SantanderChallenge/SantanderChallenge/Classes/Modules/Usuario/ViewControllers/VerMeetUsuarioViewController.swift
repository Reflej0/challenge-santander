//
//  VerMeetUsuarioViewController.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 29/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import UIKit

class VerMeetUsuarioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var labelNombre: UILabel!
    @IBOutlet weak var labelDescripcion: UILabel!
    @IBOutlet weak var labelFecha: UILabel!
    @IBOutlet weak var labelInvitados: UILabel!
    @IBOutlet weak var textNombre: UITextField!
    @IBOutlet weak var textDescripcion: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableInvitado: UITableView!
    @IBOutlet weak var buttonAsistir: UIBarButtonItem!
    
    var usuarioService = UsuarioService()
    var meetService = MeetService()
    var meetSeleccionada : MeetRealm?
    var invitados : [UsuarioRealm] = []
    var usuarioActivo : UsuarioRealm?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initInterface()
        self.initDelegates()
    }
    
    private func initDelegates(){
        self.tableInvitado.delegate = self
        self.tableInvitado.dataSource = self
        self.elUsuarioYaEstaEnLaMeet()
    }
    
    private func elUsuarioYaEstaEnLaMeet(){
        let usuarioActivoString = UserDefaults.standard.string(forKey: "usuarioActivoString")!
        self.usuarioService.getUsuarioByName(name: usuarioActivoString, completion: self.doCompletion)
    }
    
    private func doCompletion(usuario: UsuarioRealm?){
        if self.meetSeleccionada!.usuarios.contains(usuario!){
            self.buttonAsistir.title = "Ya asistis"
            self.buttonAsistir.isEnabled = false
        }
        else{
            self.usuarioActivo = usuario
        }
    }
    
    private func initInterface(){
        self.textDescripcion.layer.borderColor = UIColor.gray.cgColor
        self.textDescripcion.layer.borderWidth = 1.0
        self.textDescripcion.layer.cornerRadius = 5
        self.tableInvitado.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.textNombre.text = self.meetSeleccionada!.nombre
        self.textDescripcion.text = self.meetSeleccionada!.descripcion
        self.datePicker.setDate(self.meetSeleccionada!.fecha!, animated: true)
        self.invitados = Array(self.meetSeleccionada!.usuarios)
        self.tableInvitado.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.invitados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "invitadoCell")
        cell.textLabel?.text  = self.invitados[indexPath.row].usuario

        cell.imageView!.image = UIImage(systemName:"person")
        return cell
    }
    
    @IBAction func buttonAsistirClicked(_ sender: Any) {
        self.meetService.updateMeet(meet: self.meetSeleccionada!, usuarioNuevo: self.usuarioActivo!)
        self.invitados.append(self.usuarioActivo!)
        self.tableInvitado.reloadData()
        self.buttonAsistir.title = "Ya asistis"
        self.buttonAsistir.isEnabled = false
    }
    
    
}
