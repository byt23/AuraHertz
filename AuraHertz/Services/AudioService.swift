//
//  AudioService.swift
//  AuraHertz
//
//  Created by BERKAY TURAN on 16.04.2026.
//

import Foundation
import AVFoundation

class AudioService {
    private var engine: AVAudioEngine?
    private var sourceNode: AVAudioSourceNode?
    private var isPlaying = false
    var currentFrequency: Double = 440.0
    
    // init() içini boş bıraktık. Sadece çalacağımız zaman motoru kuracağız.
    init() {}
    
    private func setupAudioEngine() {
        let session = AVAudioSession.sharedInstance()
        // UYARI GİDERİLDİ: allowBluetoothHFP olarak güncellendi
        try? session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothHFP, .mixWithOthers])
        try? session.setActive(true)
        
        engine = AVAudioEngine()
        guard let engine = engine else { return }
        
        let format = engine.outputNode.inputFormat(forBus: 0)
        let sampleRate = Float(format.sampleRate == 0 ? 44100.0 : format.sampleRate)
        var phase: Float = 0.0
        
        sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                let value = sin(phase)
                phase += Float(self.currentFrequency) * 2.0 * .pi / sampleRate
                if phase >= 2.0 * .pi { phase -= 2.0 * .pi }
                
                for buffer in ablPointer {
                    let buf = UnsafeMutableBufferPointer<Float>(buffer)
                    buf[frame] = value * 0.1
                }
            }
            return noErr
        }
        
        if let sourceNode = sourceNode {
            engine.attach(sourceNode)
            engine.connect(sourceNode, to: engine.mainMixerNode, format: format)
        }
    }
    
    func playTone(frequency: Double) {
        currentFrequency = frequency
        if !isPlaying {
            if engine == nil { setupAudioEngine() } // Sadece lazımsa çalıştır
            try? engine?.start()
            isPlaying = true
        }
    }
    
    func stopTone() {
        // ÇÖZÜM: İşi bitince motoru durdur, sıfırla ve hafızadan tamamen sil.
        // Böylece SpeechService (Mikrofon) ile asla kavga edemeyecek.
        engine?.stop()
        engine?.reset()
        engine = nil
        sourceNode = nil
        isPlaying = false
    }
}
