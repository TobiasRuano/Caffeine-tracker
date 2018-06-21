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
        let dataTypesToRead : Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!]
        
        healthStore.requestAuthorization(toShare: dataTypesToWrite, read: dataTypesToRead, completion: { (success, error) in
            if success {
                print("Authorization complete")
            } else {
                print("Authorization error: \(String(describing: error?.localizedDescription))")
            }
        })
        
    }
    
    
    public func submitCaffeine(CaffeineAmount: Int, WaterAmount: Int, forDate : Date) {
        let quantityTypeCaffeine = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!
        let caffeine = HKQuantitySample(type: quantityTypeCaffeine, quantity: HKQuantity.init(unit: HKUnit.gramUnit(with: HKMetricPrefix.milli), doubleValue: Double(CaffeineAmount)), start: forDate, end: forDate)
        let quantityTypeWater = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!
        let water = HKQuantitySample(type: quantityTypeWater, quantity: HKQuantity.init(unit: HKUnit.literUnit(with: .milli), doubleValue: Double(WaterAmount)), start: forDate, end: forDate)
        healthStore.save(caffeine) { success, error in
            if (error != nil) {
                print("Caffeine Error: \(String(describing: error))")
            }
            if success {
                print("Caffeine Saved: \(success)")
            }
        }
        healthStore.save(water) { success, error in
            if (error != nil) {
                print("Water Error: \(String(describing: error))")
            }
            if success {
                print("Water Saved: \(success)")
            }
        }
    }
}
