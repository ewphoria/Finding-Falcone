//
//  ViewController.swift
//  Finding Falcone
//
//  Created by myMac on 12/07/18.
//  Copyright © 2018 Love. All rights reserved.
//

import UIKit
import CZPicker
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
CZPickerViewDelegate, CZPickerViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    
    let dataManager = DataManager.sharedInstance
    let spaceViewModel = SpaceViewModel()
    
    let disposeBag = DisposeBag()
    
    typealias Section = AnimatableSectionModel<String, PlanetCollectionViewCell>
    
    
    
    /* dataSource.configureCell = { (_, collection, indexPath, traveler) in
     let cell = collection.dequeueReusableCell(withReuseIdentifier: PlanetCollectionViewCell.identifier, for: indexPath) as! PlanetCollectionViewCell
     
     return cell
     }*/
    
    let picker = CZPickerView(headerTitle: "Select a vehicle", cancelButtonTitle: nil, confirmButtonTitle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker?.delegate = self
        picker?.dataSource = self
        
        picker?.initializeCustomProperties()
        
        self.collectionView.setState(.loading)
        
        /*collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<Section>(configureCell: { (_, collection, indexPath, traveler) in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: PlanetCollectionViewCell.identifier, for: indexPath) as! PlanetCollectionViewCell
            
            return cell
        })*/

        
        dataManager.getAllThePlanetsFromServer { [weak self] (success, errorMessage,responseObject) in
            
            if let error = errorMessage {
                self?.collectionView.setError(error)
            } else {
                self?.collectionView.setStateLoaded()
            }
            self?.collectionView.reloadData()
        }
    }
    
    //MARK: UICollectionView Data Source and Delegate Methods Implementation
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataManager.arrAllPlanets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlanetCollectionViewCell.identifier, for: indexPath) as! PlanetCollectionViewCell
        
        cell.displayContent(planet: dataManager.arrAllPlanets[indexPath.row])
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let planet = dataManager.arrAllPlanets[indexPath.row]
        
        planet.position = indexPath.row
        
        presentVehiclesSelectionViewController(planet)
    }
    
    func presentVehiclesSelectionViewController(_ planet : Planet) -> Void {
        
        self.picker?.tag = planet.position
        
        self.collectionView.setState(.loading)
        
        dataManager.filterVehiclesForPlanet(planet, completion: { [weak self] (success, errorMessage, vehicles) in
            if success {
                self?.collectionView.setStateLoaded()
                self?.picker?.reloadData()
                self?.picker?.show()
            }
        })
    }

    
    //MARK: CZPickerView Data Source and Delegate Methods Implementation
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return dataManager.arrFilteredVehicles.count
    }
    
    /*func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return dataManager.arrFilteredVehicles[row].name;
    }*/
    
    func czpickerView(_ pickerView: CZPickerView!, attributedTitleForRow row: Int) -> NSAttributedString! {
        
        let vehicleName = dataManager.arrFilteredVehicles[row].name
        let attributedString = NSMutableAttributedString(string: vehicleName)

        if let labelFont = UIFont.init(name: "Poppins", size: 14.0) {
            attributedString.addAttribute(NSAttributedStringKey.font, value: labelFont, range: NSRange.init(location: 0, length: attributedString.length - 1))
        }
        return attributedString
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        
        self.picker?.unselectAll()
        let position = pickerView.tag
        
        let vehicleName = dataManager.arrFilteredVehicles[row].name
        let planetName = dataManager.arrAllPlanets[position].name
        
        dataManager.assignVehicleToPlanet(planetName, vehicleName) {[weak self] (success, errorMessage,responseObject) in
            
            if let error = errorMessage {
                presentAlert(withTitle: "Finding Falcone", message: error)
            } else {
                let indexPath = IndexPath(row: position, section: 0)
                
                if let cell = self?.collectionView.cellForItem(at: indexPath) as? PlanetCollectionViewCell {
                    cell.btnVehicle.setTitle(vehicleName, for: .normal)
                }

            }
        }
    }
}

extension UICollectionView {

    func setError(_ errorMessage: String) {
        
        let loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        loadingView.setError(errorMessage)
        self.backgroundView = loadingView
    }
    
    func setState(_ state: LoadingView.State) {
        
       let loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        loadingView.setState(state)
        self.backgroundView = loadingView
    }
    
    func setStateLoaded() -> Void {
        self.backgroundView = nil
    }
}

extension UIViewController {
    
    func presentAlert(withTitle title: String, message : String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension CZPickerView {
    
    func initializeCustomProperties() -> Void {
        
        if let labelFont = UIFont.init(name: "Poppins", size: 16.0) {
            self.headerTitleFont = labelFont
        }
        
        self.allowMultipleSelection = false
        self.headerTitleColor = UIColor.white
        self.headerBackgroundColor = UIColor.black
    }
}


