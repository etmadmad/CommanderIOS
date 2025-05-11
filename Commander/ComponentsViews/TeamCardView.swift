import SwiftUI


struct TeamsCardview: View {
    var teamColorCard: String
    var body: some View {
        VStack(spacing: 40) {
            
            Text("Team")
                .font(.system(size: 30))
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
            
        //        .customFont(.bold, size: 25, hexColor: "#FFFFFF")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            Text("1")
                .font(.system(size: 100))
                .foregroundStyle(Color.white)
                
            Button("") {}
                .customButton(
                    typeBtn: .tertiary,
                    textBtn: "View",
                    icon: "",
                    width: 120,
                    height: 30,
                    fontSizeBtn: 16,
                    cornerRadius: 10
                )
            
        }
        .frame(minWidth: 170, maxWidth: .infinity, minHeight: 320)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .foregroundStyle(Color(hex: teamColorCard))
        )
        
    }
}

#Preview {
    TeamsCardview(teamColorCard: "#233445")
}
