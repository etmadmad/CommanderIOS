
import SwiftUI

struct JoinRoomView: View {
    var body: some View {
        NavigationView{
            ZStack{
                Color(hex: darkColor)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Text("Commander")
                        .customFont(.bold, size: 30, hexColor: accentCustomColor)
               
                    
                   // TextFieldView(inputName: "Room code", placeholder: "name room")
                    
                    Button(""){}
                        .customButton(
                            typeBtn: .primary,
                            textBtn: "Enter Room",
                            icon: "",
                            width: 170,
                            height: 50,
                            fontSizeBtn: 18,
                            cornerRadius: 10
                        )
                        .padding(.horizontal, 64)

                    Spacer()
                    
                    HStack {
                        Text("Your Rooms")
                            .font(.title)
                            .foregroundStyle(.white)
                        
                        
                        Image(systemName: "trash")
                            .foregroundStyle(.white)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.white.opacity(0.1))
                            .frame(maxWidth: .infinity, maxHeight: 350)
                        VStack(spacing: 24){
                           // YourRoomsView(nameRoom: "Primonero", typeRoom: "Bomb")
                         //   YourRoomsView(nameRoom: "Primonero", typeRoom: "Bomb")
                           // YourRoomsView(nameRoom: "Primonero", typeRoom: "Bomb")
                         //   YourRoomsView(nameRoom: "Primonero", typeRoom: "Bomb")
                        }}
                    Spacer()
                    
                }
                
                .padding(.horizontal, 24)
                
                
            }
        }

    }
}




#Preview {
    JoinRoomView()
}
