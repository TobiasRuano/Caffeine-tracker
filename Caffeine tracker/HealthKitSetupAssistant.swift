//
//  HealthKitSetupAssistant.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 13/6/18.
//  Copyright © 2018 Tobias Ruano. All rights reserved.
//

import HealthKit

class HealthKitSetupAssistant {
    
    public let healthStore = HKHealthStore()
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    public func requestPermissions() {
        let dataTypesToWrite : Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!,
                               HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!]
        //let dataTypesToRead : Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!]
        
        var logWaterBool: Bool = true
        if UserDefaults.standard.value(forKey: logWaterBoolKey) != nil {
            logWaterBool = UserDefaults.standard.value(forKey: logWaterBoolKey) as! Bool
        }
        
        healthStore.requestAuthorization(toShare: dataTypesToWrite, read: nil, completion: { (success, error) in
            if success {
                print("Authorization complete")
            } else {
                print("Authorization error: \(String(describing: error?.localizedDescription))")
                //TODO: No hace esto!!
                logWaterBool = false
            }
        })
        UserDefaults.standard.set(logWaterBool, forKey: logWaterBoolKey)
    }
    
    
    public func submitCaffeine(CaffeineAmount: Int, WaterAmount: Int?, forDate : Date, logWater: Bool) {
        let quantityTypeCaffeine = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!
        let caffeine = HKQuantitySample(type: quantityTypeCaffeine, quantity: HKQuantity.init(unit: HKUnit.gramUnit(with: HKMetricPrefix.milli), doubleValue: Double(CaffeineAmount)), start: forDate, end: forDate)
        if logWater == true {
            let quantityTypeWater = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
            let water = HKQuantitySample(type: quantityTypeWater, quantity: HKQuantity.init(unit: HKUnit.literUnit(with: .milli), doubleValue: Double(WaterAmount!)), start: forDate, end: forDate)
            
            healthStore.save(water) { success, error in
                if (error != nil) {
                    print("Water Error: \(String(describing: error))")
                }
                if success {
                    print("Water Saved: \(success)")
                }
            }
        }
        
        healthStore.save(caffeine) { success, error in
            if (error != nil) {
                print("Caffeine Error: \(String(describing: error))")
            }
            if success {
                print("Caffeine Saved: \(success)")
            }
        }
    }
}
