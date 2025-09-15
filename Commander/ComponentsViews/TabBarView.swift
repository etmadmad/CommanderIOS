import SwiftUI


import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var authViewModel: AuthtenticationViewModel
    @EnvironmentObject var gameConfigVM: GameConfigurationViewModel
    
    @EnvironmentObject var profileVM: ProfileViewModel
    
    var body: some View {
        
        TabView {
            Group {
                if gameConfigVM.isGameStarted {
                    GameStartedView()
                        .environmentObject(gameConfigVM)
                        .environmentObject(profileVM)
                    
                } else {
                    GameJoinView()
                        .environmentObject(gameConfigVM)
                }
            }
            .id(gameConfigVM.isGameStarted)
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            LocationButtonTestView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            ProfileInfoView(registrationVM: RegisterViewModel())
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }

                .accentColor(Color(hex: accentCustomColor))
        }
        
    }
}


