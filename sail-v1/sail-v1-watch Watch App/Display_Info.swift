//
//  Display_INfo.swift
//  sail-v1-watch Watch App
//
//  Created by Alice Mao on 12/8/23.
//

import Foundation
import Foundation
import SwiftUI

struct DisplayInfo:View{
     var currTest:Test!
    
    var body: some View{
        ScrollView{
            VStack(alignment: .leading){
                Text("**Test:** \(currTest.name)")
                Group{
                    Text("**Above Pattern:** \n \(currTest.patternObject.abovePattern.description)")
                    Spacer()
                    Text("**At Pattern:** \n \(currTest.patternObject.atPattern.description)")
                    Spacer()
                    Text("**Under Pattern:** \n \(currTest.patternObject.underPattern.description)")
                }
                Spacer()
                Text("**Type:** \(currTest.patternObject.type)")
                Text("**Start Val:** \(String(format: "%.2f", currTest.startVal))")
                Text("**End Val:** \(String(format: "%.2f", currTest.endVal))")
                Text("**Step:** \(String(format: "%.2f", currTest.step))")
                Text("**Duration:** \(String(format: "%.2f", currTest.duration))")
                Text("**Under:** \(String(format: "%.2f", currTest.underRange))")
                Text("**Above:** \(String(format: "%.2f", currTest.aboveRange))")
            }
        }
    }
}

 
