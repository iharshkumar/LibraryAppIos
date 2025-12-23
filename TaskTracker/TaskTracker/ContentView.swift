import SwiftUI
import SwiftData

@Model
class Task {
    var title: String
    var isCompleted: Bool
    
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var newTaskTitle: String = ""
    @Query var tasks: [Task]
    
    var body: some View {
       // VStack {
            //NavigationView {
                VStack {
                    HStack {
                        TextField("Enter new task", text: $newTaskTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: addTask) {
                            Text("Add")
                        }
                    }
                    
                    List {
                        ForEach(tasks) { task in
                            HStack {
                                Text(task.title)
                                Spacer()
                                
                                if task.isCompleted {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                } else {
                                    Button("Done") {
                                        markCompleted(task)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteTask)
                    }
               // }
           // }.navigationTitle("Tasks")
        }
        .padding()
    }
    
    func addTask() {
        if !newTaskTitle.isEmpty {
            modelContext.insert(Task(title: newTaskTitle))
            try? modelContext.save()
            newTaskTitle = ""
        }
    }
    
    func markCompleted(_ task: Task) {
        task.isCompleted.toggle()
        try? modelContext.save()
    }
    
    func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let task = tasks[index]
            modelContext.delete(task)
        }
        try? modelContext.save()
    }
}

#Preview {
    ContentView()
}
