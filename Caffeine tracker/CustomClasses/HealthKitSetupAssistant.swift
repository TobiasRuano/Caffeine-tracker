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
    
//    private enum HealthkitSetupError: Error {
//        case notAvailableOnDevice
//        case dataTypeNotAvailable
//    }
    
    public func requestPermissions() {
        let dataTypesToWrite : Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!,
                               HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)!]
        
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
            let water = HKQuantitySample(type: quantityTypeWater, quantity: HKQuantity.init(unit: getUnit(), doubleValue: Double(WaterAmount!)), start: forDate, end: forDate)
            
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
                UserDefaults.standard.set(false, forKey: healthStatusKey)
            }
            if success {
                print("Caffeine Saved: \(success)")
                UserDefaults.standard.set(true, forKey: healthStatusKey)
            }
        }
    }
    
    public func editData() {
        
    }
    
    func getSample() {
        
    }
    
    public func deleteWater(drink: drink) {
        var water: HKQuantitySample? = nil
        guard let waterSampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater) else {
            fatalError("*** This method should never fail ***")
        }
        let startDate = drink.getDate()
        let endDate = drink.getDate().addingTimeInterval(1)
        let waterPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let query = HKSampleQuery(sampleType: waterSampleType, predicate: waterPredicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { query, results, error in
            if (error == nil) {
                guard let samples = results as? [HKQuantitySample] else {
                    fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription ?? "No description found")");
                }
                for sample in samples {
                    let value = Int(sample.quantity.doubleValue(for: self.getUnit()))
                    if value == Int(drink.getMl()) {
                        water = sample
                    } else if value == Int(drink.getUSoz()) {
                        water = sample
                    } else if value == Int(drink.getUKoz()) {
                        water = sample
                    }
                }
                if water != nil {
                    self.healthStore.delete(water!) { success, error in
                        if (error != nil) {
                            print("Caffeine Error: \(String(describing: error))")
                        }
                        if success {
                            print("Caffeine Deleted: \(success)")
                        }
                    }
                }
            } else {
                print("Esta pasando esto: \(String(describing: error))")
            }
        }
        healthStore.execute(query)
    }
    
    public func deleteCaffeine(drink: drink) {
        var caffeine: HKQuantitySample? = nil
        guard let caffeineSampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine) else {
            fatalError("*** This method should never fail ***")
        }
        let startDate = drink.getDate()
        let endDate = drink.getDate().addingTimeInterval(1)
        let caffeinePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let query = HKSampleQuery(sampleType: caffeineSampleType, predicate: caffeinePredicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) {
            query, results, error in
            if (error == nil) {
                guard let samples = results as? [HKQuantitySample] else {
                    fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
                }
                for sample in samples {
                    let value = Int(sample.quantity.doubleValue(for: .gramUnit(with: .milli)))
                    if value == Int(drink.getCaffeineMgAdded()) {
                        caffeine = sample
                    } else if value == Int((drink.getCaffeineMgAdded() * 3.0) / usConvertionRate) {
                        caffeine = sample
                    } else if value == Int((drink.getCaffeineMgAdded() * 3.0) / ukConvertionRate) {
                        caffeine = sample
                    }
                }
                if caffeine != nil {
                    self.healthStore.delete(caffeine!) { success, error in
                        if (error != nil) {
                            print("Caffeine Error: \(String(describing: error))")
                        }
                        if success {
                            print("Caffeine Deleted: \(success)")
                        }
                    }
                }
            } else {
                print("Esta pasando esto: \(String(describing: error))")
            }
        }
        
        healthStore.execute(query)
    }
    
    private func getUnit() -> HKUnit {
        switch unitGlobal {
        case .ml:
            return HKUnit.literUnit(with: .milli)
        case .flOzUS:
            return HKUnit.fluidOunceUS()
        case .flOzUK:
            return HKUnit.fluidOunceImperial()
        }
    }
}
