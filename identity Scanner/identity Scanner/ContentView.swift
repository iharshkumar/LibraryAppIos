//
//  ContentView.swift
//  IDCardExtractor
//
//  Created by You on 22/11/25.
//

import SwiftUI
import PhotosUI
import Vision

struct ContentView: View {
    
    @State private var selectedImage: PhotosPickerItem?
    @State private var uiImage: UIImage?
    @State private var extractedText: String = ""
    
    // Extracted fields
    @State private var name: String = ""
    @State private var dob: String = ""
    @State private var idNumber: String = ""
    @State private var address: String = ""
    @State private var gender: String = ""
    
    @State private var isEditing = false
    @State private var showScanAnimation = false
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                // BEAUTIFUL BACKGROUND
                LinearGradient(colors: [.purple.opacity(0.25),
                                        .indigo.opacity(0.25),
                                        .blue.opacity(0.25)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        // TITLE WITH ANIMATION
                        Text("🔍 Smart ID Scanner")
                            .font(.largeTitle.bold())
                            .foregroundStyle(LinearGradient(colors: [.purple, .indigo], startPoint: .leading, endPoint: .trailing))
                            .shadow(radius: 5)
                            .padding(.top)
                            .scaleEffect(showScanAnimation ? 1.05 : 1)
                            .animation(.easeInOut(duration: 1).repeatForever(), value: showScanAnimation)
                        
                        
                        // --------------------------
                        // ID IMAGE PREVIEW UPLOAD
                        // --------------------------
                        VStack(spacing: 15) {
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.15), radius: 8)
                                    .frame(height: 230)
                                
                                if let uiImage {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 220)
                                        .cornerRadius(16)
                                        .shadow(radius: 10)
                                        .overlay(scanOverlay)
                                        .animation(.easeInOut, value: uiImage)
                                } else {
                                    VStack(spacing: 12) {
                                        Image(systemName: "idcard")
                                            .font(.system(size: 50))
                                            .foregroundColor(.purple)
                                        
                                        Text("Upload ID Card")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            
                            PhotosPicker("Select ID Image",
                                         selection: $selectedImage,
                                         matching: .images)
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .tint(.purple)
                            .onChange(of: selectedImage) { _ in loadImage() }
                            
                        }
                        
                        
                        // --------------------------
                        // EXTRACTED DETAILS SECTION
                        // --------------------------
                        if extractedText.isEmpty == false {
                            
                            VStack(alignment: .leading, spacing: 20) {
                                
                                HStack {
                                    Text("🧾 Extracted Details")
                                        .font(.title3.bold())
                                    
                                    Spacer()
                                    
                                    Button(isEditing ? "Save" : "Edit") {
                                        withAnimation { isEditing.toggle() }
                                    }
                                    .foregroundColor(.blue)
                                }
                                
                                detailField("Name", text: $name, icon: "person.crop.circle", editable: isEditing)
                                detailField("Date of Birth", text: $dob, icon: "calendar", editable: isEditing)
                                detailField("ID Number", text: $idNumber, icon: "number.square", editable: isEditing)
                                detailField("Gender", text: $gender, icon: "figure.stand", editable: isEditing)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("Address", systemImage: "house.fill")
                                        .font(.headline)
                                    
                                    if isEditing {
                                        TextEditor(text: $address)
                                            .frame(height: 80)
                                            .padding(8)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(10)
                                    } else {
                                        Text(address.isEmpty ? "—" : address)
                                            .padding(10)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(10)
                                    }
                                }
                                
                            }
                            .padding()
                            .background(.white)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.1), radius: 8)
                        }
                        
                        
                        // --------------------------
                        // RAW OCR TEXT
                        // --------------------------
                        if extractedText.isEmpty == false {
                            VStack(alignment: .leading) {
                                Text("📜 Raw OCR Text")
                                    .font(.headline)
                                
                                Text(extractedText)
                                    .font(.footnote)
                                    .padding()
                                    .background(Color(.systemGray5))
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal)
                        }
                        
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            showScanAnimation = true
        }
    }
    
    
    // --------------------------
    // SCANNING LINE OVERLAY
    // --------------------------
    var scanOverlay: some View {
        LinearGradient(colors: [.clear, .purple.opacity(0.4), .clear],
                       startPoint: .top,
                       endPoint: .bottom)
            .frame(height: 8)
            .offset(y: showScanAnimation ? 90 : -90)
            .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: showScanAnimation)
    }
    
    
    // --------------------------
    // STYLIZED FIELD COMPONENT
    // --------------------------
    func detailField(_ title: String, text: Binding<String>, icon: String, editable: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: icon)
                .font(.headline)
            
            if editable {
                TextField("Enter \(title)", text: text)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            } else {
                Text(text.wrappedValue.isEmpty ? "—" : text.wrappedValue)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
        }
    }
    
    
    // --------------------------
    // OCR LOGIC
    // --------------------------
    func extractText(from image: UIImage) {
        
        guard let cg = image.cgImage else { return }
        
        let request = VNRecognizeTextRequest { req, _ in
            guard let results = req.results as? [VNRecognizedTextObservation] else { return }
            
            let fullText = results.compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            
            DispatchQueue.main.async {
                self.extractedText = fullText
                self.extractDetails(from: fullText)
            }
        }
        
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cg, options: [:])
        DispatchQueue.global().async {
            try? handler.perform([request])
        }
    }
    
    
    // --------------------------
    // SMART FIELD EXTRACTION
    // --------------------------
    func extractDetails(from text: String) {
        
        func match(_ pattern: String) -> String {
            let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            if let m = regex?.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
               let range = Range(m.range, in: text) {
                return String(text[range])
            }
            return ""
        }
        
        name = match("(?<=name[:\\s]).*")
        dob = match("(\\d{2}[/-]\\d{2}[/-]\\d{4})")
        idNumber = match("(?<=id[:\\s]|reg[:\\s]|no[:\\s]).*")
        gender = match("Male|Female|M|F")
        address = match("(?<=address[:\\s]).*")
        
        if name.isEmpty { name = guessFromKeywords(["name", "holder"]) }
        if address.isEmpty { address = guessFromKeywords(["address", "addr"]) }
    }
    
    func guessFromKeywords(_ keys: [String]) -> String {
        let lines = extractedText.lowercased().components(separatedBy: .newlines)
        for (index, line) in lines.enumerated() {
            if keys.contains(where: { line.contains($0) }) {
                return index + 1 < lines.count ? lines[index + 1] : ""
            }
        }
        return ""
    }
    
    
    // --------------------------
    // IMAGE LOAD
    // --------------------------
    func loadImage() {
        Task {
            if let data = try? await selectedImage?.loadTransferable(type: Data.self),
               let img = UIImage(data: data) {
                self.uiImage = img
                extractText(from: img)
            }
        }
    }
}


#Preview {
    ContentView()
}
