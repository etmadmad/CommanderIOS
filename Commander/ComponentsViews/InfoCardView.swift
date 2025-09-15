////
////  InfoCard.swift
////  Commander
////
////  Created by ethimad on 11/09/25.
////
//
//import SwiftUI
//
//struct InfoCardView: View {
//    let title: String
//    let value: String
//    var sfSymbol: String? = nil   // ← nome del simbolo SF
//    var showIcon: Bool = false    // ← flag per abilitare l'icona
//
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color.gray.opacity(0.2))
//                .frame(height: 80)
//
//            HStack(spacing: 12) {
//                // Mostra l'icona solo se abilitata
//                if showIcon, let symbol = sfSymbol {
//                    Image(systemName: sfSymbol ?? "")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 24, height: 24)
//                        .foregroundStyle(Color.white)
//                }
//
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(title)
//                        .customFont(.semibold, size: 14, hexColor: "AAAAAA")
//                    Text(value)
//                        .customFont(.regular, size: 18, hexColor: "FFFFFF")
//                }
//
//                Spacer()
//            }
//            .padding(.horizontal, 16)
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//}





import SwiftUI


struct InfoCardView: View {
    let title: String
    let value: String
    var iconName: String? = nil           // ← nome immagine o SF Symbol
    var isSFSymbol: Bool = false          // ← specifica se è un SF Symbol

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 80)

            HStack(spacing: 12) {
                // Mostra l’icona se fornita
                if let iconName = iconName {
                    if isSFSymbol {
                        Image(systemName: iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .padding(.trailing, 4)
                    } else {
                        Image(iconName) // ← carica immagine da Assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .foregroundStyle(Color.white)
                    Text(value)
                        .font(.system(size: 20, weight: .regular, design: .default))
                        .foregroundStyle(Color.white)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
