import SwiftUI


struct RoomCodeModalView: View {
    let roomName: String
    let roomCode: String
//    let descriptionRoom: String
    var onCreateTeams: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            HStack{
                Text(roomName)
                    .customFont(.bold, size: 24, hexColor: accentCustomColor)
                Text("Match")
                    .customFont(.bold, size: 24, hexColor: accentCustomColor)
            }
        
            Text("Codice di accesso:")
                .customFont(.regular, size: 20, hexColor: white)
            
            Text(roomCode)
                .onAppear {
                        print("RoomCodeModalView - Codice stanza: \(roomCode)")
                    }
                .font(.largeTitle)
                .customFont(.bold, size: 40, hexColor: accentCustomColor)
            
            Button(action: {
                onCreateTeams()
            }) {
                Text("Crea Squadre")
                    .frame(maxWidth: .infinity)
            }
            .customButton(typeBtn: .primary, width: 130, height: 60, cornerRadius: 12)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}
