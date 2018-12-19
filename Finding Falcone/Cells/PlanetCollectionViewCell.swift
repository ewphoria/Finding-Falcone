//
//  BeerTableViewCell.swift
//  Crafts Beer
//
//  Created by myMac on 01/07/18.
//  Copyright © 2018 Love. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PlanetCollectionViewCell : UICollectionViewCell,IdentifiableType {
    
    var identity: String = ""
    
    typealias Identity = String
    
    
    static let identifier = "planetCollectionCell"
    
    @IBOutlet weak var lblPlanetName: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var imgVwPlanet: UIImageView!
    @IBOutlet weak var btnVehicle: UIButton!

    func displayContent(planet : Planet) -> Void {
        
        lblPlanetName.text = planet.name
        lblDistance.text = "Distance: \(planet.distance) megamiles"
        
        if let planetImage = UIImage.init(named: planet.name) {
            imgVwPlanet.image = planetImage
        }
    }
}

