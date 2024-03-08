//
//  PatternSelectorView.swift
//  v2
//
//  Created by Alec Anderson on 3/1/24.
//
import SwiftUI
import Foundation
struct PatternSelectorView: View {
    @ObservedObject var connector = ConnectToWatch.connect
    @Binding var abovePattern: MadePattern
    @Binding var atPattern: MadePattern
    @Binding var belowPattern: MadePattern
    
    var body: some View {
        Section {
            Picker("Above Pattern:", selection: $abovePattern) {
                ForEach(MadePatternsList.madePatternsList) { haptic in
                    Text(haptic.name)
                }
            }
            Picker("At Pattern:", selection: $atPattern) {
                ForEach(MadePatternsList.madePatternsList) { haptic in
                    Text(haptic.name)
                }
            }
            Picker("Below Pattern:", selection: $belowPattern) {
                ForEach(MadePatternsList.madePatternsList) { haptic in
                    Text(haptic.name)
                }
            }
            Button(action:{
                connector.sendDataToWatch(sendObject: abovePattern)
            }){
                Text("Play Above Pattern")
            }
            
            Button(action:{
                connector.sendDataToWatch(sendObject: atPattern)
            }){
                Text("Play At Pattern")
            }
            
            Button(action:{
                connector.sendDataToWatch(sendObject: belowPattern)
            }){
                Text("Play Below Pattern")
            }
            
        }
    }
}
