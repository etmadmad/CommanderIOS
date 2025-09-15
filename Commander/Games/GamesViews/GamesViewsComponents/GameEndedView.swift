import SwiftUI

import Foundation

enum SessionOutcome {
    case victory
    case draw
    case defeat
}

extension SessionOutcome {
    var emoji: String {
        switch self {
        case .victory: return "🏆"
        case .draw:    return "🤝"
        case .defeat:  return "💀"
        }
    }
    
    var title: String {
        switch self {
        case .victory: return "Mission Accomplished"
        case .draw:    return "Stalemate"
        case .defeat:  return "Mission Failed"
        }
    }
    
    var description: String {
        switch self {
        case .victory:
            return "You outsmarted the enemy and completed the mission with precision. Victory is yours."
        case .draw:
            return "Neither side could secure the objective. The battle ends in a deadlock."
        case .defeat:
            return "The enemy gained the upper hand this time. Regroup, adapt, and try again."
        }
    }
}
//
//struct GameEndedView: View {
//    let outcome: SessionOutcome
//    let winnerGame: Winner?
//    @EnvironmentObject var gameConfigVM: GameConfigurationViewModel
//
//    var body: some View {
//        
//        
//            VStack(spacing: 32) {
//                Text(outcome.emoji)
//                    .font(.system(size: 80))
//                Text(outcome.title)
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                Text(outcome.description)
//                    .multilineTextAlignment(.center)
//                    .font(.title3)
//                    .padding(.horizontal)
//    
//                Text("Winners:")
//                    .font(.headline)
//                Group {
//                    if let winnerRaw = winnerGame {
//                      switch winnerRaw {
//                      case .string(let teamName):
//                          VStack(spacing: 8) {
//                              Text("Winning Team:")
//                                  .font(.headline)
//                              Text(teamName)
//                                  .font(.title2)
//                                  .foregroundColor(.accentColor)
//                          }
//                      case .players(let arr):
//                          VStack(spacing: 8) {
//                              Text("Winners:")
//                                  .font(.headline)
//                              ForEach(arr, id: \.id) { player in
//                                  Text(player.username)
//                                      .font(.body)
//                              }
//                          }
//                      }
//                      } else if !winnerGame.isEmpty {
//                          VStack(spacing: 8) {
//                              Text("Winners:")
//                                  .font(.headline)
//                              ForEach(winnerGame, id: \.id) { player in
//                                  Text(player.username)
//                                      .font(.body)
//                              }
//                          }
//                      }
//                  }
//
//            }
//    }
//            Button("Continue"){
//                gameConfigVM.isGameStarted = false
//            }
//            .customButton(typeBtn: .primary, width: 300, height: 50, cornerRadius: 8)
//            
//        
//                .padding()
//                .navigationBarBackButtonHidden(true)
//            }
//        
//       
//    
//



import SwiftUI

struct GameEndedView: View {
    let outcome: SessionOutcome
    let winners: [WinnerPlayer]
    let winnerRaw: Winner?  // <-- aggiungi questo parametro!
    @EnvironmentObject var gameConfigVM: GameConfigurationViewModel

    var body: some View {
        VStack(spacing: 32) {
            Text(outcome.emoji)
                .font(.system(size: 80))
            Text(outcome.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(outcome.description)
                .multilineTextAlignment(.center)
                .font(.title3)
                .padding(.horizontal)

            // Mostra i vincitori
            Group {
                if let winnerRaw = winnerRaw {
                    switch winnerRaw {
                    case .string(let teamName):
                        VStack(spacing: 8) {
                            Text("Winning Team:")
                                .font(.headline)
                            Text(teamName)
                                .font(.title2)
                                .foregroundColor(.accentColor)
                        }
                    case .players(let arr):
                        VStack(spacing: 8) {
                            Text("Winners:")
                                .font(.headline)
                            ForEach(arr, id: \.id) { player in
                                Text(player.username)
                                    .font(.body)
                            }
                        }
                    }
                } else if !winners.isEmpty {
                    VStack(spacing: 8) {
                        Text("Winners:")
                            .font(.headline)
                        ForEach(winners, id: \.id) { player in
                            Text(player.username)
                                .font(.body)
                        }
                    }
                }
            }
            Spacer()
            Button("Continue"){
                gameConfigVM.isGameStarted = false
            }
            .customButton(typeBtn: .primary, width: 350, height: 50, cornerRadius: 12)
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}
