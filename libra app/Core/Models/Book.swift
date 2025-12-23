import Foundation

enum BookStatus: String {
    case available = "Available"
    case borrowed = "Borrowed"
    case reserved = "Reserved"
}

struct Book: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let author: String
    let category: String
    let imageName: String
    let status: BookStatus
}
