//
//  DiaryView.swift
//  AuraHertz
//
//  Created by BERKAY TURAN on 16.04.2026.
//

import SwiftUI
import SwiftData

struct DiaryView: View {
    // Veritabanındaki kayıtları tarihe göre yeninden eskiye sıralar
    @Query(sort: \PersistentAura.date, order: .reverse) var pastAuras: [PersistentAura]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if pastAuras.isEmpty {
                    Text("Henüz kaydedilmiş bir Aura yok.")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(pastAuras) { aura in
                            HStack(spacing: 15) {
                                Circle()
                                    .fill(Color(hue: aura.hue, saturation: 0.8, brightness: 0.8))
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading) {
                                    Text(aura.moodDescription)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("\(aura.date, style: .date) - \(Int(aura.frequency)) Hz")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text("%\(aura.score)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .listRowBackground(Color.white.opacity(0.1))
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Aura Günlüğü")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Kapat") { dismiss() }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
