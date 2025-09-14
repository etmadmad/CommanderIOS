import SwiftUI

struct GameJoinView: View {
    @EnvironmentObject var gameConfigVM: GameConfigurationViewModel
    @State private var shouldNavigate = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: darkColor)
                    .ignoresSafeArea()
                
                VStack() {
                    Spacer()
                    
                    Text("Commander")
                        .customFont(.bold, size: 30, hexColor: accentCustomColor)
                        .frame(alignment: .center)
                    
                    
                    VStack(spacing: 8) {
                        InputView(inputText: $gameConfigVM.roomCode, inputName: "", placeholder: "Enter Room Code")
                        
                        if gameConfigVM.triedToJoin && gameConfigVM.roomCode.isEmpty {
                            Text("Room not available")
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.subheadline)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    
                    Button(action: {
                        print("JOIN ROOM CLICKED")
                        gameConfigVM.joinGame()
                        
                    }) {
                        Text("Join Room")
                    }
                    .customButton(
                        typeBtn: .primary,
                        width: 140,
                        height: 44,
                        cornerRadius: 12
                    )
                    .padding(.top, 8)
                    
                    NavigationLink(
                        destination: WaitingForTeamsView(
                            //                           gameConfigVM: gameConfigVM,
                            
                            
                            
                        ),
                        isActive: $shouldNavigate
                    ) {
                        EmptyView()
                    }
                    
                    let allGames = gameConfigVM.gameConfigurationModel.founderGames + gameConfigVM.gameConfigurationModel.adminGames
                    
                    let useScroll = allGames.count >= 4
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Rooms")
                            .font(.system(size: 25, weight: .bold, design: .default))
                            .foregroundStyle(.white)
                        
                        if useScroll {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.05))
                                
                                ScrollView {
                                    LazyVStack(spacing: 16) {
                                        ForEach(allGames, id: \.id) { game in
                                            YourRoomsView(game: game)
                                            Divider()
                                        }
                                    }
                                    .padding()
                                }
                            }
                            .frame(maxHeight: 290) // Limita se necessario
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.05))
                                
                                LazyVStack(spacing: 16) {
                                    ForEach(allGames, id: \.id) { game in
                                        YourRoomsView(game: game)
                                        Divider()
                                            .background(Color(hex: "AAAAAA"))
                                        
                                    }
                                }
                                .padding()
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .frame(maxHeight: 290)
                        }
                        
                    }
                    .padding(.top, 24)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                
            }
            
            /// FOR ADMINS & FOUNDERS
            /// FREE FOR ALL AND OTHER GAME CONFIG
            .navigationDestination(isPresented: $gameConfigVM.goToManageTeams) {
                ManageTeamsView(
                    roomName: gameConfigVM.configurationNameSession,
                    gameMode: gameConfigVM.gameModeSession,
                    sessionCode: gameConfigVM.currentSessionId ?? ""
                )
                .environmentObject(gameConfigVM)
            }
                .navigationDestination(isPresented: $gameConfigVM.goToLobbyFFA){
                    FreeForAllLobbyView(
                        roomName: gameConfigVM.configurationNameSession, gameMode: gameConfigVM.gameModeSession, sessionCode: gameConfigVM.currentSessionId ?? ""
                    )
                }
                
                /// FOR NON-ADMINS $ NON-FOUNDERS
                .onChange(of: gameConfigVM.didJoinSuccessfully) { success in
                    if success {
                        shouldNavigate = true
                    }
                }
                
            }
        }
    }
    

