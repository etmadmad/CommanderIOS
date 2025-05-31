import SwiftUI


struct YourRoomsView: View {
    @ObservedObject var roomViewModel = RoomInfoViewModel()
    let infoRoom: RoomInfoModel
    
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
                    Text(infoRoom.configurationName)
                        .customFont(.regular, size: 18, hexColor: white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text(infoRoom.gameMode)
                        .customFont(.regular, size: 13, hexColor: white)
                    
                }
                
                Spacer()
                
                Button() {
                    print("Start Room")
                } label: {
                    Text("Start Room")
                        .customFont(.regular, size: 12, hexColor: darkColor)
                }.customButton(typeBtn: .secondary, width: 100, height: 30, cornerRadius: 10)
                
                Spacer()
            }
            
            
            
        }
    }
    



struct YourRoomsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockRoom = RoomInfoModel(
            configurationName: "Stanza Epica",
            gameMode: "Deathmatch"
        )
        
        YourRoomsView(
            infoRoom: mockRoom,
            nameRoom: "Stanza Epica",
            typeRoom: "Pubblica"
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
