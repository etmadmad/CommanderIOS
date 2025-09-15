import SwiftUI



struct TeamsSectionView: View {
    @Binding var numberItems: Int
    @Binding var membersPerTeam: [[String]]
    let colorsTeams: [String]
    
    @EnvironmentObject var gameConfigVM: GameConfigurationViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Teams")
                    .customFont(.bold, size: 30, hexColor: white)
                Spacer()

                }
            }
            .foregroundColor(.white)
            
            ScrollView(.horizontal) {
                HStack(spacing: 15) {
                    ForEach(0..<numberItems, id: \.self) { index in
                        let colorCard = colorsTeams[index % colorsTeams.count]
                        TeamsCardview(
                            teamColorCard: colorCard,
                            members: $membersPerTeam[index],
                            onMemberDropped: { member in
                                
                                if !membersPerTeam[index].contains(member) {
                                    membersPerTeam[index].append(member)
                                }
                                gameConfigVM.joinedPlayers.removeAll { $0.username == member }
                            },
                            onMemberRemoved: { member in
                                if let memberIndex = membersPerTeam[index].firstIndex(of: member) {
                                    membersPerTeam[index].remove(at: memberIndex)
                                }

                                gameConfigVM.joinedPlayers.append(
                                    PlayerInSessionStatus(
                                        username: member,
                                        profileImage: nil,
                                        playerStatus: "Alive"
                                    )
                                )
                            }
                        ) 
                    }
                }
            }
        }
    
}


struct PlayersSectionView: View {
//    @ObservedObject var gameConfigVM: GameConfigurationViewModel
    @EnvironmentObject var gameConfigVM: GameConfigurationViewModel
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Players")
                .customFont(.bold, size: 30, hexColor: white)
            
