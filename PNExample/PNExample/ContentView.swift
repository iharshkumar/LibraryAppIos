import SwiftUI
import UserNotifications
import PhotosUI
import AVFoundation

// MARK: - Reminder MODEL
struct Reminder: Identifiable, Codable {
    let id: UUID
    let message: String
    let date: Date
    let sound: String
    let imageData: Data?
    
    var image: UIImage? {
        guard let imageData = imageData else { return nil }
        return UIImage(data: imageData)
    }
    
    init(id: UUID = UUID(), message: String, date: Date, sound: String, image: UIImage?) {
        self.id = id
        self.message = message
        self.date = date
        self.sound = sound
        self.imageData = image?.jpegData(compressionQuality: 0.8)
    }
}

// MARK: - App State for handling notification tap
class AppState: ObservableObject {
    @Published var selectedReminder: Reminder? = nil
}

// MARK: - ContentView
struct ContentView: View {
    
    @StateObject private var appState = AppState()
    
    // User input
    @State private var reminderText = ""
    @State private var selectedDay = Date()
    @State private var selectedHour = Calendar.current.component(.hour, from: Date())
    @State private var selectedMinute = Calendar.current.component(.minute, from: Date())
    
    @State private var selectedSound = "Default"
    let soundOptions = ["Default", "Chime", "Bell", "Alarm", "Glass"]
    
    @State private var chosenImage: UIImage? = nil
    @State private var showImagePicker = false
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var reminders: [Reminder] = []
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 25) {
                        
                        Text("Reminder Vault")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        
                        VStack(spacing: 20) {
                            // TEXT
                            TextField("Enter reminder message...", text: $reminderText)
                                .padding()
                                .background(Color(white: 0.95))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                            
                            // DAY PICKER
                            DatePicker("Select Day",
                                       selection: $selectedDay,
                                       in: Date()...,
                                       displayedComponents: .date)
                            .padding()
                            .background(Color(white: 0.95))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                            
                            // TIME PICKER
                            VStack(spacing: 5) {
                                Text("Time Picker")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                HStack(spacing: 10) {
                                    LockWheel(selection: $selectedHour, range: 0...23, label: "H")
                                    Text(":")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.white)
                                    LockWheel(selection: $selectedMinute, range: 0...59, label: "M")
                                }
                            }
                            
                            // SOUND PICKER
                            Menu {
                                ForEach(soundOptions, id: \.self) { sound in
                                    Button(sound) {
                                        selectedSound = sound
                                        playSound(named: sound)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text("Sound: \(selectedSound)")
                                    Spacer()
                                    Image(systemName: "speaker.wave.2.fill")
                                }
                                .padding()
                                .background(Color(white: 0.95))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                            }
                            
                            // IMAGE PICKER
                            Button(action: { showImagePicker = true }) {
                                HStack {
                                    Text(chosenImage == nil ? "Add Image" : "Change Image")
                                    Spacer()
                                    Image(systemName: "photo.on.rectangle.angled")
                                }
                                .padding()
                                .background(Color(white: 0.95))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                            }
                            
                            if let img = chosenImage {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 140)
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 2)
                            }
                            
                            // ADD REMINDER BUTTON
                            Button(action: saveReminder) {
                                Text("Add Reminder")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.yellow)
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3)
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        
                        // Reminder List
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Saved Reminders")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            
                            ForEach(reminders) { reminder in
                                HStack(spacing: 12) {
                                    if let img = reminder.image {
                                        Image(uiImage: img)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 55, height: 55)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(reminder.message)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        Text(reminder.date.formatted(date: .numeric, time: .shortened))
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                    Button(action: { deleteReminder(reminder) }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .font(.title2)
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.08))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                }
                .background(
                    LinearGradient(colors: [.black, .gray, .black],
                                   startPoint: .top,
                                   endPoint: .bottom)
                    .ignoresSafeArea()
                )
                
                // Navigation to Reminder Detail when notification tapped
                if let reminder = appState.selectedReminder {
                    NavigationLink(
                        destination: ReminderDetailView(reminder: reminder),
                        isActive: .constant(true),
                        label: { EmptyView() }
                    )
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $chosenImage)
        }
        .alert("Reminder Scheduled!", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            // Request notification permission
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error { print(error) }
            }
            center.delegate = NotificationDelegate(appState: appState)
        }
    }
    
    // MARK: - Save Reminder
    func saveReminder() {
        let date = Calendar.current.date(bySettingHour: selectedHour, minute: selectedMinute, second: 0, of: selectedDay)!
        let newReminder = Reminder(message: reminderText, date: date, sound: selectedSound, image: chosenImage)
        reminders.append(newReminder)
        scheduleNotification(reminder: newReminder)
        showAlert = true
        reminderText = ""
        chosenImage = nil
    }
    
    // MARK: - Play Sound
    func playSound(named soundName: String) {
        let fileName = soundName == "Default" ? "default_sound" : soundName.lowercased()
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "wav") else { return }
        do { audioPlayer = try AVAudioPlayer(contentsOf: url); audioPlayer?.play() }
        catch { print("Error playing sound: \(error.localizedDescription)") }
    }
    
    // MARK: - Schedule Notification
    func scheduleNotification(reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = reminder.message
        content.userInfo = ["id": reminder.id.uuidString]
        
        // Attach image
        if let imgData = reminder.imageData {
            let tmpDir = FileManager.default.temporaryDirectory
            let tmpFile = tmpDir.appendingPathComponent("\(UUID().uuidString).jpg")
            try? imgData.write(to: tmpFile)
            if let attachment = try? UNNotificationAttachment(identifier: "image", url: tmpFile, options: nil) {
                content.attachments = [attachment]
            }
        }
        
        // Sound
        switch reminder.sound {
        case "Chime": content.sound = UNNotificationSound(named: UNNotificationSoundName("chime.wav"))
        case "Bell":  content.sound = UNNotificationSound(named: UNNotificationSoundName("bell.wav"))
        case "Alarm": content.sound = UNNotificationSound(named: UNNotificationSoundName("alarm.wav"))
        case "Glass": content.sound = UNNotificationSound(named: UNNotificationSoundName("glass.wav"))
        default:      content.sound = .default
        }
        
        let dateComp = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: reminder.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func deleteReminder(_ reminder: Reminder) {
        reminders.removeAll { $0.id == reminder.id }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
    }
}

