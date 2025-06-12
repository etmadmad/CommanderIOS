import SwiftUI

import SwiftUI

struct StartRoomBarView: View {
    
    var body: some View {
        ZStack {
            // Sfondo opacizzato
            Rectangle()
                .fill(Color(hex: grayDetails)) // Puoi cambiare colore e opacità
                .frame(height: 80) // Altezza dello sfondo
                .frame(maxWidth: .infinity)
                .ignoresSafeArea(edges: .horizontal)


            // Contenuto effettivo
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("PrimoNero's Room")
                        .foregroundStyle(Color.white)
                    Text("Deathmatch")
                        .foregroundStyle(Color.white.opacity(0.8))
                }
                
                Spacer()
                
                Button(action: {}) {
                    Text("Start Room")
                        .customButton(
                            typeBtn: .primary,
                            width: 120,
                            height: 45,
                            cornerRadius: 15
                        )
                }
            }
            .padding(.horizontal)
        }
    }
}


struct ManageTeamsView: View {
    @State private var numberItems: Int = 2
    @StateObject private var userInfoViewModel = UserInfoViewModel()
    @State private var membersPerTeam: [[String]] = [[], []]

    var colorsTeams: [String] = ["#F84848", "487DF8", "68B41E", "FFFF9F", "5E00CF"]

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: darkColor)
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Text("Teams")
                        .customFont(.bold, size: 30, hexColor: white)
                    Spacer()
                    Image(systemName: "plus")
                        .onTapGesture {
                            numberItems += 1
                            membersPerTeam.append([])
                        }
                    if numberItems > 2 {
                        Image(systemName: "minus")
                            .onTapGesture {
                                numberItems -= 1
                                membersPerTeam.removeLast()
                            }
                    }
                }
                .foregroundColor(.white)
            
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        ForEach(0..<numberItems, id: \.self) { index in
                            let colorCard = colorsTeams[index % colorsTeams.count]
                            TeamsCardview(
                                teamColorCard: colorCard,
                                members: membersPerTeam[index],
                                onMemberDropped: { member in
                                    if !membersPerTeam[index].contains(member) {
                                        membersPerTeam[index].append(member)
                                    }

                                    if let removeIndex = userInfoViewModel.users.firstIndex(where: { $0.username == member }) {
                                        userInfoViewModel.users.remove(at: removeIndex)
                                    }
                                   
                                    
                                }
                                    
                            )
                        }
                    }
                }
                .scrollIndicators(.hidden)
            
                Text("Players")
                    .customFont(.bold, size: 30, hexColor: white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if userInfoViewModel.isLoading {
                    ProgressView()
                    
                } else if let errorMessage = userInfoViewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                    
                } else {
                    ScrollView{
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) {
                            ForEach(userInfoViewModel.users, id: \.username) { profile in
                                UserInfoView(userInfoViewModel: userInfoViewModel, profile: profile)
                                    .onDrag {
                                        return NSItemProvider(object: profile.username as NSString)
                                    }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .padding(.horizontal, 24)
            .onAppear {
                userInfoViewModel.fetchUsers()
            }
            StartRoomBarView()
        }
    }
}

//#Preview {
//    StartRoomBarView()
//}

#Preview{
    ManageTeamsView()
}
