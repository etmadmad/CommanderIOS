import SwiftUI
struct ManageTeamsView: View {
    @State private var numberItems: CGFloat = 2
    @StateObject private var userInfoViewModel = UserInfoViewModel()
    
    var colorsTeams: [String] = ["#F84848", "487DF8", "68B41E", "FFFF9F", "5E00CF"]

    var body: some View {
        ZStack {
            Color(hex: darkColor)
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Text("Teams")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                      //  .customFont(.bold, size: 25, hexColor: "FFFFFF")
                    Spacer()
                    Image(systemName: "plus")
                        .onTapGesture { numberItems += 1 }
                    if numberItems > 2 {
                        Image(systemName: "minus")
                            .onTapGesture { numberItems -= 1 }
                    }
                }
                .foregroundColor(.white)

                // Scroll orizzontale
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(0..<Int(numberItems), id: \.self) { index in
                            let colorCard = colorsTeams[index % colorsTeams.count]
                            TeamsCardview(teamColorCard: colorCard)
                        }
                    }
                }

                Spacer()
                Spacer()
                // Titolo Players
                Text("Players")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    //.customFont(.medium, size: 24, hexColor: "FFFFFF")
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Lista profili
                if userInfoViewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = userInfoViewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                } else {
                    ScrollView{
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                            ForEach(userInfoViewModel.users, id: \.username) { profile in
                                UserInfoView(userInfoViewModel: userInfoViewModel, profile: profile)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .onAppear {
                userInfoViewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    ManageTeamsView()
}
