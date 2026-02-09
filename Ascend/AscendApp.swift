//
//  AscendApp.swift
//  Ascend
//
//  Created by Barsbold Bayarerdene on 08/02/2026.
//

import SwiftUI

@main
struct AscendApp: App {
    var body: some Scene {
        WindowGroup {
            Text("Welcome").font(.displayLarge)
            Button("Click Me!") {
                print("clicked")
            }
            .buttonStyle(AscendButtonStyle(variant: .destructive))

        }
    }
}
