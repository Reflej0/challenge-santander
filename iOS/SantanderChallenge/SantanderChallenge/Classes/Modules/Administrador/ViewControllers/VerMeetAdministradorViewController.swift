//
//  VerMeetAdministradorViewController.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 29/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import UIKit

class VerMeetAdministradorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var labelNombre: UILabel!
    @IBOutlet weak var labelDescripcion: UILabel!
    @IBOutlet weak var labelFecha: UILabel!
    @IBOutlet weak var labelInvitados: UILabel!
    @IBOutlet weak var textNombre: UITextField!
    @IBOutlet weak var textDescripcion: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableInvitado: UITableView!
    
    var meetSeleccionada : MeetRealm?
    var invitados : [UsuarioRealm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initInterface()
        self.initDelegates()
    }
    
    private func initDelegates(){
        self.tableInvitado.delegate = self
        self.tableInvitado.dataSource = self
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
    
}
