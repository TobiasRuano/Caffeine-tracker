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
    var date: Date?
    var icon: String
    
    init(type: String, caffeineMg: Int, mililiters: Int, icon: String, dia: Date?) {
        self.type = type
        self.caffeineMg = caffeineMg
        self.mililiters = mililiters
        self.date = dia
        self.icon = icon
    }
}

struct drinkLimit: Codable {
    var cant: Int
    var date: Date
    
    init(cant: Int, date: Date) {
        self.cant = cant
        self.date = date
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
let inAppPurchaseKey = "Purchase"
let drinkLimitKey = "limit"

//Identifiers
let modalViewIdentifier = "ShowModalView"
let homeTableViewCell = "cell"
let historyTableViewCell = "cell"

