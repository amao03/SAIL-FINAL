//
//  Made_Patterns.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import Foundation
import SwiftUI

struct MadePattern: Hashable, Identifiable, Codable{
    var name: String = ""
    var id: Self { self } //changed 03/07/24  from id: String{ name} to id: Self { self } to make it usable with a Picker in PatternSelectorView and ContentView
    var HapticArray: [Haptics] = []
    var duration: Double = 0.5
    var description:String = ""

    // Converts a Pattern to a Data object to be sent to watch
    func encoder() -> Data{
        let data = try! PropertyListEncoder.init().encode(self)
        print("encoding...")
        return data
    }
    
    
    // Converts Data from phone to a Pattern object
    static func decoder(_ data: Data) -> MadePattern {
        let pattern = try! PropertyListDecoder.init().decode(MadePattern.self, from: data)
        print("decoding...")
        
        return pattern
    }
}

struct MadePatternsList{
    static var madePatternsList:[MadePattern] = [
        MadePattern(name: "short-long", HapticArray: [Haptics(name: "notification", type: "watch")], duration: 0.5,
                    description: "-  ———  -  ———  -"),
        MadePattern(name:"short-short-long", HapticArray: [Haptics(name: "notification", type: "watch"), Haptics(name: "directionUp", type: "watch")], duration: 0.3,
                    description: "- -  ———  - -  ———"),
        MadePattern(name:"heartbeat", HapticArray: [Haptics(name: "directionUp", type: "watch")], duration: 0.5,
                    description: "--       --       --        --"),
        MadePattern(name:"long heartbeat", HapticArray: [Haptics(name: "directionUp", type: "watch")], duration: 1,
                    description: "--       --       --        --"),
        MadePattern(name:"pulse", HapticArray: [Haptics(name: "directionUp", type: "watch")], duration: 0.1,
                    description: "-  -  -  -  -  -  -  -  -  -  - "),
        MadePattern(name:"long pulse", HapticArray: [Haptics(name: "directionUp", type: "watch")], duration: 0.3,
                    description: "-    -    -    -    -    -    -    - "),
        MadePattern(name:"super pulse", HapticArray: [Haptics(name: "directionUp", type: "watch")], duration: 0.01,
                    description: "-----------------------"),
    ]
    
    static func getPatternByName(_ name: String) -> MadePattern? {
        return madePatternsList.first(where: {$0.name == name});
    }
}

