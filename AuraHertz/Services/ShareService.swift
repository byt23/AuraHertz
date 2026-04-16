//
//  ShareService.swift
//  AuraHertz
//
//  Created by BERKAY TURAN on 16.04.2026.
//

import SwiftUI
import Combine

@MainActor
class ShareService: ObservableObject {
    @Published var renderedImage: Image?
    @Published var renderedUIImage: UIImage?
    
    func renderAuraCard(mood: String, hue: Double, frequency: Double, score: Int) {
        let cardView = AuraCardView(mood: mood, hue: hue, frequency: frequency, score: score)
        let renderer = ImageRenderer(content: cardView)
        
        // UYARI GİDERİLDİ: UIScreen.main yerine doğrudan Retina (3.0) kalitesi atandı.
        renderer.scale = 3.0
        
        if let uiImage = renderer.uiImage {
            self.renderedUIImage = uiImage
            self.renderedImage = Image(uiImage: uiImage)
        }
    }
}
