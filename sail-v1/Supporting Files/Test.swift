//
//  Tests.swift
//  SailV3
//
//  Created by Alice Mao on 11/2/24.
//

import Foundation

class Test: Identifiable, Codable, Hashable, ObservableObject{
    static func == (lhs: Test, rhs: Test) -> Bool {
        return lhs.name == rhs.name
    }
    
    var  name = "Step"
    var  patternObject = Pattern(underPattern: MadePatternsList.getPatternByName("super pulse")!, atPattern: MadePatternsList.getPatternByName("heartbeat")!, abovePattern:  MadePatternsList.getPatternByName("short-long")!,target: 20)
    var duration = 3.0
    var step = 20.0
    var startVal = 20.0
    var endVal = 60.0
    var underRange = 10.0
    var aboveRange = 10.0
    var target = 20.0
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(patternObject)
        hasher.combine(name)
        hasher.combine(duration)
        hasher.combine(step)
        hasher.combine(startVal)
        hasher.combine(endVal)
        hasher.combine(underRange)
        hasher.combine(aboveRange)
    }
    
    init(){
        self.name = "Step"
        self.patternObject = Pattern(underPattern: MadePatternsList.getPatternByName("super pulse")!, atPattern: MadePatternsList.getPatternByName("heartbeat")!, abovePattern:  MadePatternsList.getPatternByName("short-long")!,target: 20)
        self.duration = 3.0
        self.step = 20.0
        self.startVal = 20.0
        self.endVal = 60.0
        self.underRange = 10.0
        self.aboveRange = 10.0
        self.target = 20.0
    }
    
    init(name: String, patternObject: Pattern, duration: Double, step: Double, startVal: Double, endVal: Double, underRange: Double, aboveRange: Double, target: Double){
        self.name = name
        self.patternObject = patternObject
        self.duration = duration
        self.step = step
        self.startVal = startVal
        self.endVal = endVal
        self.underRange = underRange
        self.aboveRange = aboveRange
        self.target = target
    }
    
    func encoder() -> Data{
        let data = try! PropertyListEncoder.init().encode(self)
        print("encoding test...")
        return data
    }
    
    static func decoder(_ data: Data) -> Test {
        print("decoding test...")
        let test:Test?
        
        do{
            test = try PropertyListDecoder.init().decode(Test.self, from: data)
        }catch{
            test = TestList.getTestByName("ERROR")
        }
        return test!
    }
}

class TestList : Identifiable, Codable, ObservableObject{
    static var tests:[Test] = [
        Test(name: "Step", patternObject: Pattern(underPattern: MadePatternsList.getPatternByName("super pulse")!, atPattern: MadePatternsList.getPatternByName("heartbeat")!, abovePattern: MadePatternsList.getPatternByName("short-long")!,target: 120), duration: 3,
             step: 20, startVal: 20, endVal: 60, underRange: 10, aboveRange: 10, target: 20),
        Test(name: "Endurance", patternObject: Pattern(underPattern: MadePatternsList.getPatternByName("super pulse")!, atPattern: MadePatternsList.getPatternByName("heartbeat")!, abovePattern: MadePatternsList.getPatternByName("short-long")!,target: 120), duration: 10,
             step: 0, startVal: 60, endVal: 60, underRange: 10, aboveRange: 10, target: 20),
        Test(name: "Pyramid", patternObject: Pattern(underPattern: MadePatternsList.getPatternByName("super pulse")!, atPattern: MadePatternsList.getPatternByName("heartbeat")!, abovePattern: MadePatternsList.getPatternByName("short-long")!,target: 120), duration: 3,
             step: 10, startVal: 20, endVal: 60, underRange: 10, aboveRange: 10, target: 20),
    ]
    
    static func getTestByName(_ name: String) -> Test? {
        return tests.first(where: {$0.name == name});
    }
}
