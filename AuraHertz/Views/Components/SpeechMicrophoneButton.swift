//
//  SpeechMicrophoneButton.swift
//  AuraHertz
//
//  Created by BERKAY TURAN on 16.04.2026.
//

import SwiftUI

struct SpeechMicrophoneButton: View {
    @ObservedObject var viewModel: AuraHertzViewModel
    @State private var isPulsing = false
    
    var body: some View {
        Button(action: {
            if viewModel.isSpeechRecording {
                viewModel.stopSpeechRecording()
            } else {
                viewModel.startSpeechRecording()
            }
        }) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .scaleEffect(isPulsing ? 1.2 : 1.0)
                    .animation(viewModel.isSpeechRecording ? .easeInOut(duration: 1).repeatForever(autoreverses: true) : .default, value: isPulsing)
                
                Image(systemName: viewModel.isSpeechRecording ? "mic.fill" : "mic")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(viewModel.isSpeechRecording ? .white : Color(hue: viewModel.currentMood.targetHue, saturation: 1.0, brightness: 1.0))
                    .contentTransition(.symbolEffect(.replace))
            }
        }
        // UYARI GİDERİLDİ: iOS 17+ Modern onChange kullanımı
        .onChange(of: viewModel.isSpeechRecording) { oldValue, newValue in
            isPulsing = newValue
        }
        .padding(.top, 20)
    }
}
