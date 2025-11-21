import SwiftUI

struct JokeResponse: Decodable {
    let id: Int
    let setup: String
    let punchline: String
}

struct ContentView: View {
    
    @State private var jokeID: Int?
    @State private var jokeText: String = ""
    @State private var responseMessage: String = ""
    @State private var jokeP: String = ""
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            // Full background for entire screen
            Color(red:126/225,green: 133/225, blue: 163)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 40) {
                
                Text("Welcome To An Api Where You can find Jokes can make someone Laugh")
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                Text("Random Joke # \(jokeID ?? 0)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Text("\(jokeText)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Text("\(jokeP)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
            
            // Button at bottom
            Button(action: fetchJoke) {
                Text("Find New Joke")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .foregroundColor(.blue)
                    .cornerRadius(7)
                    .padding(.horizontal, 15)
                    
            }
        }
    }
    
    
    func fetchJoke() {
        let urlString = "https://official-joke-api.appspot.com/random_joke"
        guard let url = URL(string: urlString) else { return }
        
        responseMessage = "Loading..."
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    responseMessage = "Error: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    responseMessage = "No data received"
                }
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let joke = try JSONDecoder().decode(JokeResponse.self, from: data)
                    
                    self.jokeID = joke.id
                    self.jokeText = joke.setup
                    self.jokeP = joke.punchline
                    self.responseMessage = "Success"
                    
                } catch {
                    responseMessage = "JSON Error"
                }
            }
            
        }.resume()
    }
}

#Preview {
    ContentView()
}
