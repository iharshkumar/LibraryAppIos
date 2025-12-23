//
//  localNotificationApp.swift
//  localNotification
//
//  Created by BATCH01L1-15 on 12/12/25.
//

import SwiftUI

@main
struct localNotificationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    init(){
        requestNotificationPermission()
    }
    func requestNotificationPermission(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]){
            granted, error in
            if let error = error {
                print("Eroor requesting notification permission:\(error.localizedDescription)")
            }else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool{
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner,.sound,.badge])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
