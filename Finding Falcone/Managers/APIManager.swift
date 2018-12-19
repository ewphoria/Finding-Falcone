//
//  APIManager.swift
//  Crafts Beer
//
//  Created by myMac on 01/07/18.
//  Copyright © 2018 Love. All rights reserved.
//

import Foundation

class APIManager {
    
    static let sharedInstance = APIManager()
    
    private init() {}
    
    public func fetchData<T: Codable>(_ url : String, success : @escaping(T) -> (), failure : @escaping(String) -> ()) -> Void {
        
        guard let url = URL.init(string: url)  else {
            failure("Badly formed URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, taskError) in
            
            if let error = taskError {
                
                failure(error.localizedDescription)
            } else {
                
                if let taskData = data {
                    
                    do {
                        let jsonObject = try JSONDecoder().decode(T.self, from: taskData)
                        success(jsonObject)
                        return
                    } catch {
                        failure(error.localizedDescription)
                        return
                    }
                }
                failure("Could not process data.")
            }
            }.resume()
    }    
}
