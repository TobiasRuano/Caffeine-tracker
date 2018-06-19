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
        let dataTypes : Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!]
        
        healthStore.requestAuthorization(toShare: dataTypes, read: dataTypes, completion: { (success, error) in
            if success {
                print("Authorization complete")
            } else {
                print("Authorization error: \(String(describing: error?.localizedDescription))")
            }
        })
        
    }
    
    
    public func submitCaffeine(CaffeineAmount: Int, forDate : Date) {
        let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!
        let caffeine = HKQuantitySample(type: quantityType, quantity: HKQuantity.init(unit: HKUnit.gramUnit(with: HKMetricPrefix.milli), doubleValue: Double(CaffeineAmount)), start: forDate, end: forDate)
        healthStore.save(caffeine) { success, error in
            if (error != nil) {
                print("Error: \(String(describing: error))")
            }
            if success {
                print("Saved: \(success)")
            }
        }
    }
}
