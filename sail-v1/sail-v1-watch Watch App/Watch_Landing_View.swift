//
//  Watch_Landing_page.swift
//  sail-v1-watch Watch App
//
//  Created by Alice Mao on 12/8/23.
//

import Foundation
import SwiftUI
import HealthKit
import WatchKit

struct Watch_Landing_View : View {
    @ObservedObject var connector = ConnectToWatch.connect
    @ObservedObject var timerObj = TimerControls.time
    @State private var authorize: Bool = false
    
    @State var animationState: AnimationState = AnimationState.at
    
    @State private var animationAmount = 1.0;
    @State private var animationDuration = 1.0;
    
    private func update(){
        print("updating timer")
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false){ timer in
            connector.updating = false
            timer.invalidate()
        }
    }
    
    private func authorizeHealthKit(){
        print("authorizing....")
        
        HealthKitData.authorizeHealthKit(){ (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed - Watch"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            authorize = true
            print("HealthKit Successfully Authorized - Watch")
        }
    }
    
    private func printVal(){
        print("reciev: \(connector.receivedInitial)")
    }
    
    var body: some View {
        NavigationView{
            VStack{
                if !authorize{
                    Text("need to authorize healthkit")
                }
                else if !connector.receivedInitial{
                    Text("awaiting info from phone")
                } else{
                    ScrollView{
                        VStack{
                            if connector.updating{
                                let _ = self.update()
                                Text("updating...")
                            }
                            NavigationLink(destination: DisplayInfo(currTest: connector.test)){
                                Text("View Patterns")
                            }
                            if timerObj.end{
                                Button(action:{
                                    print("starting....")
                                    timerObj.toggleEnd()
                                    timerObj.startOverallTimer()
                                }){
                                    Text("Start")
                                }
                            }
                            else{
                                Button(action:{
                                    timerObj.toggleEnd()
                                    print("stopping")
                                }){
                                    Text("stop")
                                }
                                ZStack{
                                    IndicatorView(animationState: timerObj.colorState)
                                    Text("\(timerObj.currentData, specifier: "%.2f")")
                                }
                                
                            }
                        }
                    }
                    
                }
            }
        }.onAppear(perform: authorizeHealthKit)
    }
}
