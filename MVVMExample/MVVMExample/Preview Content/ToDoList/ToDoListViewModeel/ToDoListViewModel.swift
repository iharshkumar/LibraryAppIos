//
//  ToDoListViewModel.swift
//  MVVMExample
//
//  Created by BATCH01L1-15 on 12/12/25.
//
import Combine
import SwiftUI
import Foundation
class ToDoListViewModel: ObservableObject {
    @Published var todoitems: [ToDoListModel] = [ToDoListModel(title: "but grocery"),
                                                ToDoListModel(title: "walk the dog"),
                                                ToDoListModel(title: "read a book")
    ]
    func addTodoitem(_ title: String){
        let newItem = ToDoListModel(title: title)
        todoitems.append(newItem)
    }
    func deleteTodoitem(_ indexSet: IndexSet){
        todoitems.remove(atOffsets: indexSet)
    }
    func toggleCompletion(for item: ToDoListModel){
        if let index = todoitems.firstIndex(where: {$0.id == item.id}){
            todoitems[index].isCompleted.toggle()
        }
    }
}
