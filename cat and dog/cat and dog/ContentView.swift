//
//  ContentView.swift
//  Cat&DogImageClassification
//
//  Created by BATCH02L1 on 11/12/25.
//

import SwiftUI
import CoreML
import Vision
import PhotosUI

struct ContentView: View {

    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedUIImage: UIImage? = nil
    @State private var classificationResult: String? = nil

    var body: some View {
        VStack {

            Text("Hello, world!")
                .font(.title)
                .padding()

            // Show selected image
            if let uiImage = selectedUIImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }

            // Photos picker must use BINDING ($selectedImage)
            PhotosPicker(
                selection: $selectedImage,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Select Image")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .onChange(of: selectedImage) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedUIImage = image
                        self.classify(image: image)      // ← FIXED
                    }
                }
            }

            if let result = classificationResult {
                Text("Result: \(result)")
                    .font(.title2)
                    .bold()
                    .padding()
            }

        }
        .padding()
    }

    func classify(image: UIImage) {

        guard let model = try? VNCoreMLModel(for: CatAndDogClassifier().model) else {
            fatalError("Could not load CoreML model")
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            if let results = request.results as? [VNClassificationObservation],
               let topResult = results.first {
                DispatchQueue.main.async {
                    self.classificationResult = topResult.identifier
                }
            } else {
                DispatchQueue.main.async {
                    self.classificationResult = error?.localizedDescription
                }
            }
        }

        guard let ciImage = CIImage(image: image) else {
            fatalError("Could not convert UIImage to CIImage")
        }

        let handler = VNImageRequestHandler(ciImage: ciImage)

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.classificationResult = "Error"
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
