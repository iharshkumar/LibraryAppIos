//
//  TodoListView.swift
//  MVVMExample
//
//  Created by BATCH01L1-15 on 12/12/25.
//

import SwiftUI
struct TodoListView: View {
    @ObservedObject var viewModel = ToDoListViewModel()
    @State private var newTodoTitle: String = ""
    
    var body: some View {
        TextField("New TODO",text: $newTodoTitle)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        Button("Add ToDo"){
            viewModel.addTodoitem(newTodoTitle)
            newTodoTitle = ""
            }
        List{
            ForEach(viewModel.todoitems){ item in
                HStack{
                    Text(item.title)
                        .strikethrough(item.isCompleted,color: .black)
                    Spacer()
                    Button(action: {
                        viewModel.toggleCompletion(for: item)
                    }){
                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    }
                }}
            .onDelete(perform: viewModel.deleteTodoitem)
        }
    }
}
#Preview {
    TodoListView()
}

