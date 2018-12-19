//
//  DataManager.swift
//  Crafts Beer
//
//  Created by myMac on 01/07/18.
//  Copyright © 2018 Love. All rights reserved.
//

import Foundation

class DataManager {
    
    var arrAllPlanets = [Planet]()
    var arrAllVehicles = [Vehicle]()
    var arrFilteredVehicles = [Vehicle]()
    
    var selectedVehicles = [String : String]()
    
    static let sharedInstance = DataManager()
    
    let PAGE_COUNT = 10
    
    static let MAX_PLANET_COUNT = 4
    
    private init() {}
    
    typealias CompletionBlock = (_ success : Bool, _ errorMessage : String?, _ responseObject : Any?) -> Void
    
    func getAllThePlanetsFromServer(completion :  @escaping CompletionBlock) -> Void {
        
        APIManager.sharedInstance.fetchData(APIURL.planets, success: { [weak self] (planets: [Planet]) in
            
            self?.arrAllPlanets.removeAll()
            self?.arrAllPlanets.append(contentsOf: planets)
            
            DispatchQueue.main.async {
                completion(true,nil,nil)
            }
            
        }) { (error) in
            
            DispatchQueue.main.async {
                completion(false,error,nil)
            }
        }
    }
    
    func getAllTheVehiclesFromServer(completion :  @escaping CompletionBlock) -> Void {
        
        APIManager.sharedInstance.fetchData(APIURL.vehicles, success: { [weak self] (vehicles: [Vehicle]) in
            
            self?.arrAllVehicles.removeAll()
            self?.arrAllVehicles.append(contentsOf: vehicles)
            
            DispatchQueue.main.async {
                completion(true,nil,nil)
            }
            
        }) { (error) in
            
            DispatchQueue.main.async {
                completion(false,error,nil)
            }
        }
    }
    
    func filterVehiclesForPlanet(_ planet: Planet, completion : @escaping CompletionBlock) -> Void {
        
        if self.arrAllVehicles.isEmpty {
            
            self.getAllTheVehiclesFromServer(completion: {[weak self] (success, errorMessage, responseObject) in
                
                if success {
                    self?.filterVehiclesForPlanet(planet, completion: completion)
                }
            })
        } else {
            
            if !arrFilteredVehicles.isEmpty {
                arrFilteredVehicles.removeAll()
            }
            arrFilteredVehicles = self.arrAllVehicles.filter({ (vehicle) -> Bool in
                
                return vehicle.max_distance >= planet.distance
            })
            
            if !arrFilteredVehicles.isEmpty {
                completion(true,nil,arrFilteredVehicles)
            }
        }
    }
    
    func assignVehicleToPlanet(_ planet : String, _ vehicle : String, completion : CompletionBlock ) -> Void {
        
        if (selectedVehicles.keys.count) >= DataManager.MAX_PLANET_COUNT {
            completion(false, "You can send vehicles to only \(DataManager.MAX_PLANET_COUNT) at a time.",nil)
            return
        }
        
        selectedVehicles.updateValue(vehicle, forKey: planet)
        completion(true, nil,nil)
    }
    
    
}
