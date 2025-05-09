import SwiftUI

class YourRoomInfoViewModel: ObservableObject {
    @Published var roomName: String = ""
    @Published var typeRoom: String = ""
    private var yourRoomInfo: YourRoomInfoModel
    init (yourRoomInfo: YourRoomInfoModel) {
        self.yourRoomInfo = yourRoomInfo
        //self.roomName = YourRoomInfoModel.nameRoom
    }
    
}
