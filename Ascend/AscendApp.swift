//
//  AscendApp.swift
//  Ascend
//
//  Created by Barsbold Bayarerdene on 08/02/2026.
//

import SwiftUI
import UserNotifications

@main
struct AscendApp: App {
    @StateObject private var navigation = NavigationState()
    @StateObject private var auth = AuthState.shared

    init() {
        UNUserNotificationCenter.current().delegate = ForegroundNotificationDelegate.shared
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(navigation)
                .environmentObject(auth)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var auth: AuthState

    var body: some View {
        if auth.isSignedIn {
            HomeView()
                .task {
                    if auth.currentUser == nil, #available(iOS 18.0, *) {
                        if let user = try? await AuthRepository.shared.me() {
                            auth.setUser(user)
                        } else {
                            auth.signOut()
                        }
                    }
                }
        } else {
            LoginView()
        }
    }
}
