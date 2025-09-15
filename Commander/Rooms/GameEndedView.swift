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

struct GameEndedView: View {
    let outcome: SessionOutcome
    let winners: [WinnerPlayer]
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
                if !winners.isEmpty {
                    VStack(spacing: 8) {
                        Text("Winners:")
                            .font(.headline)
    //                    ForEach(winners) { player in
    //                        Text(player.name)
    //                            .font(.body)
                        }
                    }
                }
            Button("Continue"){
                gameConfigVM.isGameStarted = false
            }
            
                .padding()

            }
        
       
    }

