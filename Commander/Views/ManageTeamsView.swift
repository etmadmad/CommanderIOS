
import SwiftUI


struct TeamsView: View {
    @State private var numberItems: CGFloat = 2
    var colorsTeams: [String] = ["#F84848", "487DF8", "68B41E", "FFFF9F", "5E00CF" ]
    let sampleProfile = Profile(username: "JohnDoe", image: "https://via.placeholder.com/150")
    let sampleViewModel = UserInfoViewModel()
    
 
    
    var body: some View {
        ZStack {
            Color(hex:darkColor)
                .ignoresSafeArea()
            VStack{
                
                HStack{
                    Text("Teams")
                        .customFont(.bold, size: 25, hexColor: "FFFFFF")
                        .foregroundStyle(Color.white)
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundStyle(Color.white)
                        .onTapGesture {
                            numberItems += 1
                        }
                    if (numberItems > 2) {
                        Image(systemName: "minus")
                            .foregroundStyle(Color.white)
                            .onTapGesture {
                                if numberItems > 2 {
                                    numberItems -= 1
                                }
                            }
                    }
                }
                ScrollView(.horizontal){
                    HStack (spacing: 10){
                        ForEach(0..<Int(numberItems), id: \.self) { index in
                            let colorCard = colorsTeams[index % Int(numberItems)]
                                TeamsCardview(teamColorCard: colorCard)
                            
                        }
                        
                    }
                }
                .scrollIndicators(.hidden)
                Spacer()
                Text("Players")
                    .customFont(.medium, size: 24, hexColor: "FFFFFF")
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Grid{
                    GridRow {
                        UserInfoView(userInfoViewModel: sampleViewModel, profile: sampleProfile)
                        UserInfoView(userInfoViewModel: sampleViewModel, profile: sampleProfile)
                        UserInfoView(userInfoViewModel: sampleViewModel, profile: sampleProfile)
                    }
                    GridRow {
                        UserInfoView(userInfoViewModel: sampleViewModel, profile: sampleProfile)
                        UserInfoView(userInfoViewModel: sampleViewModel, profile: sampleProfile)
                        UserInfoView(userInfoViewModel: sampleViewModel, profile: sampleProfile)
                    }

                }
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }}

#Preview {
    TeamsView()
}

