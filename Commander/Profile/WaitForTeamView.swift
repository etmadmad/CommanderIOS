//import SwiftUI
//
//struct WaitingForTeamsView: View {
//    let roomName: String
//    let roomCode: String
//
//    var body: some View {
//        ZStack {
//            Color(hex: darkColor)
//                .ignoresSafeArea()
//
//            VStack(spacing: 32) {
//                Text(roomName)
//                    .customFont(.bold, size: 35, hexColor: accentCustomColor)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                VStack(spacing: 12) {
//                    Text("Codice stanza")
//                        .customFont(.semibold, size: 18, hexColor: "AAAAAA")
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    Text(roomCode)
//                        .customFont(.bold, size: 28, hexColor: accentCustomColor)
//                        .padding(.bottom, 8)
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//
//                Spacer()
//
//                VStack(spacing: 20) {
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: accentCustomColor)))
//                        .scaleEffect(1.5)
//                    
//                    Text("In attesa che l'admin crei le squadre...")
//                        .customFont(.bold, size: 24, hexColor: white)
//                        .multilineTextAlignment(.center)
//                    
//                    Text("Appena le squadre saranno pronte, potrai partecipare alla partita.")
//                        .customFont(.regular, size: 17, hexColor: grayDetails)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal)
//                }
//
//                Spacer()
//            }
//            .padding(24)
//        }
//    }
//}
//#Preview {
//    WaitingForTeamsView(roomName: "Room Epica", roomCode: "ABC123")
//}
//


import SwiftUI

struct WaitingForTeamsView: View {
    let roomName: String
    let roomCode: String
//    let descriptionRoom: String

    var body: some View {
        ZStack {
            Color(hex: darkColor)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Text(roomName)
                    .customFont(.bold, size: 35, hexColor: accentCustomColor)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(roomName)
                    .customFont(.bold, size: 35, hexColor: accentCustomColor)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 12) {
                 
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                VStack(spacing: 20) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: accentCustomColor)))
                        .scaleEffect(1.5)
                    
                    Text("Waiting for the admin to create the teams...")
                        .customFont(.bold, size: 24, hexColor: white)
                        .multilineTextAlignment(.center)
                    
                    Text("As soon as the teams are ready, you will be able to join the match.")
                        .customFont(.regular, size: 17, hexColor: grayDetails)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding(24)
        }
    }
}

//
//#Preview {
//    WaitingForTeamsView(roomName: "Epic Room", roomCode: "ABC123")
//}
