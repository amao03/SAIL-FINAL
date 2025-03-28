//
//  Phone-Landing-Page.swift
//  sail-v1
//
//  Created by Alice Mao on 12/7/23.
//

import Foundation
import SwiftUI

struct Phone_Landing_View : View{
    var connector = ConnectToWatch.connect
    @State var currTest = Test()
    
    @State private var hapticsListBool:Bool = false
    
    @ObservedObject var compass = Compass()
    @State var currPower = 0
    
    @State var concept2monitor:PerformanceMonitor?
    @ObservedObject var fetchData = FetchData()
    var fetching = FetchData.sharedInstance
    @State var powerDisposable: Disposable? = nil
    
    
    var hasConnectedRower: Bool {
        return concept2monitor != nil;
    }
    
    private func attachObservers(){
        
        if(hasConnectedRower) {
            
            //            self.concept2monitor = concept2monitor
            print("not nill")
            powerDisposable = concept2monitor!.strokePower.attach(observer: {
                (currPow:C2Power) -> Void in
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        currPower = currPow
                    }
                }
            })
        }
        print("no rower")
        
        
    }
    
    
    var body: some View {
        NavigationView{
            Form{
                Picker("select type", selection: $currTest.patternObject.type) {
                    ForEach(DataType.allCases, id: \.self) { currCase in
                        Text(String(describing: currCase))
                    }
                }
                
                if currTest.patternObject.type == DataType.rower{
                    BluetoothView(concept2monitor: $concept2monitor)
                }
                
                Section("Select Test", content: {
                    NavigationLink(destination: {
                        SetUpTest(selectedItems: $currTest)
                    }, label: {
                        Text("Select Test")
                    })
                    Text("**Selected:** \(currTest.name)")
                })
                
                Section("Test Configs", content: {
                    HStack{
                        Text("Starting threshold")
                        TextField("starting value",value: $currTest.startVal, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack{
                        Text("End threshold")
                        TextField("End value",value: $currTest.endVal, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    HStack{
                        Text("Step")
                        TextField("step",value: $currTest.step, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    HStack{
                        Text("Duration between steps")
                        TextField("duration",value: $currTest.duration, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    HStack{
                        Text("Target")
                        TextField("duration",value: $currTest.target, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                 
                    
                })
                
                Section("Above Pattern", content: {
                    NavigationLink(destination: {
                        MadeHapticsSelector(selectedItems: $currTest.patternObject.abovePattern)
                    }, label: {
                        Text("Select haptics")
                    })
                    Text("**Selected:** \(currTest.patternObject.abovePattern.name)")
                    Text("**Description:** \(currTest.patternObject.abovePattern.description)")
                })
                
                Section("At Pattern", content: {
                    HStack{
                        Text("Above range")
                        TextField("duration",value: $currTest.aboveRange, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    Spacer()
                    NavigationLink(destination: {
                        MadeHapticsSelector(selectedItems: $currTest.patternObject.atPattern)
                    }, label: {
                        Text("Select haptics")
                    })
                    Text("**Selected:** \(currTest.patternObject.atPattern.name)")
                    Text("**Description:** \(currTest.patternObject.atPattern.description)")
                    Spacer()
                    HStack{
                        Text("Under range")
                        TextField("duration",value: $currTest.underRange, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                })
                
                Section("Under Pattern", content: {
                    NavigationLink(destination: {
                        MadeHapticsSelector(selectedItems: $currTest.patternObject.underPattern)
                    }, label: {
                        Text("Select haptics")
                    })
                    Text("**Selected:** \(currTest.patternObject.underPattern.name)")
                    Text("**Description:** \(currTest.patternObject.underPattern.description)")
                })
                
                if (!hasConnectedRower && currTest.patternObject.type == DataType.rower){
                    Text("Connect to Rower")
                }else{
                    Button(action:{
                        connector.sendDataToWatch(sendObject: currTest)
//                        connector.sendDataToWatch(sendObject: currTest.patternObject)
                    }){
                        Text("Send data to Watch")
                    }
                }
                
                if currTest.patternObject.type == DataType.altitude{
                    Text("Your altitude is \(self.compass.altitude)")
                        .font(.headline)
                        .padding()
                    
                    let data:[String:Any] = ["altitude":self.compass.altitude]
                    let _ = connector.session.sendMessage(data, replyHandler: nil)
                }
                
                if currTest.patternObject.type == DataType.direction {
                    Text("Your direction is \(self.compass.direction)")
                        .font(.headline)
                        .padding()
                    
                    let _ = connector.sendDirection(sendObject: self.compass.direction)
                }
                
                if (currTest.patternObject.type == DataType.rower){
                    Text("Your power is \(fetching.strokePower)")
                        .font(.headline)
                        .padding()
                }
            }
            .navigationTitle("Custom Haptics")
        }.onAppear(perform: connector.activateSession)
    }
    
    
}


