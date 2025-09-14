import SwiftUI


struct RoomCodeModalView: View {
    let roomName: String
    let gameModeRoom: String
    let maxPlayersRoom: Int
    let durationRoom: Int
    let roomCode: String
    var onCreateTeams: () -> Void
//    var onStartGame: () -> Void
    var onJoin: () -> Void

    ///AGGIUNTI
    @State private var isNavigating = false
    @EnvironmentObject var gameConfigVM: GameConfigurationViewModel
    
    
    var body: some View {
        ZStack{
            Color(hex: darkColor)
                .ignoresSafeArea()
            
            
            VStack() {
                Spacer()
                Text(roomName)
                    .customFont(.bold, size: 24, hexColor: accentCustomColor)
                
                Group{
                    InfoCardView(
                        title: "Game Mode",
                        value: "\(gameModeRoom)",
                        iconName: "swordsIcon",
                        isSFSymbol: false
                        
                    )
                    
                    InfoCardView(
                        title: "Max players",
                        value: "\(maxPlayersRoom)" + " players",
                        iconName: "person.fill",
                        isSFSymbol: true
                        
                        
                    )
                    
                    InfoCardView(
                        title: "Duration",
                        value: "\(durationRoom)" + " minutes",
                        iconName: "clock",
                        isSFSymbol: true
                        
                        
                    )
                }
                .frame(width: 350)
                
                Spacer()
                
                Text("Room Code:")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(Color(hex: "AAAAAA"))
                
                HStack{
                    
                    
                    
                    Text(roomCode)
                        .font(.system(size: 40, weight: .medium))
                        .foregroundStyle(Color.white)
                    
                    Button(action: {
                        UIPasteboard.general.string = roomCode
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(Color(hex: white))
                            .font(.title2)
                    }
                    ShareLink(item: roomCode) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(Color(hex: white))
                            .font(.title2)
                    }
                }
                
                
                Button(action: {
                    if gameModeRoom == "Free for All" {
                        isNavigating = true
                        

//                        if let sessionId = gameConfigVM.currentSessionId {
//                                   gameConfigVM.getSessionConfiguration(gameId: sessionId)
//                                gameConfigVM.startSession(gameId: sessionId)
//                               }
                        
//                               onStartGame()
                        onJoin()
                        
                    }else {
                        isNavigating = true
                        onCreateTeams()
                    }
                }) {
                    Text(gameModeRoom == "Free for All" ? "Join Game" : "Create Teams")
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundStyle(Color(hex: darkColor))
                }
                .customButton(typeBtn: .primary, width: 350, height: 50, cornerRadius: 12)
                .padding(.horizontal)
                Spacer()
            }
            .padding()
        }
        
        
        
        .onDisappear{
            if !isNavigating {
                if let sessionId = gameConfigVM.currentSessionId,
                   sessionId == roomCode,
                   !gameConfigVM.isGameStarted {
                    print("Leaving session from onDisappear in RoomCodeModalView (session not started yet)")
                    gameConfigVM.leaveGameSession(gameId: sessionId)
                } else {
                    print("Not leaving session on onDisappear — either session started or sessionId mismatch.")
                }
            }
            
        }}
}
