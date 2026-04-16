//
//  SentimentService.swift
//  AuraHertz
//
//  Created by BERKAY TURAN on 16.04.2026.
//

import Foundation

class SentimentService {
    
    func analyze(text: String) -> Mood {
        let lowercasedText = text.lowercased()
        
        // 1. Durum: Yoğun, Düşünceli, Melankolik
        if lowercasedText.contains("üzgün") || lowercasedText.contains("kötü") || lowercasedText.contains("yalnız") || lowercasedText.contains("sıkkın") {
            return Mood(
                description: "Derin ve Düşünceli",
                targetHue: 0.6, // Koyu Mavi
                targetFrequency: 396.0,
                detailedReport: "Tıpkı bir Dostoyevski romanındaki karakterler gibi, içinde fırtınalar kopan ama dışarıya sessiz bir duvar örmüş gibisin. Bu derin iç hesaplaşma yorucu olabilir, ama aynı zamanda ruhunun en çok olgunlaştığı yer de burasıdır. Auranı 396 Hz'in iyileştirici titreşimleriyle dengelemeye çalış."
            )
        }
        // 2. Durum: Enerjik, Heyecanlı, Güçlü
        else if lowercasedText.contains("mutlu") || lowercasedText.contains("harika") || lowercasedText.contains("enerjik") || lowercasedText.contains("iyi") || lowercasedText.contains("süper") {
            return Mood(
                description: "Coşkulu ve Aydınlık",
                targetHue: 0.15, // Sarı / Turuncu
                targetFrequency: 528.0,
                detailedReport: "İçinde destansı bir tarihi kurgunun en zafer dolu sahnesi yaşanıyor adeta. Rüzgarı arkana almış, umut dolu ve sarsılmaz bir enerji yayıyorsun. Bu altın rengi auranı 528 Hz frekansı ile etrafındaki herkese bulaştırabilirsin."
            )
        }
        // 3. Durum: Yorgun, Stresli
        else if lowercasedText.contains("yoruldum") || lowercasedText.contains("stres") || lowercasedText.contains("baskı") || lowercasedText.contains("uyku") {
            return Mood(
                description: "Sisli ve Yorgun",
                targetHue: 0.8, // Mor
                targetFrequency: 417.0,
                detailedReport: "Denizsiz bir şehrin gri sabahları gibi hissediyorsun... Omuzlarında görünmez bir ağırlık var. Livaneli'nin hüzünlü melodilerindeki o dinginliğe ve kabullenişe ihtiyacın var. 417 Hz frekansı, zihnindeki bu yoğun sisi dağıtmak için en doğru anahtar."
            )
        }
        // Başlangıç veya Nötr Durum
        else {
            return Mood(
                description: "Dengeli ve Sakin",
                targetHue: 0.4, // Yeşil
                targetFrequency: 432.0,
                detailedReport: "Kendi merkezindesin. Ne çok yükseklerde uçuyor ne de derinlere iniyorsun. Evrenin doğal rezonansı olan 432 Hz ile uyumlanıp bu dingin anın tadını çıkar."
            )
        }
    }
}
