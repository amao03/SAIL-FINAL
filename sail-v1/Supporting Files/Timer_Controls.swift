//
//  Timer_Controls.swift
//  sail-v1
//
//  Created by Alice Mao on 12/8/23.
//

import Foundation
import HealthKit
import SwiftUI

final class TimerControls: NSObject, ObservableObject{
    static let time = TimerControls()
    var connector = ConnectToWatch.connect
    let fakeDataArr = [0.0, 1.0, 2.0, 0.0]
    var fakeDataIndex = 0
    
    @Published var end:Bool = true
    @Published var currentData = 160.0
    @Published var currPattern:[Haptics] = []
    @Published var timeBetween = 1.0
    @Published var colorState = AnimationState.at
    var currPatternIndex = 0
    
    @ObservedObject var ExtendedSess = ExtendedSession()
    
    var overallTimer: Timer?
    var currentTimer: Timer?
    var startTime = CFAbsoluteTimeGetCurrent()
    var counter = 0
    
    // Deals with stopping timer early and displaying start/stop button
    public func toggleEnd(){
        print("toggle end \(end)")
        self.end = !end
    }

    // Controls the overall timing of playing haptics
    public func startOverallTimer(){
        ExtendedSess.startExtendedSession()
        print("start overall timer")
        
        setCurrentValue()
        determinePattern()
        startCurrentTimer()
        
        //updates value every 2 secs
        overallTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(fireOverallTimer), userInfo: nil, repeats: true)
    }
    
    // Plays a specific haptic pattern for a given amount of time
    func startCurrentTimer(){
        print("start current timer")
        if currPattern.count == 0{
            Timer.scheduledTimer(withTimeInterval: connector.test.duration, repeats: false) { timer in
            }
            return
        }
        
        startTime = CFAbsoluteTimeGetCurrent()
        
        Haptics.play(currHaptic: currPattern[currPatternIndex % currPattern.count])
        
        currentTimer = Timer.scheduledTimer(timeInterval: timeBetween, target: self, selector: #selector(fireCurrentTimer), userInfo: nil, repeats: true)
    }
    
    @objc func fireOverallTimer(){
        if ((currentTimer?.isValid) != nil){
            currentTimer?.invalidate()
            print("end current timer - early")
            print()
        }
        
        if (self.connector.test.patternObject.type == DataType.fake && fakeDataIndex >= 4){
            print("done with overall")
            overallTimer?.invalidate()
            currentTimer?.invalidate()
            self.ExtendedSess.stopExtendedSession()
            self.end = true
            fakeDataIndex = 0
            return
        } else if self.end{
            print("done with overall")
            self.ExtendedSess.stopExtendedSession()
            self.end = true
            overallTimer?.invalidate()
            currentTimer?.invalidate()
            fakeDataIndex = 0
            return
        } else if (connector.test.name == "Endurance" || connector.test.name == "Pyramid") && connector.test.duration <= Double(counter){
            print("done with overall")
            self.ExtendedSess.stopExtendedSession()
            self.end = true
            overallTimer?.invalidate()
            currentTimer?.invalidate()
            fakeDataIndex = 0
            
            return
        } else if (connector.test.name == "Step") && connector.test.startVal >= connector.test.endVal{
            print("done with overall")
            self.ExtendedSess.stopExtendedSession()
            self.end = true
            overallTimer?.invalidate()
            currentTimer?.invalidate()
            fakeDataIndex = 0
            return
        }
        
        
        if connector.test.name == "Step" && connector.test.duration < Double(2 * counter){ //update startVal every duration
            counter = 0
            connector.test.startVal += connector.test.step
        }
        
        if connector.test.name == "Pyramid" && connector.test.duration < Double(2 * counter){ //update startVal every duration
            counter = 0
            updateTarget()
        }
        
        setCurrentValue()
        determinePattern()
        startCurrentTimer()
        print(counter)
        counter += 1
    }
    
    @objc func fireCurrentTimer(){
        let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
        if elapsedTime >= self.connector.test.duration {
            currentTimer?.invalidate()
            currPatternIndex = 0
            print("end current timer")
            print()
            return
        } else if self.end{
            currentTimer?.invalidate()
            self.end = true
            currPatternIndex = 0
            print("end current timer - end")
            print()
            return
        }
        
        let currHaptic = currPattern[currPatternIndex % currPattern.count]
        Haptics.play(currHaptic: currHaptic)
        currPatternIndex += 1
    }
}
