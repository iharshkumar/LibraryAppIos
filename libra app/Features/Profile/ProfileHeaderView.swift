import SwiftUI

struct ProfileHeaderView: View {
    var body: some View {
        HStack(spacing: 16) {

            Circle()
                .fill(Color.blue)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 34))
                )

            VStack(alignment: .leading, spacing: 6) {
                Text("Harsh Kumar")
                    .font(.title3)
                    .bold()

                Text("Student ID: 23CS420")
                    .foregroundColor(.gray)

                Text("harsh.kumar@college.edu")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}
