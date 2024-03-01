//
//  CreateTimer.swift
//  v2
//
//  Created by Alice Mao on 2/8/24.
//

import Foundation

class CreateTimer: NSObject, ObservableObject{
    @Published var currentData = 160.0
    @Published var end:Bool = true
    
    @Published var connector = ConnectToWatch.connect
    
    public func startTimer(patternObject: Pattern, realData:Bool, randomData:Bool){
        print("start overall timer")
        
        var index = 0
        let dataArr = [150.0, 160.0, 170.0, 150.0]
        self.currentData = dataArr[index]
        
        var currHaptic = determineHaptics(patternObject: patternObject, val: self.currentData)
        
        self.connector.sendDataToWatch(sendObject: currHaptic)
        
        index += 1
        
        Timer.scheduledTimer(withTimeInterval: patternObject.timeOverall, repeats: true){ timer in
            if(index >= dataArr.count && !realData) || index >= 1000 {
                print("done with overall")
            
                timer.invalidate()
//                self.ExtendedSess.stopExtendedSession()
                self.end = true
                return
            } else if self.end{
                print("done with overall")
//                self.ExtendedSess.stopExtendedSession()
                self.end = true
                timer.invalidate()
                return
            }
            
            self.currentData = dataArr[index]
            let newHaptic = self.determineHaptics(patternObject: patternObject, val: self.currentData)
            
            if newHaptic != currHaptic{
                self.connector.sendDataToWatch(sendObject: currHaptic)
                currHaptic = newHaptic
            }
            
            index += 1
        }
    }
    
    // Determine which haptic pattern to play and for how li=ong given a value
    public func determineHaptics(patternObject: Pattern, val: Double) -> MadePattern {
        let target = patternObject.target
        
        if val < (target - patternObject.range){
            return patternObject.underPattern
        }
        else if val > (target + patternObject.range){
            return patternObject.abovePattern
        }
        else {
            return patternObject.atPattern
        }
        
//        self.sendPatternToWatch(patternObject: patternObject,currPattern: currPattern, timeBetween: timeBetween)
    }
    
    public func sendPatternToWatch(patternObject: Pattern, currPattern: [Haptics], timeBetween: Double){
        
        print("send pattern")
        if currPattern.count == 0{
            Timer.scheduledTimer(withTimeInterval: patternObject.timeOverall, repeats: false) { timer in
            }
            return
        }
        
        var index = 0
        var timeIndex = 0
        Timer.scheduledTimer(withTimeInterval: timeBetween, repeats: true) { timer in
            
            // Contitions to end timer
            if (Double(index) * timeBetween) >= patternObject.timeOverall {
                timer.invalidate()
                return
            } else if self.end{
                timer.invalidate()
                self.end = true
                return
            }
                self.connector.sendDataToWatch(sendObject: patternObject)
                let currHaptic = currPattern[index % currPattern.count]
                index += 1
                timeIndex += 1
        }
        
        
    }
    
    
}
