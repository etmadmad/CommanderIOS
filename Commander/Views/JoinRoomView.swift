
import SwiftUI


struct JoinRoomView: View {
    @StateObject var roomInfoViewModel = RoomInfoViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: darkColor)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    
                    // Header
                    HStack {
                        Text("Commander")
                            .customFont(.bold, size: 30, hexColor: accentCustomColor)
                        Spacer()
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.top, 20)

                    // Input
                    VStack(spacing: 8) {
                        InputView(inputText: $roomInfoViewModel.roomCode, inputName: "Enter Room Code", placeholder: "#000000")
                        
                        if roomInfoViewModel.triedToJoin && roomInfoViewModel.roomCode.isEmpty {
                            Text("Room not available")
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.subheadline)
                        }
                    }

                    // Join button
                    Button(action: {
                        roomInfoViewModel.joinRoom()
                    }) {
                        Text("Join Room")
                    }
                    .customButton(
                        typeBtn: .primary,
                        width: 140,
                        height: 44,
                        cornerRadius: 12
                    )
                    .padding(.top, 8)

                    // Your Rooms Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Rooms")
                            .font(.title2.bold())
                            .foregroundStyle(.white)

                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.05))
                            
                            ScrollView {
                                LazyVStack(spacing: 16) {
                                    ForEach(0..<5) { _ in
                                        YourRoomsView(infoRoom: RoomInfoModel(
                                            configurationName: "Insalata creatiaaaaaaaaaa",
                                            gameMode: "Deathmatch"),
                                            nameRoom: "Primonero",
                                            typeRoom: "Bomb")
                                    }
                                }
                                .padding()
                            }
                        }
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.top, 24)

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
