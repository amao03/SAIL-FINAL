//
//  PlayHapticOnWatch.swift
//  v2
//
//  Created by Alice Mao on 2/9/24.
//

import Foundation
import SwiftUI

class PlayHapticOnWatch: NSObject, ObservableObject{
    static let time = PlayHapticOnWatch()
    
    @Published var end:Bool = true
    
    @Published var patternObject:MadePattern = MadePattern()
    @Published var currentData = 160.0
    
    @ObservedObject var ExtendedSess = ExtendedSession()
    
    
    // Deals with stopping timer early and displaying start/stop button
    public func toggleEnd(){
        print("toggle end \(end)")
        self.end = !end
    }
    
    
    // Sets patternObject to a given Pattern
    public func setPattern(pattern: MadePattern){
        self.patternObject = pattern
        print("set pattern: \(pattern)")
    }
}