            if isLoading {
                ProgressView("Loading players...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if gameConfigVM.joinedPlayers.isEmpty {
                Text("No other players available yet.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                    ForEach(gameConfigVM.joinedPlayers, id: \.id) { player in
                        UserProfileView(player: player)
                            .onDrag {
                                NSItemProvider(object: player.username as NSString)
                            }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

struct ManageTeamsView: View {
    let roomName: String
    let gameMode: String
    let sessionCode: String
    @State private var isGameStarted = false
    
    @State private var numberItems: Int = 2
    @EnvironmentObject var gameConfigVM: GameConfigurationViewModel
    @State private var membersPerTeam: [[String]] = [[], []]
    @State private var isLoading = true
    
    var colorsTeams: [String] = ["#F84848", "487DF8", "EA33F7", "75FBFD", "F19E39"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: darkColor)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    TeamsSectionView(numberItems: $numberItems, membersPerTeam: $membersPerTeam, colorsTeams: colorsTeams)
                    
                    PlayersSectionView(isLoading: $isLoading)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 100)
            }

            
            StartRoomBarView(
                nameRoom: roomName,
                typeRoom: gameMode,
                sessionCode: sessionCode,
                goToGameStarted: $gameConfigVM.isGameStarted,
                membersPerTeam: $membersPerTeam,
                requiresTeams: true
            )

        }
        
        
        .onAppear {
            isLoading = true
            
            /// RETRIEVES THE PLAYERS WHO JOINED WHILE ADMIN WAS STILL IN ROOM CODE MODAL SHEET
            gameConfigVM.getPlayersInSession(gameId: sessionCode) {
                
                /// CREATES TEAMS IF NON EXISTENT
                gameConfigVM.getPlayersInTeams(gameId: sessionCode)
                
                if gameConfigVM.playersInTeams.isEmpty {
                    gameConfigVM.createTeams(gameId: sessionCode, teamName: "Team 1") { success1 in
                        if success1 {
                            gameConfigVM.createTeams(gameId: sessionCode, teamName: "Team 2") { success2 in
                                if success2 {
                                    gameConfigVM.getPlayersInTeams(gameId: sessionCode)
                                    isLoading = false
                                    
                                }
                            }
                        }
                    }
                } else {
                    isLoading = false
                }
                
            }
        }
        
        /// ADDED THIS 
        .onDisappear() {
            if !gameConfigVM.isGameStarted {
                gameConfigVM.leaveGameSession(gameId: sessionCode)
            }
        }
        
        
        
        
        .alert(isPresented: $gameConfigVM.showAlert) {
            Alert(
                title: Text("Unassigned Players"),
                message: Text("Please assign all players to a team before starting the game."),
                dismissButton: .default(Text("OK"))
            )
        }
        
        
    }
    
}
    
    
struct StartRoomBarView: View {
    let nameRoom: String
    let typeRoom: String
    let sessionCode: String
    @Binding var goToGameStarted: Bool
    @EnvironmentObject var gameConfigVM: GameConfigurationViewModel
    
    
    @Binding var membersPerTeam: [[String]]
    var requiresTeams: Bool = true
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(hex: grayDetails))
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(edges: .horizontal)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(nameRoom)
                        .foregroundStyle(Color.white)
                    Text(typeRoom)
                        .foregroundStyle(Color.white.opacity(0.8))
                }
                
                Spacer()
                
                Button(action: {
                    let sessionId = gameConfigVM.currentSessionId ?? sessionCode
                    guard !sessionId.isEmpty else {
                        print("Session ID non disponibile.")
                        return
                    }
                    
                    if requiresTeams {
                        
                        let assignedPlayersCount = membersPerTeam.flatMap { $0 }.count
                        let totalJoinedPlayers = gameConfigVM.joinedPlayers.count

                        
                        if assignedPlayersCount < totalJoinedPlayers {
                            gameConfigVM.errorMessage = "Per favore, assegna tutti i giocatori a una squadra prima di iniziare."
                            gameConfigVM.showAlert = true
                            return
                        }
                        
                        
                        let dispatchGroup = DispatchGroup()
                        var successfulAssignments = 0
                        
                        for (index, teamMembers) in membersPerTeam.enumerated() {
                            guard index < gameConfigVM.teams.count,
                                  let teamId = gameConfigVM.teams[index].id else { continue }
                            
                            for username in teamMembers {
                                dispatchGroup.enter()
                                gameConfigVM.assignPlayerToTeam(username: username, gameId: sessionId, teamId: teamId) { success in
                                    if success { successfulAssignments += 1 }
                                    dispatchGroup.leave()
                                }
                            }
                        }
                        
                        dispatchGroup.notify(queue: .main) {
                            let totalToAssign = membersPerTeam.flatMap { $0 }.count
                            if successfulAssignments == totalToAssign {
                                gameConfigVM.getSessionConfiguration(gameId: sessionId)
                                gameConfigVM.startSession(gameId: sessionId)
                            } else {
                                gameConfigVM.errorMessage = "Alcuni giocatori non sono stati assegnati correttamente. Riprova."
                                gameConfigVM.showAlert = true
                            }
                        }
                    } else {
                        /// FOR FREE FOR ALL
                        gameConfigVM.getSessionConfiguration(gameId: sessionId)
                        gameConfigVM.startSession(gameId: sessionId)
                    }
                    
                }) {
                    Text("Start Room")
                        .customButton(
                            typeBtn: .primary,
                            width: 120,
                            height: 45,
                            cornerRadius: 15
                        )
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

        


struct FreeForAllLobbyView: View {
    let roomName: String
    let gameMode: String
    let sessionCode: String
    @State private var isGameStarted = false
    
    @State private var numberItems: Int = 2
    @State private var membersPerTeam: [[String]] = [[], []]
    @State private var isLoading = true
    @EnvironmentObject var gameConfigVM: GameConfigurationViewModel
    //    @Environment(\.dismiss) var dismiss
    @State private var isStarting = false
    
    var body: some View {
        ZStack {
            Color(hex: darkColor).ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("Waiting for Players")
                    .foregroundStyle(Color(hex: white))
                Text(roomName)
                    .customFont(.bold, size: 22, hexColor: accentCustomColor)
                
                Text("Players joined: \(gameConfigVM.joinedPlayers.count)")
                    .foregroundColor(.white.opacity(0.9))
                
                ScrollView {
                    VStack(spacing: 12) {
                        
                        ForEach(gameConfigVM.joinedPlayers, id: \.username) { p in
                            HStack(spacing: 12) {
                                if let urlStr = p.profileImage, let url = URL(string: urlStr) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                           case .empty: ProgressView()
                                           case .success(let image): image.resizable().scaledToFill()
                                           case .failure: Image(systemName: "person.crop.circle.fill").resizable()
                                           @unknown default: EmptyView()
                                           }
                                        
                                    }
                                    .frame(width: 44, height: 44)
                                    .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                }

                                VStack(alignment: .leading) {
                                    Text(p.username).foregroundColor(.white)
                                    Text(p.playerStatus).foregroundColor(.gray).font(.caption)
                                }
                                Spacer()
                            }
                        }

                    }
                    .padding(.vertical, 8)
                }
                .frame(maxHeight: 320)
                
                Spacer()
                
//                Button(action: {
//                    // preferiamo usare currentSessionId (impostata alla creazione sessione)
//                    let sessionId = gameConfigVM.currentSessionId ?? sessionCode
//                    guard !sessionId.isEmpty else {
//                        print("Session ID non disponibile.")
//                        return
//                    }
//                
//                        gameConfigVM.getSessionConfiguration(gameId: sessionId)
//                        gameConfigVM.startSession(gameId: sessionId)
//                            
//               
//                    }
//                ) {
//                    Text("Start Room")
//                        .customButton(
//                            typeBtn: .primary,
//                            width: 120,
//                            height: 45,
//                            cornerRadius: 15
//                        )
//
                
                StartRoomBarView(
                    nameRoom: roomName,
                    typeRoom: gameMode,
                    sessionCode: sessionCode,
                    goToGameStarted: $isGameStarted,
                    membersPerTeam: .constant([]), // placeholder, non usato
                    requiresTeams: false
                )

                    
                    
                }
                .padding()
            }
            .onAppear {
                // inizializza lista (poi gli eventi WS aggiorneranno joinedPlayers)
                gameConfigVM.getPlayersInSession(gameId: sessionCode) { }
            }
        }
    
}
