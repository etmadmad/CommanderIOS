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
                
                if gameConfigVM.showBomb {
                    Button(action: {
                       showBombSheet = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: accentCustomColor))
                                .frame(width: 50, height: 50)
                            Image("bombIcon")
                                .foregroundStyle(Color(hex: darkColor))
                        }
                    }
                    .sheet(isPresented: $showBombSheet) {
                        BombSheetView()
                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.visible)
                    }
                }
  
                                  
                Spacer()
                
                Button("Leave Game") {
                    let sessionId = gameConfigVM.currentSessionId ?? gameConfigVM.roomCode
                    gameConfigVM.leaveGameSession(gameId: sessionId)
                }
                .foregroundColor(.red)
            }
            .navigationBarBackButtonHidden(true)
            .onChange(of: gameConfigVM.showSessionEndedView) { newValue in
                
                if newValue {
                    isNavigating = true
                }
            }
            .navigationDestination(isPresented: $isNavigating) {
                GameEndedView(outcome: gameConfigVM.outcome, winners: gameConfigVM.winners)
                    .environmentObject(gameConfigVM)
            }
            .padding(24)
        }
        .onAppear {
            gameConfigVM.currentUsername = profileVM.userInfo.username
            let sessionId = gameConfigVM.currentSessionId ?? gameConfigVM.roomCode
            if gameConfigVM.gameModeSession.lowercased() == "free for all" {
                gameConfigVM.getPlayersInSession(gameId: sessionId) { }
            } else {
                gameConfigVM.getPlayersInTeams(gameId: sessionId)
            }

            
            
        }
        .alert(isPresented: $showReportAlert) {
            Alert(
                title: Text("Confirm Death Report"),
                message: Text("Are you sure you want to report your elimination?"),
                primaryButton: .destructive(Text("Yes")) {
                    let sessionId = gameConfigVM.currentSessionId ?? gameConfigVM.roomCode
                    gameConfigVM.changeStatusPlayer(gameId: sessionId, newStatus: "Eliminated")
            
                    
                },
                secondaryButton: .cancel()
            )
        }
    }
}



struct BombSheetView: View {
    @StateObject private var nfcVM = NFCReaderViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("💣 Bomb Defuse")
                .font(.title)
                .bold()

            Text("Scansione NFC")
                .font(.headline)

            Button(action: {
                nfcVM.startScanning()
            }) {
                Text("🔍 Avvia Scansione")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }

            Text("Risultato: \(nfcVM.scannedText)")
                .padding()
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
