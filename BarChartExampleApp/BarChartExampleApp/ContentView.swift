//
//  ContentView.swift
//  BarChartExampleApp
//
//  Created by BATCH01L1-15 on 21/11/25.
//

import SwiftUI
import Charts
struct BarData: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
}
struct ContentView: View {
    let data: [BarData] = [
        BarData(category: "A", value: 10),
        BarData(category: "B", value: 30),
        BarData(category: "C", value: 20),
        BarData(category: "D", value: 40),
        BarData(category: "E", value: 100),
        BarData(category: "F", value: 40),
        BarData(category: "G", value: 40)

    ]
    var body: some View {
        VStack {
            Text("Simple Bar Chart")
                .font(.title).padding()
            Chart(data) { item in
                BarMark(x: .value("Category", item.category),
                        y: .value("Value", item.value))
                .foregroundStyle(by:
                        .value("Category", item.category))
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
