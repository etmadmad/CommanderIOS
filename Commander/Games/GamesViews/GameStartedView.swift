import SwiftUI

///  SINGLE ROW TEAM PLAYER
struct TeamPlayerRow: View {
    let player: PlayerInSessionStatus
    let currentUsername: String
    var onReportDeath: () -> Void

    private func imageURL(from path: String?) -> URL? {
        guard let p = path, !p.isEmpty else { return nil }
        if p.lowercased().hasPrefix("http") {
            return URL(string: p)
        } else {
            return URL(string: Environment.imageBaseURL + p)
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            
            if let url = imageURL(from: player.profileImage) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty: ProgressView()
                    case .success(let image): image.resizable().scaledToFill()
                    case .failure:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundColor(.gray)
                    @unknown default: EmptyView()
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            }

            
            Text(player.username)
                .font(.body)
                .foregroundColor(.white)

            Spacer()

            // Bottone Report Death solo per l’utente corrente vivo
            if player.username == currentUsername && player.playerStatus.lowercased() == "alive" {
                Button(action: { onReportDeath() }) {
                    Text("Report Death")
                        .font(.caption)
                        .padding(8)
                        .background(Color(hex: darkRed))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
        }
        .padding(.vertical, 6)
    }
}

/// CARD WHICH CONTAINS PLAYERS
struct PlayerCardSection: View {
    let players: [PlayerInSessionStatus]
    @EnvironmentObject var profileVM: ProfileViewModel
    let onReportDeath: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(players, id: \.username) { player in
                TeamPlayerRow(
                    player: player,
                    currentUsername: profileVM.userInfo.username
                ) {
                    onReportDeath(player.username)
                }
            }
        }
        .padding()
        .background(Color(hex: grayDetails))
        .cornerRadius(16)
    }
}

/// SECTION STATUS PLAYERS FOR DEAD AND ALIVE PLAYERS
struct PlayersStatusSection: View {
    let players: [PlayerInSessionStatus]
    let currentUser: String
    let onReportDeath: (String) -> Void
    
    private var alive: [PlayerInSessionStatus] {
        players.filter { $0.playerStatus.lowercased() == "alive" }
               .reordered(withCurrentUser: currentUser)
    }
    
    private var dead: [PlayerInSessionStatus] {
        players.filter { $0.playerStatus.lowercased() == "eliminated" }
               .reordered(withCurrentUser: currentUser)
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !alive.isEmpty {
                Text("Alive - \(alive.count)")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: lightGray))
                PlayerCardSection(players: alive, onReportDeath: onReportDeath)
            }
            
            if !dead.isEmpty {
                Text("Dead - \(dead.count)")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: lightGray))
                PlayerCardSection(players: dead, onReportDeath: { _ in })
            }
        }
    }
}

extension Array where Element == PlayerInSessionStatus {
    func reordered(withCurrentUser currentUser: String) -> [PlayerInSessionStatus] {
        sorted { $0.username == currentUser && $1.username != currentUser }
    }
}


struct GameStartedView: View {
    @EnvironmentObject var gameConfigVM: GameConfigurationViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    @StateObject private var nfcVM = NFCDetectViewModel()
    @State private var showReportAlert = false
    @State private var playerToReport: String?
    @State private var showBombSheet = false

    @State private var isNavigating = false

    private var players: [PlayerInSessionStatus] {
        if gameConfigVM.gameModeSession.lowercased() == "free for all" {
            return gameConfigVM.joinedPlayers
        } else {
            return gameConfigVM.membersOfMyTeam(for: profileVM.userInfo.username)
        }
    }

    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: darkColor).ignoresSafeArea()
                
                VStack {
                    Text(gameConfigVM.configurationNameSession)
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .bold))
                    
                    CountdownView(totalTime: gameConfigVM.gameTimeSession * 60)
                        .id(gameConfigVM.gameTimeSession)
                        .padding(.vertical, 10)
                    
                    PlayersStatusSection(
                        players: players,
                        currentUser: profileVM.userInfo.username,
                        onReportDeath: { username in
                            playerToReport = username
                            showReportAlert = true
                        }
                    )
                    
                    Spacer()
                    
                    Button("Leave Game") {
                        let sessionId = gameConfigVM.currentSessionId ?? gameConfigVM.roomCode
                        print("🥸 LEAVE GAME SESSION CHIAMATA DA GAME STARTED VIEW ")
                        gameConfigVM.leaveGameSession(roomCode: sessionId)
                    }
                    .foregroundColor(.red)
                }
                .padding(24)

                if gameConfigVM.showBomb {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
//                                showBombSheet = true
                                print("btn clicked")
//                                nfcVM.startScan(
                                
//                                if let bomb = gameConfigVM.bombDetails {
//                                    nfcVM.startScan(expectedBombCode: bomb.bombNfcCode,
//                                                    defuseTime: bomb.defuseTimeSeconds)
//                                    
//                                }
//                                
                                if let bomb = gameConfigVM.bombDetails {
                                    nfcVM.onBombDefused = {
                                        // 👉 chiama il metodo del GameConfigurationViewModel
//                                        gameConfigVM
                                    }
                                    
                                    nfcVM.startScan(expectedBombCode: bomb.bombNfcCode,
                                                    defuseTime: bomb.defuseTimeSeconds)
                                }



                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: accentCustomColor))
                                        .frame(width: 80, height: 80) // un po’ più grande stile FAB
                                        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 4) // ombra flottante

                                    Image("bombIcon")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30) // icona centrata
                                        .foregroundStyle(Color(hex: darkColor))
                                }
                            }
                            .padding(.trailing, 30) // margine dal bordo destro
                            .padding(.bottom, 60)   // margine dal bordo inferiore
//                            .sheet(isPresented: $showBombSheet) {
//                                BombSheetView()
//                                
//                                    .presentationDetents([.medium, .large])
//                                    .presentationDragIndicator(.visible)
//                            }
                        }
                    }
                }

                NavigationLink(
                    destination: GameEndedView(
                        outcome: gameConfigVM.outcome,
                        winners: gameConfigVM.winners,
                        winnerRaw: gameConfigVM.winnerRaw
                    ),
                    isActive: $gameConfigVM.showSessionEndedView
                ) {
                    EmptyView()
                }
                .navigationBarBackButtonHidden(true)
            }
        }
        .onAppear {
            gameConfigVM.currentUsername = profileVM.userInfo.username
            let sessionId = gameConfigVM.currentSessionId ?? gameConfigVM.roomCode
            if gameConfigVM.gameModeSession.lowercased() == "free for all" {
                gameConfigVM.getPlayersInSession(roomCode: sessionId) { }
            } else {
                gameConfigVM.getPlayersInTeams(roomCode: sessionId)
            }
        }
        .alert(isPresented: $showReportAlert) {
            Alert(
                title: Text("Confirm Death Report"),
                message: Text("Are you sure you want to report your elimination?"),
                primaryButton: .destructive(Text("Yes")) {
                    let sessionId = gameConfigVM.currentSessionId ?? gameConfigVM.roomCode
                    gameConfigVM.changeStatusPlayer(roomCode: sessionId, newStatus: "Eliminated")
                },
                secondaryButton: .cancel()
            )
        }
    }

}










