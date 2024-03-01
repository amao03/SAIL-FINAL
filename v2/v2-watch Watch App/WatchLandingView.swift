//
//  Watch_Landing_page.swift
//  sail-v1-watch Watch App
//
//  Created by Alice Mao on 12/8/23.
//

import Foundation
import SwiftUI
import HealthKit

struct Watch_Landing_View : View {
    @ObservedObject var connector = ConnectToWatch.connect
    @ObservedObject var timerObj = PlayHapticOnWatch.time
    @State private var authorize: Bool = false
    @State private var realData:Bool = false
    @State private var randomData:Bool = false
    
    @State private var endTime:Bool = false
    
   private var backgroundColor = Color.black

    private func update(){
        print("updating timer")
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false){ timer in
                ConnectToWatch.connect.updating = false
                timer.invalidate()
        }
        endTime = true
        playOnWatch()
    }
    
    private func playOnWatch(){
        print("playing timer")
        var index = 0
        Timer.scheduledTimer(withTimeInterval: ConnectToWatch.connect.pattern.duration, repeats: true){ timer in
                if endTime {
                    print("end curr timer")
                    timer.invalidate()
                    endTime = false
                    ExtendedSession().stopExtendedSession()
                    return
                }
            
            
                ConnectToWatch.connect.updating = false
            
            let currHaptic = connector.pattern.HapticArray[index % connector.pattern.HapticArray.count]
            Haptics.play(currHaptic: currHaptic)
            index += 1
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                if ConnectToWatch.connect.receivedInitial{
                    ScrollView{
                        VStack{
                            let _ = self.update()
                            if ConnectToWatch.connect.updating{
                                let _ = self.update()
                                Text("updating...")
                            }
                            Toggle("Real data", isOn: $realData)
                            Toggle("Random data", isOn: $randomData)
                            Text("**Pattern:** \n \(connector.pattern.description)")
                                
                            Text("currData: \(timerObj.currentData, specifier: "%.2f")")
                        }
                    }
                }
                else{
                    Text("awaiting info from phone")
                }
            }
        }
      
    }
}

