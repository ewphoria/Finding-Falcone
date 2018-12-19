//
//  VehiclesSelectionViewController.swift
//  Finding Falcone
//
//  Created by myMac on 15/07/18.
//  Copyright © 2018 Love. All rights reserved.
//

import UIKit

class VehiclesSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imgVwBackground: UIImageView!
    
    let dataManager = DataManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        self.imgVwBackground.layer.cornerRadius = 5.0
        self.imgVwBackground.clipsToBounds = true
        
        if (dataManager.arrAllVehicles.count == 0){
            
            dataManager.getAllTheVehiclesFromServer(completion: { [weak self] (success, errorMessage, responseObject) in
                
                if let error = errorMessage {
                    //self?.collectionView.setError(error)
                } else {
                    //self?.collectionView.setStateLoaded()
                }
                self?.collectionView.reloadData()
            })

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataManager.arrAllVehicles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VehiclesCollectionViewCell.identifier, for: indexPath) as! VehiclesCollectionViewCell
        
        cell.displayContent(vehicle: DataManager.sharedInstance.arrAllVehicles[indexPath.row])
        
        return cell
    }
    
    
    @IBAction func actionCloseViewController(_ sender: Any) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! VehiclesCollectionViewCell
        let planet = DataManager.sharedInstance.arrAllVehicles[indexPath.row]
        
        
    }
}