// MARK: - REMINDER DETAIL VIEW
struct ReminderDetailView: View {
    let reminder: Reminder
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        VStack(spacing: 20) {
            if let img = reminder.image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    .padding()
            }
            
            Text(reminder.message)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
        .navigationTitle("Reminder")
        .onAppear {
            playSound(named: reminder.sound)
        }
    }
    
    func playSound(named soundName: String) {
        let fileName = soundName == "Default" ? "default_sound" : soundName.lowercased()
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "wav") else { return }
        do { audioPlayer = try AVAudioPlayer(contentsOf: url); audioPlayer?.play() }
        catch { print("Sound error: \(error.localizedDescription)") }
    }
}

// MARK: - LOCK WHEEL
struct LockWheel: View {
    @Binding var selection: Int
    let range: ClosedRange<Int>
    let label: String
    
    var body: some View {
        VStack(spacing: 5) {
            Picker("", selection: $selection) {
                ForEach(range, id: \.self) { number in
                    Text(String(format: "%02d", number))
                        .font(.system(size: 40, weight: .bold, design: .monospaced))
                        .foregroundColor(.yellow)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 120, height: 150)
            .background(Color.black.opacity(0.8))
            .cornerRadius(15)
            .shadow(radius: 3)
            
            Text(label)
                .foregroundColor(.white)
                .font(.headline)
        }
    }
}

// MARK: - IMAGE PICKER
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ vc: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self)
            else { return }
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async { self.parent.selectedImage = image as? UIImage }
            }
        }
    }
}

// MARK: - NOTIFICATION DELEGATE
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    let appState: AppState
    init(appState: AppState) { self.appState = appState }
    
    // Handle notification tap
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let idStr = userInfo["id"] as? String, let id = UUID(uuidString: idStr) {
            // Retrieve notification info
            if let attachment = response.notification.request.content.attachments.first,
               let data = try? Data(contentsOf: attachment.url) {
                let reminder = Reminder(id: id,
                                        message: response.notification.request.content.body,
                                        date: Date(),
                                        sound: response.notification.request.content.sound?.description ?? "Default",
                                        image: UIImage(data: data))
                DispatchQueue.main.async { appState.selectedReminder = reminder }
            } else {
                let reminder = Reminder(id: id,
                                        message: response.notification.request.content.body,
                                        date: Date(),
                                        sound: response.notification.request.content.sound?.description ?? "Default",
                                        image: nil)
                DispatchQueue.main.async { appState.selectedReminder = reminder }
            }
        }
        completionHandler()
    }
}

#Preview {
    ContentView()
}
