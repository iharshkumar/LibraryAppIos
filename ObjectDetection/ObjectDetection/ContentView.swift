//
//  ContentView.swift
//  ObjectDetection
//
//  Created by BATCH01L1-15 on 22/11/25.
//

import SwiftUI
import Vision
import CoreML
import PhotosUI


// MARK: - Model for Detected Objects
struct DetectedObject: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Int
    let boundingBox: CGRect
}

// MARK: - History Item
struct DetectionHistoryItem: Identifiable {
    let id = UUID()
    let image: UIImage
    let objects: [DetectedObject]
}

struct ContentView: View {
    
    // MARK: - State
    @State private var selectedImage: UIImage?
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    @State private var detectedObjects: [DetectedObject] = []
    @State private var history: [DetectionHistoryItem] = []
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color.black, Color.gray.opacity(0.9)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        
                        // Title
                        Text("Object Detection Pro")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .padding(.top)
                        
                        // MARK: - FIXED BOUNDING BOX IMAGE
                        ZStack {
                            if let selectedImage {
                                GeometryReader { geo in
                                    let size = geo.size
                                    
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: size.width)
                                        .cornerRadius(16)
                                        .shadow(radius: 10)
                                    
                                    // Overlay bounding boxes using correct scaling
                                    ForEach(detectedObjects) { obj in
                                        let box = convertBoundingBox(obj.boundingBox, in: size)
                                        
                                        ZStack(alignment: .topLeading) {
                                            Rectangle()
                                                .stroke(Color.red, lineWidth: 3)
                                                .frame(width: box.width, height: box.height)
                                                .position(x: box.midX, y: box.midY)
                                            
                                            Text("\(obj.label) \(obj.confidence)%")
                                                .font(.caption.bold())
                                                .padding(5)
                                                .background(Color.black.opacity(0.7))
                                                .foregroundColor(.white)
                                                .cornerRadius(6)
                                                .position(x: box.minX + 5,
                                                          y: box.minY - 10)
                                        }
                                    }
                                }
                                .frame(height: 300)
                            }
                            else {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.1))
                                    .frame(height: 300)
                                    .overlay(
                                        Text("No Image Selected")
                                            .foregroundColor(.white.opacity(0.5))
                                            .font(.title3)
                                    )
                            }
                        }
                        .padding(.horizontal)
                        
                        
                        // BUTTON – Select Image
                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            Text("Select Image")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .font(.title3.bold())
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .onChange(of: selectedPhotoItem) { newItem in
                            if let newItem {
                                loadImage(item: newItem)
                            }
                        }
                        
                        
                        // LIST OF DETECTED OBJECTS
                        if !detectedObjects.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Detected Objects")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                
                                ForEach(detectedObjects) { obj in
                                    HStack {
                                        Text(obj.label)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text("\(obj.confidence)%")
                                            .foregroundColor(.purple)
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        
                        // HISTORY
                        if !history.isEmpty {
                            VStack(alignment: .leading) {
                                Text("History")
                                    .foregroundColor(.white)
                                    .font(.title2.bold())
                                    .padding(.leading)
                                
                                ForEach(history.reversed()) { item in
                                    VStack(alignment: .leading) {
                                        Image(uiImage: item.image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 120)
                                            .clipped()
                                            .cornerRadius(10)
                                        
                                        ForEach(item.objects) { obj in
                                            Text("• \(obj.label) (\(obj.confidence)%)")
                                                .foregroundColor(.gray)
                                                .padding(.horizontal)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(14)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Detection Summary"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
    
    
    // MARK: - Load Image
    func loadImage(item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data, let img = UIImage(data: data) {
                    selectedImage = img
                    detectObjects(image: img)
                }
            case .failure(let e):
                print("Image load error: \(e.localizedDescription)")
            }
        }
    }
    
    
    // MARK: - Object Detection
    func detectObjects(image: UIImage) {
        detectedObjects.removeAll()
        
        guard let ciImage = CIImage(image: image) else { return }
        guard let model = try? VNCoreMLModel(for: YOLOv3().model) else {
            print("Failed to load YOLOv3 model")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { req, _ in
            guard let results = req.results as? [VNRecognizedObjectObservation] else { return }
            
            DispatchQueue.main.async {
                for obj in results {
                    let label = obj.labels.first?.identifier ?? "Unknown"
                    let confidence = Int((obj.labels.first?.confidence ?? 0) * 100)
                    
                    detectedObjects.append(
                        DetectedObject(label: label,
                                       confidence: confidence,
                                       boundingBox: obj.boundingBox)
                    )
                }
                
                // Save to history
                if let img = selectedImage {
                    history.append(DetectionHistoryItem(image: img,
                                                        objects: detectedObjects))
                }
                
                // Alert summary
                let summary = detectedObjects.map { "\($0.label) (\($0.confidence)%)" }.joined(separator: "\n")
                alertMessage = summary.isEmpty ? "No objects detected." : summary
                showAlert = true
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
    
    
    // MARK: - FIXED Bounding Box Conversion
    func convertBoundingBox(_ rect: CGRect, in containerSize: CGSize) -> CGRect {
        // rect = normalized YOLO bounding box
        
        let x = rect.minX * containerSize.width
        let y = (1 - rect.maxY) * containerSize.height
        let w = rect.width * containerSize.width
        let h = rect.height * containerSize.height
        
        return CGRect(x: x, y: y, width: w, height: h)
    }
}


#Preview {
    ContentView()
}
