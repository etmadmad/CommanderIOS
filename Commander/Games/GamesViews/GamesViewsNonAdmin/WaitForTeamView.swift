

import SwiftUI

struct WaitingForTeamsView: View {
    @EnvironmentObject var gameConfigVM: GameConfigurationViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    
    var body: some View {
        ZStack {
            Color(hex: darkColor)
                .ignoresSafeArea()
            
            VStack() {
                
                Spacer()
                
                VStack(){
                    
                    Text(gameConfigVM.configurationNameSession)
                        .font(.system(size: 25, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundStyle(Color(hex: accentCustomColor))
                    Text("Waiting for the admin to create the teams...")
                        .font(.system(size: 12, weight: .regular))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: accentCustomColor)))
                        .scaleEffect(1.5)
                    
                    GameSummaryCardView(
//                        gameConfigVM: gameConfigVM,
                        darkColor: darkColor,
                        accentCustomColor: accentCustomColor
                    )
                    
                    
                    
                }
                Spacer()
                
                Spacer()
            }
            
            
            .padding(24)
        }
        .onDisappear {
        
            
            if let sessionId = gameConfigVM.currentSessionId {
                if gameConfigVM.isGameStarted {
                    // Il gioco è iniziato → non abbandonare la sessione
                    print("🚀 Game started, non lascio la sessione")
                } else {
                    // L’utente ha lasciato manualmente → eseguo il leave
                    print("👋 User left WaitingForTeamsView manualmente, chiamo leaveGameSession")
                    gameConfigVM.leaveGameSession(roomCode: sessionId)
                }}
        }
        .navigationDestination(isPresented: $gameConfigVM.isGameStarted) {
           GameStartedView()
            .environmentObject(gameConfigVM)
            .environmentObject(profileVM)
        }
        
        
        
    }
}
    
    
    struct GameSummaryCardView: View {
        @EnvironmentObject var gameConfigVM: GameConfigurationViewModel
        /// MODFICIATO
        let darkColor: String
        let accentCustomColor: String
        
        var body: some View {
            VStack(spacing: 15) {
                
                GameInfoRow(
                    title: "Game Mode",
                    value: gameConfigVM.gameModeSession,
                    iconName: "swordsIcon",
                    isSFSymbol: false,
                    accentColor: Color(hex: accentCustomColor)
                )
                
                Divider()
                    .background(Color.gray.opacity(0.5))
                
                
                GameInfoRow(
                    title: "Max players",
                    value: "\(gameConfigVM.maxPlayersSession) players",
                    iconName: "person.fill",
                    isSFSymbol: true,
                    accentColor: Color(hex: accentCustomColor)
                )
                
                Divider()
                    .background(Color.gray.opacity(0.5))
                
                
                GameInfoRow(
                    title: "Duration",
                    value: "\(gameConfigVM.gameTimeSession) minutes",
                    iconName: "clock",
                    isSFSymbol: true,
                    accentColor: Color(hex: accentCustomColor)
                )
            }
            .padding()
            .background(Color(hex: darkColor).opacity(0.4))
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
    }
    
    
    struct GameInfoRow: View {
        let title: String
        let value: String
        let iconName: String
        let isSFSymbol: Bool
        let accentColor: Color
        
        var body: some View {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    if isSFSymbol {
                        Image(systemName: iconName)
                            .font(.system(size: 20))
                            .foregroundColor(accentColor)
                    } else {
                        Image(iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(accentColor)
                    }
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                    
                    Text(value)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
        }
    }

