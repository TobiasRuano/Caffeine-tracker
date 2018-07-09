//
//  Variables.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 7/7/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import Foundation

struct drink: Codable {
    var type: String
    var caffeineML: Int
    var caffeineOZ: Int
    var icon: String
    
    init(type: String, caffeineML: Int, caffeineOZ: Int, icon: String) {
        self.type = type
        self.caffeineML = caffeineML
        self.caffeineOZ = caffeineOZ
        self.icon = icon
    }
}

//Struct para pestana added!
struct drinkWithDate: Codable {
    var dia: Date
    var nombre: String
    var caffeineML: Int
    var caffeineOZ: Int
    
    init(name: String, dia: Date, cafML: Int, cafOZ: Int) {
        self.dia = dia
        self.nombre = name
        self.caffeineML = cafML
        self.caffeineOZ = cafOZ
    }
}
