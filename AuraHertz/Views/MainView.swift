//
//  MainView.swift
//  AuraHertz
//
//  Created by BERKAY TURAN on 16.04.2026.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @EnvironmentObject var viewModel: AuraHertzViewModel
    @Environment(\.modelContext) private var modelContext
    @StateObject private var shareService = ShareService()
    @State private var isDiaryPresented = false
    
    var body: some View {
        ZStack {
            // Arka plan rengi kullanıcı aurasına göre değişir
            Color(hue: viewModel.userHue, saturation: 0.7, brightness: 0.5)
                .ignoresSafeArea()
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.userHue)
            
            VStack(spacing: 15) {
                // Üst Bar: Seviye ve Günlük
                HStack {
                    Text("SEVİYE \(viewModel.level)")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Spacer()
                    
                    Button(action: { isDiaryPresented.toggle() }) {
                        Image(systemName: "book.pages")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                Spacer()
                
                Text("HEDEF AURA")
                    .font(.caption)
                    .tracking(4)
                    .foregroundColor(.white.opacity(0.7))
                
                Text(viewModel.currentMood.description)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Mikrofon konuşması anlık metni
                if !viewModel.currentTranscription.isEmpty {
                    Text(viewModel.currentTranscription)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                        .transition(.slide.combined(with: .opacity))
                        .padding(.horizontal)
                }
                
                // Aura Dalga Animasyonu
                WaveformView(frequency: viewModel.userFrequency, hue: viewModel.userHue)
                    .frame(height: 80)
                    .padding(.vertical, 10)
                
                // Senkronizasyon Yüzdesi
                VStack {
                    Text("%\(viewModel.matchScore)")
                        .font(.system(size: 72, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .contentTransition(.numericText())
                        .animation(.easeInOut, value: viewModel.matchScore)
                    
                    Text("Senkronizasyon")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // OYUN DURUMU KONTROLÜ
                if viewModel.showSuccess {
                    // BAŞARI EKRANI
                    VStack(spacing: 20) {
                        Text("SENKRONİZASYON TAMAM! ✨")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                        
                        // Edebi Aura Raporu Kutusu (KAYDIRILABİLİR GÜNCELLEME)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("AURA ANALİZİN")
                                .font(.caption)
                                .tracking(2)
                                .foregroundColor(.white.opacity(0.6))
                            
                            ScrollView(showsIndicators: true) {
                                Text(viewModel.currentMood.detailedReport)
                                    .font(.system(.subheadline, design: .serif))
                                    .italic()
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(4)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxHeight: 120) // Yazı uzunsa kaydırılabilir, butonları aşağı itmez
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        
                        HStack(spacing: 15) {
                            // Kaydet Butonu
                            Button(action: {
                                saveToDiary()
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                            }) {
                                HStack {
                                    Image(systemName: "bookmark.fill")
                                    Text("Kaydet")
                                }
                                .padding()
                                .background(Color.blue.opacity(0.6))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                            }
                            
                            // Paylaş Butonu
                            if let imageToShare = shareService.renderedImage {
                                ShareLink(item: imageToShare, preview: SharePreview("AuraHertz Kaydım", image: imageToShare)) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.up")
                                        Text("Paylaş")
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                }
                            }
                        }
                        
                        // Sonraki Seviye Butonu
                        Button(action: {
                            viewModel.prepareForNextLevel()
                        }) {
                            Text("Sonraki Seviyeye Geç")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(15)
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                        // Arayüzün oturması için küçük bir bekleme
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            shareService.renderAuraCard(
                                mood: viewModel.currentMood.description,
                                hue: viewModel.userHue,
                                frequency: viewModel.userFrequency,
                                score: viewModel.matchScore
                            )
                        }
                    }
                    
                } else if viewModel.level > 1 && viewModel.currentMood.description == "Anlat, seni dinliyorum..." {
                    // Mikrofon Aşaması
                    SpeechMicrophoneButton(viewModel: viewModel)
                        .transition(.move(edge: .bottom))
                } else {
                    // Manuel Ayar Aşaması (Sliderlar)
                    ControlSlidersView()
                        .padding(.horizontal, 20)
                        .transition(.slide)
                }
                
                Spacer().frame(height: 10)
            }
        }
        .animation(.default, value: viewModel.showSuccess)
        .animation(.default, value: viewModel.isSpeechRecording)
        .sheet(isPresented: $isDiaryPresented) {
            DiaryView()
        }
    }
    
    private func saveToDiary() {
        let newAura = PersistentAura(
            moodDescription: viewModel.currentMood.description,
            hue: viewModel.userHue,
            frequency: viewModel.userFrequency,
            score: viewModel.matchScore
        )
        modelContext.insert(newAura)
    }
}

#Preview {
    MainView()
        .environmentObject(AuraHertzViewModel())
}
