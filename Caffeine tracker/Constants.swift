//
//  Variables.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 7/7/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import Foundation

enum Unit: Int {
    case ml
    case flOzUS
    case flOzUK
}

//Global Variables
var arrayDrinks: [drink] = []
var arrayDrinksAdded: [drink] = []
var unitGlobal: Unit = .ml
var checkMarkString: String = "Starbucks"

var drinksLimit: drinkLimit = drinkLimit(cant: 0, date: Date())

let usConvertionRate = 3.3814022702 // 3.3814
let ukConvertionRate = 3.5195079728 // 3.5195

//Keys
let healthStatusKey = "healthStatus"
let toSaveKey = "tosave"
let arrayDrinksKey = "array"
let arrayDrinksAddedKey = "arrayAdded"
let cellForCheckmarkKey = "CellForCheckmark"
let logWaterBoolKey = "logWaterBool"
let inAppPurchaseKey = "Purchase"
let drinkLimitKey = "limit"
let onboardingCheck = "OnboardingScreen"
//let systemModeKey = "systemMode"
//let themeKey = "themeKey"

//Identifiers
let modalViewIdentifier = "ShowModalView"
let homeTableViewCell = "cell"
let historyTableViewCell = "cell"
let onboardingRoot = "OnboardingRoot"
let unwindID = "unwind"
let iconID = "icon"
