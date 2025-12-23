//
//  ContentView.swift
//  localNotification
//
//  Created by BATCH01L1-15 on 12/12/25.
//

import SwiftUI

struct ContentView: View {
   
    
    var body: some View {
        VStack {
        Text("Local notification batch  example")
                .font(.title)
                .padding()
            Button("Send Batch Notification"){
                sendNotification()
            }.buttonStyle(.bordered)
        }
        .padding()
    }
    func sendNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Batch Notification"
        content.body = "Jag Jao! "
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request){
            error in
            if let error = error{
                print("Error scheduling notification :\(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView()
}
