//
//  AuraHertzViewModel.swift
//  AuraHertz
//
//  Created by BERKAY TURAN on 16.04.2026.
//

import SwiftUI
import Combine
import UIKit

// @MainActor KALDIRILDI! Çökmenin asıl sebebi oydu.
class AuraHertzViewModel: ObservableObject {
    @Published var currentMood: Mood
    @Published var userHue: Double = 0.5
    @Published var userFrequency: Double = 440.0
    @Published var matchScore: Int = 0
    @Published var showSuccess: Bool = false
    @Published var level: Int = 1
    
    // Speech Tarafı State'leri
    @Published var isSpeechRecording = false
    @Published var currentTranscription: String = ""
    
    private let audioService = AudioService()
    private let sentimentService = SentimentService()
    private let speechService = SpeechService()
    
    // Titreşim spam'ini engellemek için önceki skoru hafızada tutuyoruz
    private var lastHapticScore: Int = 0
    
    init() {
        self.currentMood = sentimentService.analyze(text: "Lütfen duygularını sesli anlat.")
        
        self.speechService.onTranscriptionUpdate = { transcription in
            DispatchQueue.main.async {
                self.currentTranscription = transcription
            }
        }
        updateScore()
    }
    
    func frequencyChanged() {
        audioService.playTone(frequency: userFrequency)
        updateScore()
    }
    
    func colorChanged() {
        updateScore()
    }
    
    private func updateScore() {
        if showSuccess { return }
        
        let hueDiff = abs(currentMood.targetHue - userHue)
        let freqDiff = abs(currentMood.targetFrequency - userFrequency) / 800.0
        
        let totalDiff = (hueDiff * 0.7) + (freqDiff * 0.3)
        self.matchScore = max(0, 100 - Int(totalDiff * 100))
        
        triggerHaptics()
        
        if matchScore >= 95 {
            levelPassed()
        }
    }
    
    // Titreşim Spam Engelleyici (Sadece hedeflerde titrer)
    private func triggerHaptics() {
        guard matchScore != lastHapticScore else { return }
        lastHapticScore = matchScore
        
        // Donanımsal titreşimleri her ihtimale karşı ana sıraya (Main Thread) alıyoruz
        DispatchQueue.main.async {
            if self.matchScore == 80 {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            } else if self.matchScore == 85 {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } else if self.matchScore == 90 {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
        }
    }
    
    private func levelPassed() {
        showSuccess = true
        DispatchQueue.main.async {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
        audioService.stopTone()
    }
    
    func prepareForNextLevel() {
        self.showSuccess = false
        self.level += 1
        
        self.userHue = 0.5
        self.userFrequency = 440.0
        self.currentTranscription = ""
        
        self.currentMood = Mood(description: "Anlat, seni dinliyorum...", targetHue: userHue, targetFrequency: userFrequency)
        self.matchScore = 0
        self.lastHapticScore = 0
    }
    
    func startSpeechRecording() {
        isSpeechRecording = true
        speechService.startRecording { result in
            DispatchQueue.main.async {
                self.isSpeechRecording = false
                
                switch result {
                case .success(let finalTranscription):
                    self.currentMood = self.sentimentService.analyze(text: finalTranscription)
                    self.currentTranscription = ""
                    self.updateScore()
                    
                case .failure(let error):
                    print("🎙️ Ses Tanıma Hatası: \(error)")
                    self.currentMood = Mood(description: "Hata: Ses tanıma başarısız.", targetHue: 0.0, targetFrequency: 440.0)
                }
            }
        }
    }
    
    func stopSpeechRecording() {
        speechService.stopRecording()
    }
}
