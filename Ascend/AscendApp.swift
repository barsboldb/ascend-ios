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

    init() {
        UNUserNotificationCenter.current().delegate = ForegroundNotificationDelegate.shared
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(navigation)
        }
    }
}
