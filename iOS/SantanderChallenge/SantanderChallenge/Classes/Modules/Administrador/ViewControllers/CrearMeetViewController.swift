//
//  CrearMeetViewController.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 29/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import UIKit

class CrearMeetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: CONNECTIONS
    
    @IBOutlet weak var labelNombre: UILabel!
    @IBOutlet weak var labelDescripcion: UILabel!
    @IBOutlet weak var labelFecha: UILabel!
    @IBOutlet weak var labelInvitado: UILabel!
    @IBOutlet weak var labelInvitados: UILabel!
    @IBOutlet weak var textNombre: UITextField!
    @IBOutlet weak var textDescripcion: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textInvitado: UITextField!
    @IBOutlet weak var tableInvitado: UITableView!
    @IBOutlet weak var buttonAgregarInvitado: UIButton!
    
    // MARK: SERVICES / AUX
    
    var meetService = MeetService()
    var usuarioService = UsuarioService()
    var usuariosTotales : [UsuarioRealm]?
    var usuariosAgregados: [UsuarioRealm] = []
    var invitados: [String] = []
    var suggestionsArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initInterface()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.getUsuarios()
        self.initDelegates()
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
    }
    
    private func initInterface(){
        self.textDescripcion.layer.borderColor = UIColor.gray.cgColor
        self.textDescripcion.layer.borderWidth = 1.0
        self.textDescripcion.layer.cornerRadius = 5
        self.tableInvitado.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    private func initDelegates(){
        self.tableInvitado.delegate = self
        self.tableInvitado.dataSource = self
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func getUsuarios(){
        self.usuarioService.getUsuarios(completion: self.doCompletionGetUsuarios)
    }
    
    private func doCompletionGetUsuarios(usuarios: [UsuarioRealm]){
        self.usuariosTotales = usuarios
        for u in usuarios{
            self.suggestionsArray.append(u.usuario)
        }
        self.textInvitado.delegate = self
    }
    
    @IBAction func buttonAgregarInvitado(_ sender: Any) {
        let invitadoNuevo = self.textInvitado.text!
        if(self.suggestionsArray.contains(invitadoNuevo) && !self.invitados.contains(invitadoNuevo)){
            let indice = self.suggestionsArray.firstIndex(of: invitadoNuevo)!
            self.usuariosAgregados.append(self.usuariosTotales![indice])
            self.invitados.append(self.textInvitado.text!)
            self.tableInvitado.reloadData()
            self.textInvitado.text = ""
        }
        else if(self.suggestionsArray.contains(invitadoNuevo) && self.invitados.contains(invitadoNuevo)){
            let alert = UIAlertController(title: "Invitado ya agregado", message: "No puede agregar dos veces el mismo invitado", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Usuario inválido", message: "Usuario no encontrado", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    @IBAction func buttonGuardarClicked(_ sender: Any) {
        let nombre = self.textNombre.text!
        let descripcion = self.textDescripcion.text!
        let fecha = self.datePicker.date
        self.agregarUsuarioActualALaMeet()
        let invitadosMeet = self.usuariosAgregados
        self.meetService.newMeet(nombre: nombre, descripcion: descripcion, fecha: fecha, invitados: invitadosMeet, completion: self.doCompletion)
        self.navigationController!.popViewController(animated: true)
    }
    
    private func agregarUsuarioActualALaMeet(){
        //El usuario que agrega (administrador) tambien esta incluido en la meet
        let usuarioActivoString = UserDefaults.standard.string(forKey: "usuarioActivoString")!
        let indice = self.suggestionsArray.firstIndex(of: usuarioActivoString)!
        let usuarioActivo = self.usuariosTotales![indice]
        self.usuariosAgregados.append(usuarioActivo)
    }
    
    private func doCompletion(){
        
    }
    
    // MARK: TEXTFIELD DELEGATES
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !self.autoCompleteText( in : textField, using: string, suggestionsArray: suggestionsArray)
    }
    
    func autoCompleteText( in textField: UITextField, using string: String, suggestionsArray: [String]) -> Bool {
        if !string.isEmpty,
            let selectedTextRange = textField.selectedTextRange,
            selectedTextRange.end == textField.endOfDocument,
            let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
            let text = textField.text( in : prefixRange) {
            let prefix = text + string
            let matches = suggestionsArray.filter {
                $0.hasPrefix(prefix)
            }
            if (matches.count > 0) {
                textField.text = matches[0]
                if let start = textField.position(from: textField.beginningOfDocument, offset: prefix.count) {
                    textField.selectedTextRange = textField.textRange(from: start, to: textField.endOfDocument)
                    return true
                }
            }
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
    
    // MARK: TABLE DELEGATES
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.invitados.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "invitadoCell")
          cell.textLabel?.text  = self.invitados[indexPath.row]
              
          cell.imageView!.image = UIImage(systemName:"person")
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Eliminar") { (action, sourceView, completionHandler) in
            print(indexPath.row)
            self.invitados.remove(at: indexPath.row)
            self.usuariosAgregados.remove(at: indexPath.row)
            self.tableInvitado.reloadData()
            //completionHandler(true)
        }

        /*let rename = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            print("index path of edit: \(indexPath)")
            completionHandler(true)
        }*/
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [/*rename,*/ delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
    // MARK: FUNCIONES DE TECLADO
    
    // Adaptación de la pantalla al mostrar ú ocultar el teclado.
    func setupHideKeyboardOnTap()
    {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    // Adaptación de la pantalla al mostrar ú ocultar el teclado.
    private func endEditingRecognizer() -> UIGestureRecognizer
    {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    // Adaptación de la pantalla al mostrar ú ocultar el teclado.
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
            if self.view.frame.origin.y == 0
            {
                self.view.frame.origin.y -= keyboardSize.height - 100
            }
        }
    }
    // Adaptación de la pantalla al mostrar ú ocultar el teclado.
    @objc func keyboardWillHide(notification: NSNotification)
    {
        if self.view.frame.origin.y != 0
        {
            self.view.frame.origin.y = 0
        }
    }
    
}
