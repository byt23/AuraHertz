//
//  AuraHertzApp.swift
//  AuraHertz
//
//  Created by BERKAY TURAN on 16.04.2026.
//

import SwiftUI
import SwiftData // YENİ

@main
struct AuraHertzApp: App {
    @StateObject private var viewModel = AuraHertzViewModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
        }
        // Tüm uygulama genelinde PersistentAura veritabanını aktif et
        .modelContainer(for: PersistentAura.self)
    }
}
