//
//  TaskTrackerApp.swift
//  TaskTracker
//
//  Created by BATCH01L1-15 on 11/12/25.
//

import SwiftUI
import SwiftData
@main
struct TaskTrackerApp: App {
    var body: some Scene {
        let container: ModelContainer = try! ModelContainer(for: Task.self)
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
