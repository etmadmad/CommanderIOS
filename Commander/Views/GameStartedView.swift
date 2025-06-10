import SwiftUI

struct GameStartedView: View {
    var body: some View {
        ZStack {
            Color(hex: darkColor).ignoresSafeArea()
            VStack{
                Text("PrimoNero's Room")
                    .customFont(.bold, size: 30, hexColor: white)
                CountdownView()
                Group{
                    Text("Your Team")
                        .customFont(.bold, size: 24, hexColor: white)
                    Text("Alive - ")
                        .customFont(.regular, size: 20, hexColor: white)
                        .opacity(0.5)
                    Text("Dead - ")
                        .customFont(.regular, size: 20, hexColor: white)
                        .opacity(0.5)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(24)
            
        }
       
    }
}

#Preview {
    GameStartedView()
}
