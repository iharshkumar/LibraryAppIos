//
//  ContentView.swift
//  AreaDataCharts
//
//  Created by BATCH01L1-15 on 21/11/25.
//

import SwiftUI
import Charts
struct AreaChartData: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
}

struct ContentView: View {
    
    let data: [AreaChartData] = [
        AreaChartData(category: "A", value: 10),
        AreaChartData(category: "B", value: 30),
        AreaChartData(category: "C", value: 20),
        AreaChartData(category: "t", value: 500),
        AreaChartData(category: "D", value: 550),
        AreaChartData(category: "u", value: 500),
        AreaChartData(category: "e", value: 20),
        AreaChartData(category: "F", value: 30),
        AreaChartData(category: "G", value: 10),
    ]
    
    var body: some View {
        VStack {
            Chart(data){
                data in
                AreaMark(x: .value("Category",data.category),
                         y: .value("Value", data.value))
                .foregroundStyle(Gradient(colors:
                            [Color.yellow.opacity(0.6),
                            Color.orange.opacity(0.5)
                                                
                                            ]))
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
