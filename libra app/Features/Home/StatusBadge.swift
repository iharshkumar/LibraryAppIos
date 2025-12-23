import SwiftUI

struct StatusBadge: View {
    let status: BookStatus

    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(8)
    }

    private var backgroundColor: Color {
        switch status {
        case .available: return Color.green.opacity(0.2)
        case .borrowed: return Color.red.opacity(0.2)
        case .reserved: return Color.orange.opacity(0.2)
        }
    }

    private var textColor: Color {
        switch status {
        case .available: return .green
        case .borrowed: return .red
        case .reserved: return .orange
        }
    }
}
