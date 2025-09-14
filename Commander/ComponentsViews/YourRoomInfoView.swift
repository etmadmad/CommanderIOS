import SwiftUI

struct RoomCodeWrapper: Identifiable {
    let id = UUID()
    let code: String
}

struct YourRoomsView: View {
    let game: FounderGame
    @EnvironmentObject var gameConfigVM: GameConfigurationViewModel
    @State private var sessionRoomCode: RoomCodeWrapper? = nil
    
    @State private var showRoomModal = false
    @State private var showFreeForAllLobby = false
    @State private var sessionIdForLobby: String = ""
    @State private var roomTitleForLobby: String = ""
//    @EnvironmentObject var gameConfigVM: GameConfigurationViewModel

    
    @State private var didClickBtnModal = false
    
    var radius: CGFloat = 30
    var squareSide: CGFloat {
        2.0.squareRoot() * radius
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Icona modalità
            ZStack {
                Circle()
                    .fill(Color(hex: darkColor))
                    .frame(width: radius * 2, height: radius * 2)
                
                if game.game_mode_name == "Free for All" {
                    Image("swordsIcon")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: squareSide * 0.8, height: squareSide * 0.8)
                        .foregroundStyle(Color(hex: swordsColor))
                } else if game.game_mode_name == "Bomb Defuse" {
                    Image("bombIcon")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: squareSide * 0.8, height: squareSide * 0.8)
                        .foregroundStyle(Color(hex: bombColor))
                } else if game.game_mode_name == "Team Deathmatch" {
                    Image("skullIcon")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: squareSide * 0.8, height: squareSide * 0.8)
                        .foregroundStyle(Color(hex: skullColor))
                }
            }
            
            // Titolo e sottotitolo
            VStack(alignment: .leading, spacing: 4) {
                Text(game.configurationName)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(Color(hex: white))
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text(game.game_mode_name)
                    .font(.system(size: 14, weight: .light))
                    .foregroundStyle(Color(hex: white))
            }
            
            Spacer()
            
            // Bottone Play
            Button {
                gameConfigVM.createGameSession(gameId: game.id) { session in
                    guard let session = session else {
                        print("Errore nella creazione della sessione")
                        return
                    }
                    DispatchQueue.main.async {
                        if !session.session_room_code.isEmpty {
                            sessionRoomCode = RoomCodeWrapper(code: session.session_room_code)
                        }
                    }
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color(hex: white))
                        .frame(width: radius * 1.5, height: radius * 1.5)
                    
                    Image(systemName: "play.fill")
                        .foregroundStyle(Color(hex: darkColor))
                }
            }
            .padding(.trailing, 10)
                        .sheet(item: $sessionRoomCode, onDismiss: {
        
                            didClickBtnModal = false
                        }) { wrapper in
                            RoomCodeModalView(
                                roomName: game.configurationName,
                                gameModeRoom: game.game_mode_name,
                                maxPlayersRoom: game.maxPlayers,
                                durationRoom: game.matchDurationMinutes,
                                roomCode: wrapper.code
                            ) {
                                
                                didClickBtnModal = true
                                gameConfigVM.goToManageTeams = true
                                sessionRoomCode = nil
                            }
//                            } onStartGame: {
//
//                                didClickBtnModal = true
//                                gameConfigVM.isGameStarted = true
//                                sessionRoomCode = nil
//                            }
                            onJoin: {
                                // join premuto in RoomCodeModalView -> chiudo modal e apro lobby (solo admin dovrebbe arrivare qui)
                                didClickBtnModal = true
                                gameConfigVM.goToLobbyFFA = true
                                sessionRoomCode = nil
                            }
                            .interactiveDismissDisabled(false)
                        }

                    }

        }
    }
    
    
    
    
    
    
    

