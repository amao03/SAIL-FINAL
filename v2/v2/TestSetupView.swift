//
//  TestSetupView.swift
//  v2
//
//  Created by Lucas Drummond on 2/26/24.
//
import SwiftUI


struct TestSetupView: View {
    @Binding var subjectId: String
    @Binding var protocolName: ProtocolNames
    var hasActiveTest: Bool
    
    var body: some View {
        Section {
            TextField(
                "Subject ID*",
                text: $subjectId
            )
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .disabled(hasActiveTest)
            
            Picker("Protocol:", selection: $protocolName) {
                ForEach(ProtocolNames.allCases) { name in
                    Text(name.rawValue.capitalized)
                }
            }
            .disabled(hasActiveTest)
    

        } header: {
            Text("Test Setup")
        } footer: {
//            if(subjectId.isEmpty) {
//                Text("Subject ID is required to start a test")
//                    .foregroundColor(.blue)
//            }
        }
        .opacity(!hasActiveTest ? 1 : 0.5)
        
    }
}
