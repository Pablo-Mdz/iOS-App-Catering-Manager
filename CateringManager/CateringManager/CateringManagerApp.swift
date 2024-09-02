//
//  CateringManagerApp.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 01/07/2024.
//  in my portfolio

import SwiftUI
import FirebaseCore

@main
struct CateringManagerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var loginViewModel = UserViewModel()
    @StateObject private var todoListViewModel = ToDoListViewModel()
    @State private var showSplashScreen = true
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if showSplashScreen {
                SplashScreenView()
                    .environmentObject(loginViewModel)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                self.showSplashScreen = false
                            }
                        }
                    }
            } else {
                if loginViewModel.isUserLoggedIn {
                    ContentView()
                        .environmentObject(loginViewModel)
                        .environmentObject(todoListViewModel)
                } else {
                    LoginView()
                        .environmentObject(loginViewModel)
                }
            }
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
//        UNUserNotificationCenter.current().setBadgeCount(0)
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: { _, _ in }
        )
        return true
    }
    // MARK: - UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.banner]
    }
}
