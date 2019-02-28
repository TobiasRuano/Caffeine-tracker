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
    var caffeineMg: Int
    var mililiters: Int
    var icon: String
    
    init(type: String, caffeineMg: Int, mililiters: Int, icon: String) {
        self.type = type
        self.caffeineMg = caffeineMg
        self.mililiters = mililiters
        self.icon = icon
    }
}

//Struct para pestana added!
struct drinkWithDate: Codable {
    var dia: Date?
    var nombre: String
    var caffeine: Int
    var icon: String
    
    init(name: String, dia: Date?, caff: Int, ic: String) {
        self.dia = dia
        self.nombre = name
        self.caffeine = caff
        self.icon = ic
    }
}

//Global Variables
var arrayDrinks: [drink] = []
var arrayDrinksAdded: [drink] = []

var checkMarkString: String = "Starbucks"

//Keys
let toSaveKey = "tosave"
let arrayDrinksKey = "array"
let arrayDrinksAddedKey = "arrayAdded"
let cellForCheckmarkKey = "CellForCheckmark"
let logWaterBoolKey = "logWaterBool"

//Identifiers
let modalViewIdentifier = "ShowModalView"
let homeTableViewCell = "cell"
let historyTableViewCell = "cell"

