//
//  Select_Patterns.swift
//  sail-v1
//
//  Created by Alice Mao on 12/8/23.
//

import Foundation
import SwiftUI

struct SetUpTest:View{
    @Binding var selectedItems: Test
    
    @State var hapticString: String = ""
    
    var body: some View{
        VStack{
            Form{
                Section("Test", content: {
                    List{
                        ForEach(TestList.tests) { haptic in
                            Button(action: {
                                withAnimation{
                                    if self.selectedItems == haptic{
                                        self.selectedItems = Test()
                                    } else{
                                        self.selectedItems = haptic
                                    }
                                }
                            }) {
                                HStack{
                                    Text("\(haptic.name)")
                                    Spacer()
                                    if self.selectedItems == haptic{
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    }
                })
            }
            .navigationTitle("Choose Test")
        }
    }
}

