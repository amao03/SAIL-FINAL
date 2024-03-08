//
//  HealthKit.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import Foundation
import HealthKit

struct HealthKitData{
    private var healthStore = HKHealthStore()
    
    private enum HealthkitSetupError: Error {
        case success
        case notAvailableOnDevice
        case dataTypeNotAvailable
        case errorSettingUpQuantityType
        case couldNotSample
        case couldNotGetFirstValue
    }
    
    // Authorize Health Kit
    static func authorizeHealthKit (completion : @escaping (Bool, Error?) -> Void){
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        let typesToRead = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!,
                           HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                               HKObjectType.quantityType(forIdentifier: .cyclingPower)!,
        ])
        
        HKHealthStore().requestAuthorization(toShare: [], read: typesToRead) { (success, error) in
            completion(success, error)
        }
    }
    
    // Returns the most recent sample from query
    static func getSample(type:String, completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
        
        guard let sampleType = HKSampleType.quantityType(forIdentifier: DataTypes.getDataType(type: type)) else{
            print ("error with heart rate type")
            completion(nil, HealthkitSetupError.errorSettingUpQuantityType)
            return
        }

        HealthKitData.executeQuery(sampleType: sampleType) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    print(error)
                }
                completion(nil, HealthkitSetupError.couldNotSample)
                return
            }
            
            guard let sampleFirst = sample.first else{
                completion(nil, HealthkitSetupError.couldNotGetFirstValue)
                return
            }
            
            completion(sampleFirst, nil)
            return
        }
    }
    
    // Executes query to get samples for a given type
    static func executeQuery(sampleType: HKSampleType,
                                    completion: @escaping ([HKQuantitySample]?, Error?) -> Swift.Void) {
        let calendar = NSCalendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        
        guard let startDate = calendar.date(from: components) else {
            fatalError("*** Unable to create the start date ***")
        }
        
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            fatalError("*** Unable to create the end date ***")
        }
        
        let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let sortByDate = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                        predicate: today,
                                        limit: 1,
                                        sortDescriptors: [sortByDate]) { (query, samples, error) in
            
            DispatchQueue.main.async {
                
                guard let samples = samples as? [HKQuantitySample] else {
                    
                    completion(nil, error)
                    return
                }
                completion(samples, nil)
            }
            
        }
        
        HKHealthStore().execute(sampleQuery)
    }
}
