import SwiftUI

struct ScannerView: View {

    @StateObject private var vm = ScannerViewModel()
    @State private var animateLine = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {

                Spacer()

                // MARK: - Scanner Frame
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 260, height: 260)

                    // Scanning Line Animation
                    Rectangle()
                        .fill(Color.green.opacity(0.8))
                        .frame(width: 220, height: 2)
                        .offset(y: animateLine ? 110 : -110)
                        .animation(
                            .easeInOut(duration: 1.6).repeatForever(autoreverses: false),
                            value: animateLine
                        )
                }
                .onAppear {
                    animateLine = true
                }

                // MARK: - Instruction
                VStack(spacing: 8) {
                    Text("Scan Book Barcode")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("Align the barcode inside the frame")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // MARK: - Scan Button
                Button {
                    withAnimation(.spring()) {
                        vm.scannedCode = "9780134610610"
                    }
                } label: {
                    HStack {
                        Image(systemName: "barcode.viewfinder")
                        Text("Start Scanning")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(18)
                }
                .padding(.horizontal)

                // MARK: - Result Card
                if !vm.scannedCode.isEmpty {
                    VStack(spacing: 6) {
                        Text("Scanned Code")
                            .font(.caption)
                            .foregroundColor(.gray)

                        Text(vm.scannedCode)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Scanner")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
