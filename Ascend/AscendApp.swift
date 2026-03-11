//
//  AscendApp.swift
//  Ascend
//
//  Created by Barsbold Bayarerdene on 08/02/2026.
//

import SwiftUI

@main
struct AscendApp: App {
    @StateObject private var navigation = NavigationState()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(navigation)
        }
    }
}
