//
//  ARIApp.swift
//  ARI
//
//  Created by Healthy on 3/27/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct ARIApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // 문제 데이터 뷰 모델
    @StateObject private var questionViewModel = QuestionViewModel()
    
    // 로그인 데이터 뷰 모델
    @StateObject private var loginViewModel = LoginViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(questionViewModel)
                .environmentObject(loginViewModel)
        }
    }
}
