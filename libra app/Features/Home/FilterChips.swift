import SwiftUI

struct FilterChips: View {
    @Binding var selected: BookStatus?

    let filters: [BookStatus?] = [nil, .available, .borrowed, .reserved]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(filters, id: \.self) { filter in
                    Text(filter?.rawValue ?? "All")
                        .fontWeight(.medium)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selected == filter ? Color.blue : Color(.systemGray5))
                        .foregroundColor(selected == filter ? .white : .gray)
                        .cornerRadius(20)
                        .onTapGesture {
                            withAnimation {
                                selected = filter
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}
