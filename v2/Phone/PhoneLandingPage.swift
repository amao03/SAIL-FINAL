//
//  Phone-Landing-Page.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import Foundation
import SwiftUI

struct Phone_Landing_View : View{
//    @State var pairedDevice:PerformanceMonitor
//    var pairedDevice:PerformanceMonitor?
//    @ObservedObject var connector = ConnectToWatch.connect
//    @State var deviceArr:Array<PerformanceMonitor>
    @State var timer = CreateTimer().connector
    @State var pm:FetchData
    @State var patternObject = Pattern()
    @State private var realData:Bool = false
    @State private var randomData:Bool = false
    
    @State private var hapticsListBool:Bool = false
    
    var body: some View {
        VStack{
            NavigationView{
                Form{
//                    Toggle("Real data", isOn: $realData)
//                    Toggle("Random data", isOn: $randomData)
//                    HStack{
//                        Text("Target")
//                        TextField("",value: $patternObject.target, format: .number).multilineTextAlignment(.trailing)
//                    }
                    
//                    HStack{
//                        Text("Range")
//                        TextField("",value: $patternObject.range, format: .number).multilineTextAlignment(.trailing)
//                    }
//                    
//                    Section("Under Pattern", content: {
//                        NavigationLink(destination: {
//                            MadeHapticsSelector(selectedItems: $patternObject.underPattern)
//                        }, label: {
//                            Text("Select haptics")
//                        })
//                        Text("**Selected:** \(patternObject.underPattern.name)")
//                        Text("**Description:** \(patternObject.underPattern.description)")
//                    })
                    
//                    Section("At Pattern", content: {
//                        NavigationLink(destination: {
//                            MadeHapticsSelector(selectedItems: $patternObject.atPattern)
//                        }, label: {
//                            Text("Select haptics")
//                        })
//                        Text("**Selected:** \(patternObject.atPattern.name)")
//                        Text("**Description:** \(patternObject.atPattern.description)")
//                    })
                    
//                    Section("Above Pattern", content: {
//                        NavigationLink(destination: {
//                            MadeHapticsSelector(selectedItems: $patternObject.abovePattern)
//                        }, label: {
//                            Text("Select haptics")
//                        })
//                        Text("**Selected:** \(patternObject.abovePattern.name)")
//                        Text("**Description:** \(patternObject.abovePattern.description)")
//                    })
                    
//                    Section("Overall Time", content: {
//                        HStack{
//                            Text("Between each pattern")
//                            TextField("",value: $patternObject.timeOverall, format: .number).multilineTextAlignment(.trailing)
//                        }
//                    })
                    
                    Button(action:{
//                        pm.getPower()
//                        timer.startTimer(patternObject: patternObject, realData: realData, randomData: randomData)
                    }){
                        Text("Start")
                    }
                    
                }
            }

//            .navigationTitle("Custom Haptics")
        }
    }
}
