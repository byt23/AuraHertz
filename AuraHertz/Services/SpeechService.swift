//
//  SpeechService.swift
//  AuraHertz
//
//  Created by BERKAY TURAN on 16.04.2026.
//

import Foundation
import Speech
import AVFoundation

class SpeechService {
    enum SpeechError: Error {
        case notAuthorized
        case recognizerUnavailable
        case engineInitializationFailed
    }
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "tr-TR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var onTranscriptionUpdate: ((String) -> Void)?
    var isRecording = false
    
    func startRecording(completion: @escaping @Sendable (Result<String, SpeechError>) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self.performRecording(completion: completion)
                default:
                    completion(.failure(.notAuthorized))
                }
            }
        }
    }
    
    private func performRecording(completion: @escaping @Sendable (Result<String, SpeechError>) -> Void) {
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            completion(.failure(.recognizerUnavailable))
            return
        }
        
        stopRecording()
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            completion(.failure(.engineInitializationFailed))
            return
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        // UYARI GİDERİLDİ: allowBluetoothHFP olarak güncellendi
        try? audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothHFP, .mixWithOthers])
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        let inputNode = audioEngine.inputNode
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.onTranscriptionUpdate?(result.bestTranscription.formattedString)
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.stopRecording()
                if let finalResult = result?.bestTranscription.formattedString {
                    completion(.success(finalResult))
                }
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
        isRecording = true
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        isRecording = false
    }
}
