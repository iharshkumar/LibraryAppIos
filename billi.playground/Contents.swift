import Cocoa
import CreateML
import Foundation

let traingUrl = URL(fileURLWithPath:"/Users/batch01l1-15/Downloads/DataSet/Training")
let testUrl = URL(fileURLWithPath:"/Users/batch01l1-15/Downloads/DataSet/Testing")
print("Training Started")
let model = try MLImageClassifier(trainingData: .labeledDirectories(at: traingUrl))
print("traning in progress")
let evaluation = model.evaluation(on: .labeledDirectories(at: testUrl))

print("traning completed")

try model.write(to: URL(fileURLWithPath: "/Users/batch01l1-15/Downloads/DataSet/kutta aur billiClassifier.mlmodel"))
