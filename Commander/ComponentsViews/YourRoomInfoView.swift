import SwiftUI

struct YourRoomsView: View {
    // inserire @ObservedObject
    var nameRoom: String
    var typeRoom: String
    var radius: CGFloat = 30
    var squareSide: CGFloat {
        2.0.squareRoot() * radius
    }
    var body: some View {
                    
                HStack{
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: radius * 2, height: radius * 2)
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: squareSide, height: squareSide)
                    }
                    .padding(.leading, 16)
                    
                    VStack(alignment: .leading){
                        Text("Commander")
                            .customFont(.regular, size: 20, hexColor: darkColor)
                            .foregroundStyle(Color(hex: accentCustomColor))
                        Text("Commander")
                            .customFont(.regular, size: 13, hexColor: darkColor)
                            .foregroundStyle(Color(hex: accentCustomColor))
                    }
                    Spacer()
                   // NavigationLink(destination: RoomStarted()) {
                     //   ButtonView(textBtn: "Start Room", typeBtn: .secondary, icon: "", width: 115, height: 35, fontSizeBtn: 14, cornerRadius: 100)
                       //     .padding(.trailing, 16)
                    //}
                }
   
            
            
    }

    
}

#Preview {
    YourRoomsView(nameRoom: "your pumpum bring life", typeRoom: "Bomb")
}
