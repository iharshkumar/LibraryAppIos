//
//  ContentView.swift
//  TextExtractor
//
//  Created by BATCH01L1-15 on 22/11/25.
//

import SwiftUI
import PhotosUI
import Vision

struct ContentView: View {
    @State private var selectedImage: PhotosPickerItem?
    @State var text: String = ""
    @State var isAnalyzing: Bool = false
    @State var uiImage:UIImage?
    var body: some View {
        VStack {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
            
            if !text.isEmpty{
                Text(text).padding()
            }
            PhotosPicker("Selected Image",selection: $selectedImage, matching: .images).onChange(of: selectedImage)
            {_ in
                loadImage()
                
            }
        }
        .padding()
    }
    
    
    func extractText(from image:UIImage){
        guard let cgImage = image.cgImage else{return}
        let request = VNRecognizeTextRequest{
            request,error in
            if let results = request.results as? [VNRecognizedTextObservation]{
                let recognizedText = results.compactMap{
                    $0.topCandidates(1).first?.string
                }.joined(separator: "\n")
                DispatchQueue.main.async{
                    self.text = recognizedText
                }
            }
        }
        request.recognitionLevel = .accurate
        request.recognitionLanguages=["en-US"]
        
        let requests = [request]
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async{
            do{
                try handler.perform(requests)
            }catch{
                print("Failed to perform text recognition: \(error)")
            }
        }
    }
    
    func loadImage(){
        Task {
                if let data = try? await selectedImage?.loadTransferable(type: Data.self),
               let image = UIImage(data: data){
                self.uiImage = image
                extractText(from: image)
            }
        }
    }
    
}

#Preview {
    ContentView()
}
