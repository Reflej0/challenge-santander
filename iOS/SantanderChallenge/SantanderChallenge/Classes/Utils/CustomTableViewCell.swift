//
//  CustomTableViewCell.swift
//  SantanderChallenge
//
//  Created by Juan Tocino on 29/08/2020.
//  Copyright © 2020 Reflejo. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelNombre: UILabel!
    @IBOutlet weak var labelFecha: UILabel!
    @IBOutlet weak var labelPersonasValor: UILabel!
    var meet: MeetRealm?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setMeet(meet: MeetRealm){
        self.labelNombre.text = meet.nombre
        self.labelFecha.text = Utils.dateToString(fecha: meet.fecha!)
        let cantidadPersonas = meet.usuarios.count
        self.labelPersonasValor.text = String(cantidadPersonas)
    }
    
}
