//
//  LoginViewController.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 29/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: CONNECTIONS
    
    @IBOutlet weak var textUsuario: UITextField!
    @IBOutlet weak var textContrasena: UITextField!
    @IBOutlet weak var buttonIngresar: UIButton!
    @IBOutlet weak var buttonCrearUsuarioAdmin: UIButton!
    @IBOutlet weak var buttonCrearUsuario: UIButton!
    
    var usuarioService = UsuarioService()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initInterface()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
    }
    
    public func initInterface(){
        self.buttonIngresar.layer.cornerRadius = 15
        self.buttonCrearUsuario.layer.cornerRadius = 15
        self.buttonCrearUsuarioAdmin.layer.cornerRadius = 15
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: ACTIONS
    
    @IBAction func buttonCrearUsuarioAdminClicked(_ sender: Any) {
        let usuario = textUsuario.text!
        let contrasena = textContrasena.text!
        let rol = 1
        usuarioService.nuevoUsuario(usuario: usuario, contrasena: contrasena, rol: rol, completion: self.doCompletionCrear)
    }
    
    @IBAction func buttonCrearUsuarioClicked(_ sender: Any) {
        let usuario = textUsuario.text!
        let contrasena = textContrasena.text!
        let rol = 0
        usuarioService.nuevoUsuario(usuario: usuario, contrasena: contrasena, rol: rol, completion: self.doCompletionCrear)
    }
    
    @IBAction func buttonIngresarClicked(_ sender: Any) {
        let usuario = textUsuario.text!
        let contrasena = textContrasena.text!
        usuarioService.login(usuario: usuario, contrasena: contrasena, completion: self.doCompletionLogin)
    }
    
    public func doCompletionLogin(rol: Int){
        if(rol == -1){
            let alert = UIAlertController(title: "Usuario no encontrado", message: "Usuario no encontrado o incorrecto", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if(rol == 0){
            self.performSegue(withIdentifier: "segueInicioUsuario", sender: nil)
        }
        else if(rol == 1){
            self.performSegue(withIdentifier: "segueInicioAdministrador", sender: nil)
        }
    }
    
    public func doCompletionCrear(){
        let alert = UIAlertController(title: "Usuario creado", message: "El usuario fue creado", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: FUNCIONES DE TECLADO
    
    // Adaptación de la pantalla al mostrar ú ocultar el teclado.
    private func setupHideKeyboardOnTap()
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
                self.view.frame.origin.y -= keyboardSize.height + 0
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
