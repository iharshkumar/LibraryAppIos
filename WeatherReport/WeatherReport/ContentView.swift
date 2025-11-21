import SwiftUI

struct OpenMateoResponse: Decodable {
    
    struct CurrentWeather: Decodable {
        let temperature: Double
        let windspeed: Double
        let winddirection: Double
        let weathercode: Int
        let is_day: Int
        let time: String
        let interval: Int
    }
    
    struct Units: Decodable {
        let temperature: String
        let windspeed: String
        let winddirection: String
        let time: String
        let weathercode: String
        let is_day: String
        let interval: String
    }

    let latitude: Double
    let longitude: Double
    let elevation: Double
    let timezone: String
    let timezone_abbreviation: String
    let utc_offset_seconds: Int
    let generationtime_ms: Double
    
    let current_weather: CurrentWeather
    let current_weather_units: Units
}

struct ContentView: View {

    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var weatherInfo: OpenMateoResponse?
    @State private var errorMessage: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // ---------------- TEXT FIELDS ----------------
                Group {
                    TextField("Enter Latitude", text: $latitude)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                    TextField("Enter Longitude", text: $longitude)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // ---------------- BUTTON ----------------
                Button(action: {
                    if let lat = Double(latitude), let lon = Double(longitude) {
                        fetchWeather(latitude: lat, longitude: lon)
                    } else {
                        errorMessage = "Invalid latitude or longitude."
                    }
                }) {
                    Text("Fetch Weather")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                // ---------------- ERROR MESSAGE ----------------
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                // ---------------- WEATHER DISPLAY ----------------
                if let w = weatherInfo {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("🌤️ Detailed Weather Report")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text("Temperature:")
                            Spacer()
                            Text("\(w.current_weather.temperature) \(w.current_weather_units.temperature)")
                        }
                        
                        HStack {
                            Text("Wind Speed:")
                            Spacer()
                            Text("\(w.current_weather.windspeed) \(w.current_weather_units.windspeed)")
                        }
                        
                        HStack {
                            Text("Wind Direction:")
                            Spacer()
                            Text("\(w.current_weather.winddirection)°")
                        }
                        
                        HStack {
                            Text("Weather Code:")
                            Spacer()
                            Text("\(weatherDescription(for: w.current_weather.weathercode))")
                        }
                        
                        HStack {
                            Text("Is Day:")
                            Spacer()
                            Text(w.current_weather.is_day == 1 ? "☀️ Day" : "🌙 Night")
                        }
                        
                        HStack {
                            Text("Time:")
                            Spacer()
                            Text(w.current_weather.time)
                        }
                        
                        Divider()

                        // -------- Location Details --------
                        Text("📍 Location Details")
                            .font(.headline)

                        HStack { Text("Latitude:"); Spacer(); Text("\(w.latitude)") }
                        HStack { Text("Longitude:"); Spacer(); Text("\(w.longitude)") }
                        HStack { Text("Elevation:"); Spacer(); Text("\(w.elevation) m") }

                        Divider()

                        // -------- Timezone --------
                        Text("🕒 Timezone Info")
                            .font(.headline)

                        HStack { Text("Timezone:"); Spacer(); Text(w.timezone) }
                        HStack { Text("Abbreviation:"); Spacer(); Text(w.timezone_abbreviation) }
                        HStack { Text("UTC Offset:"); Spacer(); Text("\(w.utc_offset_seconds) sec") }

                        Divider()

                        // -------- Generation Time --------
                        HStack {
                            Text("API Response Time:")
                            Spacer()
                            Text("\(w.generationtime_ms, specifier: "%.3f") ms")
                        }

                    }
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding()
                }
            }
        }
    }


    // -------- WEATHER DESCRIPTION BASED ON WMO WEATHER CODE --------
    func weatherDescription(for code: Int) -> String {
        switch code {
        case 0: return "Clear Sky"
        case 1, 2, 3: return "Partly Cloudy"
        case 45, 48: return "Fog"
        case 51, 53, 55: return "Drizzle"
        case 61, 63, 65: return "Rain"
        case 71, 73, 75: return "Snow"
        case 95: return "Thunderstorm"
        default: return "Unknown"
        }
    }


    // ---------------- API CALL ----------------
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString =
        "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                errorMessage = "Network Error: \(error.localizedDescription)"
                return
            }

            guard let data = data else { return }

            DispatchQueue.main.async {
                do {
                    weatherInfo = try JSONDecoder().decode(OpenMateoResponse.self, from: data)
                    errorMessage = ""
                } catch {
                    errorMessage = "JSON Parsing Error: \(error.localizedDescription)"
                }
            }

        }.resume()
    }
}

#Preview { ContentView() }
