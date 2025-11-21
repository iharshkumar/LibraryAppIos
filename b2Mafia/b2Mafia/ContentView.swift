//
//  ContentView.swift
//  b2Mafia
//
//  Created by BATCH01L1-15 on 21/11/25.
//

import SwiftUI
struct ContentView: View {
    @State var x : Double = 0.1
    var body: some View {
        VStack(){
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button {
                print("buotton")
            }label: {
                Text("tapatap")
            }
        }
        TextField("enter text",text: .constant(""))
            .textFieldStyle(.roundedBorder)
        Image(systemName: "star.circle")
            .imageScale(.large)
            .foregroundStyle(.tint)
        Slider(value: $x, in:0...1)
            .tint(.green)
        
        Toggle("Enable feature",isOn: .constant(true))
            
            .padding()
        
    }
    
}

#Preview {
    ContentView()
}
