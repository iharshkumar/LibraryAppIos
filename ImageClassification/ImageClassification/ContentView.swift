//
//  ContentView.swift
//  ImageClassificationPro
//

import SwiftUI
import Vision
import PhotosUI
import CoreML

// MARK: - Data Model for History
struct ClassificationItem: Identifiable {
    let id = UUID()
    let image: UIImage
    let result: String
    let confidence: Int
}

struct ContentView: View {
    
    // MARK: - States
    @State private var selectedImage: UIImage?
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var classificationLabel: String = "Select an image"
    
    @State private var history: [ClassificationItem] = []    // Saved classifications
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Dark Gradient
                LinearGradient(colors: [Color.black, Color.gray.opacity(0.9)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        
                        // Title
                        Text("Image Classification Pro")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .padding(.top)
                        
                        // Selected Image Preview
                        if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .cornerRadius(15)
                                .shadow(radius: 10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.05))
                                .frame(height: 300)
                                .overlay(
                                    Text("No Image Selected")
                                        .foregroundColor(.white.opacity(0.6))
                                        .font(.headline)
                                )
                        }
                        
                        // Classification Result Card
                        VStack {
                            Text(classificationLabel)
                                .font(.headline)
                                .foregroundColor(.purple)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            // Confidence Bar
                            if classificationLabel != "Select an image" && selectedImage != nil {
                                ProgressView(value: confidenceValue())
                                    .accentColor(.purple)
                                    .padding(.horizontal)
                            }
                        }
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .shadow(radius: 5)
                        
                        // Select Image Button
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            Text("Select Image")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .font(.title3.bold())
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                        .onChange(of: selectedPhotoItem) { newItem in
                            if let newItem {
                                loadImage(item: newItem)
                            }
                        }
                        
                        // History List
                        if !history.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Classification History")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .padding(.leading)
                                
                                ForEach(history.reversed()) { item in
                                    HStack(spacing: 15) {
                                        Image(uiImage: item.image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(10)
                                            .clipped()
                                            .shadow(radius: 2)
                                        
                                        VStack(alignment: .leading) {
                                            Text(item.result)
                                                .foregroundColor(.white)
                                                .font(.headline)
                                            Text("Confidence: \(item.confidence)%")
                                                .foregroundColor(.gray)
                                                .font(.subheadline)
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(12)
                                    .shadow(radius: 2)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                    }
                    .padding(.bottom, 30)
                } // ScrollView
            } // ZStack
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Classification Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitleDisplayMode(.inline)
        } // Navigation
    }
    
    // MARK: - Load Image
    func loadImage(item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data, let img = UIImage(data: data) {
                    selectedImage = img
                    classifyImage(image: img)
                }
            case .failure(let e):
                print("Error loading image:", e.localizedDescription)
            }
        }
    }
    
    // MARK: - Image Classification
    func classifyImage(image: UIImage) {
        classificationLabel = "Analyzing..."
        
        guard let ciImage = CIImage(image: image) else {
            classificationLabel = "Failed to create CIImage"
            return
        }
        
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            classificationLabel = "Failed to load ML model"
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, _ in
            if let results = request.results as? [VNClassificationObservation],
               let top = results.first {
                
                let resultText = top.identifier
                let confidence = Int(top.confidence * 100)
                
                DispatchQueue.main.async {
                    classificationLabel = "\(resultText)"
                    
                    // Save to history
                    if let img = selectedImage {
                        let item = ClassificationItem(image: img, result: resultText, confidence: confidence)
                        history.append(item)
                    }
                    
                    // Show alert
                    alertMessage = "\(resultText) (\(confidence)% confidence)"
                    showAlert = true
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    classificationLabel = "Classification failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Confidence Bar Value
    func confidenceValue() -> Double {
        if let confidence = Double(classificationLabelConfidence()) {
            return confidence / 100.0
        }
        return 0
    }
    
    func classificationLabelConfidence() -> String {
        let parts = classificationLabel.components(separatedBy: "(")
        if parts.count > 1 {
            let conf = parts[1].replacingOccurrences(of: "% confidence)", with: "")
            return conf
        }
        return "0"
    }
}

#Preview {
    ContentView()
}
