//
//  Drink.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 10/04/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import Foundation

class drink: Codable {
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

class drinkLimit: Codable {
    var cant: Int
    var date: Date
    
    init(cant: Int, date: Date) {
        self.cant = cant
        self.date = date
    }
}
