//
//  ToDoListModel.swift
//  MVVMExample
//
//  Created by BATCH01L1-15 on 12/12/25.
//

import Foundation
struct ToDoListModel: Identifiable {
    var id: UUID = UUID()
    var title: String
    var isCompleted: Bool = false 
}
