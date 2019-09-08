//
//  Drink.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 10/04/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import Foundation
import HealthKit

class drink: Codable {
    private var type: String
    private var caffeineMg: Double
    private var mililiters: Double
    private var date: Date?
    private var icon: String
    
    init(type: String, caffeineMg: Double, mililiters: Double, icon: String, dia: Date?) {
        self.type = type
        self.caffeineMg = caffeineMg
        self.mililiters = mililiters
        self.date = dia
        self.icon = icon
    }
    
    func getName() -> String {
        return self.type
    }
    
    func setName(name: String) {
        self.type = name
    }
    
    func setDate(date: Date) {
        self.date = date
    }
    
    func getDate() -> Date {
        return self.date!
    }
    
    func setIcon(imageString: String) {
        self.icon = imageString
    }
    
    func getIcon() -> String {
        return self.icon
    }
    
    func setCaffeineMg(value: Double) {
        switch unitGlobal {
        case .ml:
            self.caffeineMg = value
        case .flOzUS:
            let convertion = (value * usConvertionRate) / 3
            self.caffeineMg = convertion
        case .flOzUK:
            let convertion = (value * ukConvertionRate) / 3
            self.caffeineMg = convertion
        }
    }
    
    func setThisCaffeineMg(value: Double) {
        self.caffeineMg = value
    }
    
    func getCaffeineMg() -> Double{
        switch unitGlobal {
        case .ml:
            return self.caffeineMg
        case .flOzUS:
            let convertion = (self.caffeineMg * 3) / usConvertionRate
            return convertion
        case .flOzUK:
            let convertion = (self.caffeineMg * 3) / ukConvertionRate
            return convertion
        }
    }
    
    func getCaffeineMgAdded() -> Double {
        return self.caffeineMg
    }
    
    func setMl(value: Double) {
        switch unitGlobal {
        case .ml:
            self.mililiters = value
        case .flOzUS:
            let temp = (100.0 * value) / usConvertionRate
            self.mililiters = temp
        case .flOzUK:
            let temp = (100.0 * value) / ukConvertionRate
            self.mililiters = temp
        }
    }
    
    func getMl() -> Double {
        return self.mililiters
    }

    func getUSoz() -> Double {
        let value = (self.mililiters * usConvertionRate) / 100
        return value
    }
    
    func getUKoz() -> Double {
        let value = (self.mililiters * usConvertionRate) / 100
        return value
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
