//
//  ContentView.swift
//  LineChart
//
//  Created by BATCH01L1-15 on 21/11/25.
//

import SwiftUI
import Charts
struct DataPoint: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
}

struct ContentView: View {
    
    let data: [DataPoint] = [
        DataPoint(category: "A", value: 10),
        DataPoint(category: "B", value: 30),
        DataPoint(category: "C", value: 20),
        DataPoint(category: "D", value: 40),
        DataPoint(category: "E", value: 100),
        DataPoint(category: "F", value: 40),
        DataPoint(category: "G", value: 70)

    ]
    
    var body: some View {
        VStack {
            Chart(data){
                data in
                LineMark(x: .value("Category",data.category),
                         y: .value("Value", data.value))
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
