//
//  ControlSlidersView.swift
//  AuraHertz
//
//  Created by BERKAY TURAN on 16.04.2026.
//

import SwiftUI

struct ControlSlidersView: View {
    @EnvironmentObject var viewModel: AuraHertzViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            // Renk Slider'ı
            VStack(alignment: .leading) {
                Text("Aura Rengi")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Slider(value: $viewModel.userHue, in: 0...1)
                    .tint(Color(hue: viewModel.userHue, saturation: 0.8, brightness: 0.8))
            }
            
            // Frekans Slider'ı
            VStack(alignment: .leading) {
                Text("Frekans: \(Int(viewModel.userFrequency)) Hz")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Slider(value: $viewModel.userFrequency, in: 200...800) { editing in
                    if !editing {
                        // Kullanıcı slider'ı bıraktığında sesi güncelle
                        viewModel.frequencyChanged()
                    }
                }
                .tint(.white.opacity(0.7))
            }
        }
        .padding(25)
        .background(.ultraThinMaterial) // Apple tarzı buzlu cam efekti
        .cornerRadius(20)
    }
}
