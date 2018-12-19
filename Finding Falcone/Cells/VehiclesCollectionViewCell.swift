//
//  VehiclesCollectionViewCell.swift
//  Finding Falcone
//
//  Created by myMac on 15/07/18.
//  Copyright © 2018 Love. All rights reserved.
//

import UIKit

class VehiclesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "vehicleCollectionCell"
    
    @IBOutlet weak var lblVehicleName: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var imgVwVehicle: UIImageView!
    
    func displayContent(vehicle : Vehicle) -> Void {
        
        lblVehicleName.text = vehicle.name
        lblSpeed.text = "Speed: \(vehicle.speed) megamiles"
        
        if let vehicleImage = UIImage.init(named: vehicle.name) {
            imgVwVehicle.image = vehicleImage
        }
    }
    
}
