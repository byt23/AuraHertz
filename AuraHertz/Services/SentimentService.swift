//
//  SentimentService.swift
//  AuraHertz
//
//  Created by BERKAY TURAN on 16.04.2026.
//

import Foundation
import NaturalLanguage

class SentimentService {
    
    // Girilen metne göre renk ve frekans hesaplayan yapay zeka fonksiyonu
    func analyze(text: String) -> Mood {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        
        // Skor -1.0 (Çok Negatif/Üzgün) ile 1.0 (Çok Pozitif/Mutlu) arasındadır
        let score = Double(sentiment?.rawValue ?? "0.0") ?? 0.0
        
        // 1. Skora göre Renk (Hue) Belirleme
        // Negatifse Mavi/Mor (0.6 - 0.8), Pozitifse Sarı/Turuncu (0.1 - 0.2), Nötrse Yeşil (0.4)
        var targetHue: Double = 0.4
        if score < -0.3 { targetHue = 0.65 } // Melankolik
        else if score > 0.3 { targetHue = 0.15 } // Enerjik
        
        // 2. Skora göre Frekans (Hz) Belirleme
        // Negatif duygular düşük (bass) frekans, pozitifler yüksek frekans (300Hz - 600Hz arası)
        let targetFreq = 450.0 + (score * 150.0)
        
        // 3. Etiket Belirleme
        let moodDesc: String
        if score > 0.5 { moodDesc = "Enerjik ve Pozitif" }
        else if score < -0.5 { moodDesc = "Melankolik ve Derin" }
        else { moodDesc = "Dengeli ve Sakin" }
        
        return Mood(description: moodDesc, targetHue: targetHue, targetFrequency: targetFreq)
    }
}
