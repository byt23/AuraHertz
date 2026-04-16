//
//  AuraCardView.swift
//  AuraHertz
//
//  Created by BERKAY TURAN on 16.04.2026.
//

import SwiftUI

struct AuraCardView: View {
    var mood: String
    var hue: Double
    var frequency: Double
    var score: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text("AuraHertz")
                .font(.headline)
                .tracking(2)
                .foregroundColor(.white.opacity(0.8))
            
            Text(mood)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            // Dalga İkonu
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 60))
                .foregroundColor(.white)
            
            HStack(spacing: 40) {
                VStack {
                    Text("\(Int(frequency)) Hz")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    Text("Frekans")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                VStack {
                    Text("%\(score)")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    Text("Senkron")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        }
        .padding(40)
        .background(
            LinearGradient(gradient: Gradient(colors: [
                Color(hue: hue, saturation: 0.8, brightness: 0.6),
                Color(hue: hue, saturation: 0.6, brightness: 0.3)
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(30)
        .frame(width: 350, height: 400)
    }
}
