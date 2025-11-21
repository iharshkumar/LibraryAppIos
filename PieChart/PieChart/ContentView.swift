//
//  ContentView.swift
//  PieChart
//
//  Created by BATCH01L1-15 on 21/11/25.
//

import SwiftUI

import Charts
struct PieSlice: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
}


struct ContentView: View {
    let pieSlices: [PieSlice] = [
        PieSlice(category: "A", value: 100),
        PieSlice(category: "B", value: 30),
        PieSlice(category: "C", value: 20),
        PieSlice(category: "D", value: 55),
        PieSlice(category: "F", value: 50),
        PieSlice(category: "G", value: 10),
    ]
    var body: some View {
        VStack {
            Chart{
                ForEach(pieSlices){ slice in
                    SectorMark(angle: .value("Value", slice.value),
                               innerRadius: .ratio(0.5),
                               outerRadius: .ratio(1.0)
                    ).foregroundStyle(by:
                            .value("Category", slice.category))
                    .annotation(position: .overlay){
                        Text(slice.category)
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
