//
//  PlayOnWatch.swift
//  v2-watch Watch App
//
//  Created by Alice Mao on 2/24/24.
//

import Foundation


class PlayOnWatch {
//    @Published var connector = ConnectToWatch.connect
    
//    @Published var currPattern:MadePattern = MadePattern()
//    
//    @Published var end:Bool = true
    var end:Bool = false
    
    func EndAll(){
        self.end = true
    }
    
    func playOnWatch(pattern:MadePattern){
        print("play")
            if pattern.HapticArray.count == 0{
                return
            }
            
            var index = 0
            Timer.scheduledTimer(withTimeInterval: pattern.duration, repeats: true) { timer in
                
                // Contitions to end timer
                if self.end{
                    timer.invalidate()
                    self.end = true
                    return
                }
          
                let currHaptic = pattern.HapticArray[index % pattern.HapticArray.count]
                Haptics.play(currHaptic: currHaptic)
                index += 1
            }
        }
    
}
