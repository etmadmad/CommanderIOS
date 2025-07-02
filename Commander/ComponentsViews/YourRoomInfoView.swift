import SwiftUI

struct RoomCodeWrapper: Identifiable {
    let id = UUID()
    let code: String
}

struct YourRoomsView: View {
    let game: FounderGame
    @ObservedObject var gameConfigVM = GameConfigurationViewModel()
    @State private var sessionRoomCode: RoomCodeWrapper? = nil
    @State private var goToManageTeams = false

    var radius: CGFloat = 30
    var squareSide: CGFloat {
        2.0.squareRoot() * radius
    }

    var body: some View {
        HStack {
            ZStack {
                if game.game_mode_name == "Free for All" {
                    Circle()
                        .fill(Color(hex: swordsColor))
                        .frame(width: radius * 2, height: radius * 2)
                    Image("swordsIcon")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: squareSide, height: squareSide)
                }
                if game.game_mode_name == "Bomb Defuse" {
                    Circle()
                        .fill(Color(hex: bombColor))
                        .frame(width: radius * 2, height: radius * 2)
                    Image("bombIcon")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: squareSide, height: squareSide)
                }
                if game.game_mode_name == "Team Deathmatch" {
                    Circle()
                        .fill(Color(hex: skullColor))
                        .frame(width: radius * 2, height: radius * 2)
                    Image("skullIcon")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: squareSide, height: squareSide)
                }
            }
            .padding(.leading, 16)

            VStack(alignment: .leading) {
                Text(game.configurationName)
                    .customFont(.regular, size: 18, hexColor: white)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(game.game_mode_name)
                    .customFont(.regular, size: 14, hexColor: white)
            }

            Spacer()

            Button {
                gameConfigVM.createGameSession(gameId: game.id) { session in
                    guard let session = session else {
                        print("Errore nella creazione della sessione")
                        return
                    }
                    DispatchQueue.main.async {
                        if !session.session_room_code.isEmpty {
                            sessionRoomCode = RoomCodeWrapper(code: session.session_room_code)
                        }
                    }
                }
            } label: {
                Text("Start Room")
                    .customFont(.regular, size: 12, hexColor: darkColor)
            }
//            .sheet(item: $sessionRoomCode) { wrapper in
//                RoomCodeModalView(roomName: game.configurationName, roomCode: wrapper.code) {
//                    sessionRoomCode = nil
//                }
//                .presentationDetents([.medium])
//            }
            .sheet(item: $sessionRoomCode) { wrapper in
                RoomCodeModalView(roomName: game.configurationName, roomCode: wrapper.code) {
                    sessionRoomCode = nil  // chiudi la sheet
                    goToManageTeams = true // triggera la navigation
                }
                .presentationDetents([.medium])
            }
            .customButton(typeBtn: .secondary, width: 100, height: 30, cornerRadius: 10)

            Spacer()
        }
        .navigationDestination(isPresented: $goToManageTeams) {
            ManageTeamsView()
        }
    }
}

