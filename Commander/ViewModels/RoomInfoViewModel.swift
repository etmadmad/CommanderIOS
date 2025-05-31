import SwiftUI
import Alamofire

// da inserire in RoomInfoModel
struct RoomInfoModel: Decodable {
    let configurationName: String
 //   let description: String
   // let maxPlayers: Int
    //let founderId: Int
    let gameMode: String
    //let roomCode: String // generata automaticamente quando il bro vuole startare la partita 
}

class RoomInfoViewModel: ObservableObject {
    @Published var roomInfoModel: RoomInfoModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var roomCode: String = ""
    
    @Published var triedToJoin: Bool = false


    private let baseURL = "https://yourapi.com/stanze"
    
    func joinRoom () {
        triedToJoin = true
        if !roomCode.isEmpty {
            print("roomCode sendato")
        } else{
            print("devi inserire qualcosa")
        }
    }
    
    func getAllCreatedRooms() {
      
        
    }

    func getInfoRoom (roomId: Int) {
        isLoading = true
        errorMessage = nil
        
        let url = "\(baseURL)/\(roomId)"
        
        AF.request(url, method: .get)
            .validate()  
            .responseDecodable(of: RoomInfoModel.self) { [weak self] response in
                guard let self = self else { return }
                
                self.isLoading = false
                
                switch response.result {
                case .success(let roomInfo):
                    self.roomInfoModel = roomInfo
                case .failure(let error):
                    self.errorMessage = "Errore nel caricare le informazioni della stanza: \(error.localizedDescription)"
                }
            }
    }


}
