//
//  WaveformView.swift
//  AuraHertz
//
//  Created by BERKAY TURAN on 16.04.2026.
//

import SwiftUI

struct WaveformView: View {
    var frequency: Double
    var hue: Double
    
    var body: some View {
        // TimelineView ile 60FPS kesintisiz animasyon sağlıyoruz
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let timeNow = timeline.date.timeIntervalSinceReferenceDate
                let speed = frequency / 100.0 // Frekansa göre dalga hızı
                let angle = timeNow * speed * .pi * 2.0
                
                var path = Path()
                let width = size.width
                let height = size.height
                let midHeight = height / 2
                
                // Dalga genliği (Amplitude)
                let wavelength = width / (frequency / 100.0)
                let amplitude = 40.0
                
                path.move(to: CGPoint(x: 0, y: midHeight))
                
                for x in stride(from: 0, through: width, by: 1) {
                    let relativeX = x / wavelength
                    let sine = sin(relativeX * .pi * 2 + angle)
                    let y = amplitude * sine + midHeight
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                
                context.stroke(
                    path,
                    with: .color(Color(hue: hue, saturation: 1.0, brightness: 1.0)),
                    lineWidth: 4
                )
            }
        }
        .frame(height: 100)
        // Parlama efekti
        .shadow(color: Color(hue: hue, saturation: 1.0, brightness: 1.0).opacity(0.8), radius: 10, x: 0, y: 0)
    }
}
