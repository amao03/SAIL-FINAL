//
//  ProcessCompassValues.swift
//  sail-v1
//
//  Created by Alice Mao on 8/6/24.
//

import Foundation

extension TimerControls{
    func setCurrentValue(){
        let type = connector.test.patternObject.type
        
        switch (type){
        case DataType.distance, DataType.heartrate, DataType.cycling:
            HealthKitData.getSample(type: type) { (sample, error) in
                guard let sample = sample else {
                    if let error = error {
                        print(error)
                    }
                    return
                }
                
                let unit = DataTypes.getUnits(type: type)
                let rawValue = sample.quantity.doubleValue(for: unit)
                print(rawValue)
                self.currentData = round(rawValue * 100) / 100.0
            }
            
        case DataType.fake:
            currentData = fakeDataArr[fakeDataIndex]
            fakeDataIndex += 1
            
        case DataType.random:
            currentData = Double(Int.random(in: 0..<3))
        
        case DataType.altitude:
            currentData = Double(connector.altitude)
            
        case DataType.direction:
            currentData = Double(connector.direction)
        case DataType.rower:
            currentData = Double(connector.rower)
        }
        
        print("Val: \(currentData)")
    }
    
    func determinePattern(){
        switch (connector.test.patternObject.type){
        case DataType.fake, DataType.random:
            setCurrentFakePattern()
        default:
            setCurrentPattern()
        }
    }
    
    func setCurrentPattern(){
        let target = connector.test.startVal
        
        if currentData < (target - connector.test.underRange){
            currPattern = connector.test.patternObject.underPattern.HapticArray
            timeBetween = connector.test.patternObject.underPattern.duration
            colorState = AnimationState.under
        }
        else if currentData > (target + connector.test.aboveRange){
            currPattern = connector.test.patternObject.abovePattern.HapticArray
            timeBetween = connector.test.patternObject.abovePattern.duration
            colorState = AnimationState.above
        }
        else {
            currPattern = connector.test.patternObject.atPattern.HapticArray
            timeBetween = connector.test.patternObject.atPattern.duration
            colorState = AnimationState.at
        }
        print("Set Pattern: \(colorState)   target: \(target)")
    }
    
    func setCurrentFakePattern(){
        if currentData == 0{
            currPattern = connector.test.patternObject.underPattern.HapticArray
            timeBetween = connector.test.patternObject.underPattern.duration
            colorState = AnimationState.under
        }
        else if currentData == 2{
            currPattern = connector.test.patternObject.abovePattern.HapticArray
            timeBetween = connector.test.patternObject.abovePattern.duration
            colorState = AnimationState.above
        }
        else {
            currPattern = connector.test.patternObject.atPattern.HapticArray
            timeBetween = connector.test.patternObject.atPattern.duration
            colorState = AnimationState.at
        }
        print("Set Pattern: \(currPattern)   timeBetween: \(timeBetween)")
    }
    
    func updateTarget(){
        let random = Bool.random()
        
        if random{
            connector.test.startVal = connector.test.target + connector.test.step
        } else{
            connector.test.startVal = connector.test.target - connector.test.step
        }
        
        print("Update target: \(connector.test.startVal)")
    }
}
