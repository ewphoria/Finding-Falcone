//
//  Beer.swift
//  Crafts Beer
//
//  Created by myMac on 01/07/18.
//  Copyright © 2018 Love. All rights reserved.
//

import Foundation

class Planet : Codable {
    
    var name : String
    var distance : Int
    var isSelected : Bool
    
    var position : Int
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.distance = try container.decodeIfPresent(Int.self, forKey: .distance) ?? 0
        self.isSelected = try container.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
        
        self.position = try container.decodeIfPresent(Int.self, forKey: .position) ?? -1
    }
}
