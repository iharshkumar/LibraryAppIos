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
    
    // Editable Extracted ID Fields
    @State private var name: String = ""
    @State private var dob: String = ""
    @State private var idNumber: String = ""
    @State private var address: String = ""
    @State private var gender: String = ""
    
    @State private var isEditing = false   // NEW: Toggle for editing mode
    
    var body: some View {
        
        NavigationView {
            ZStack {
                LinearGradient(colors: [.indigo.opacity(0.2), .purple.opacity(0.15)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        
                        // Upload Card
                        VStack(spacing: 15) {
                            
                            Text("ID Card Scanner")
                                .font(.largeTitle.bold())
                            
                            if let uiImage {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(12)
                                    .shadow(radius: 8)
                            } else {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(height: 200)
                                    .overlay(
                                        VStack(spacing: 10) {
                                            Image(systemName: "photo.on.rectangle")
                                                .font(.system(size: 45))
                                                .foregroundColor(.purple)
                                            Text("Upload ID Card")
                                                .foregroundColor(.secondary)
                                        }
                                    )
                            }
                            
                            PhotosPicker("Select ID Image",
                                         selection: $selectedImage,
                                         matching: .images)
                            .onChange(of: selectedImage) { _ in loadImage() }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(16)
                        .shadow(radius: 5)
                        
                        
                        // Editable Extracted Fields
                        if extractedText.isEmpty == false {
                            VStack(alignment: .leading, spacing: 15) {
                                
                                HStack {
                                    Text("Extracted Details")
                                        .font(.title2.bold())
                                    Spacer()
                                    
                                    // Edit Toggle
                                    Button(isEditing ? "Done" : "Edit") {
                                        isEditing.toggle()
                                    }
                                    .foregroundColor(.blue)
                                }
                                
                                infoField(title: "Name", text: $name, icon: "person.text.rectangle", editable: isEditing)
                                infoField(title: "Date of Birth", text: $dob, icon: "calendar", editable: isEditing)
                                infoField(title: "ID Number", text: $idNumber, icon: "number", editable: isEditing)
                                infoField(title: "Gender", text: $gender, icon: "person", editable: isEditing)
                                
                                VStack(alignment: .leading) {
                                    Label("Address", systemImage: "house")
                                        .font(.headline)
                                    
                                    if isEditing {
                                        TextEditor(text: $address)
                                            .frame(height: 80)
                                            .padding(8)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(8)
                                    } else {
                                        Text(address.isEmpty ? "—" : address)
                                            .padding(10)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(8)
                                    }
                                }
                                
                            }
                            .padding()
                            .background(.white)
                            .cornerRadius(16)
                            .shadow(radius: 5)
                        }
                        
                        
                        // Raw OCR text section
                        if extractedText.isEmpty == false {
                            VStack(alignment: .leading) {
                                Text("Raw Extracted OCR Text")
                                    .font(.headline)
                                
                                Text(extractedText)
                                    .font(.footnote)
                                    .padding()
                                    .background(Color(.systemGray5))
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                        
                    }
                    .padding()
                }
            }
            .navigationTitle("ID Extractor")
        }
    }
    
    
    // MARK: - UI Field Component
    func infoField(title: String, text: Binding<String>, icon: String, editable: Bool) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Label(title, systemImage: icon)
                .font(.headline)
            
            if editable {
                TextField("Enter \(title.lowercased())", text: text)
                    .textFieldStyle(.roundedBorder)
            } else {
                Text(text.wrappedValue.isEmpty ? "—" : text.wrappedValue)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
        }
    }
    
    
    // MARK: - OCR + Extraction
    func extractDetails(from text: String) {
        
        func match(_ pattern: String) -> String {
            let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            if let result = regex?.firstMatch(in: text, options: [], range: NSRange(text.startIndex..., in: text)),
               let range = Range(result.range, in: text) {
                return String(text[range])
            }
            return ""
        }
        
        // Extract common fields using patterns + keywords
        name = match("(?<=name[:\\s]).*")
        dob = match("(\\d{2}[/-]\\d{2}[/-]\\d{4})")
        idNumber = match("(?<=id[:\\s]|ID[:\\s]|Reg[:\\s]).*")
        gender = match("Male|Female|M|F")
        
        // Address pattern (rough extraction)
        address = match("(?<=address[:\\s]).*")
        
        // fallback if empty
        if name.isEmpty {
            name = findLineStarting(keywords: ["name", "holder", "student"], in: text)
        }
        if address.isEmpty {
            address = findLineStarting(keywords: ["address", "addr"], in: text)
        }
    }
    
    func findLineStarting(keywords: [String], in text: String) -> String {
        let lines = text.lowercased().components(separatedBy: .newlines)
        for (i, line) in lines.enumerated() {
            if keywords.contains(where: { line.contains($0) }) {
                return (i + 1 < lines.count) ? lines[i+1] : ""
            }
        }
        return ""
    }

    
    // MARK: - OCR Handler
    func extractText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNRecognizeTextRequest { request, _ in
            guard let results = request.results as? [VNRecognizedTextObservation] else { return }
            
            let text = results.compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            
            DispatchQueue.main.async {
                self.extractedText = text
                self.extractDetails(from: text)
            }
        }
        
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
    
    
    // MARK: - Load Selected Image
    func loadImage() {
        Task {
            if let data = try? await selectedImage?.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                self.uiImage = image
                extractText(from: image)
            }
        }
    }
}

#Preview {
    ContentView()
}

