import Foundation
import Alamofire
import KeychainAccess

class GameConfigurationViewModel: ObservableObject {
    @Published var gameConfigurationModel = GamesModel()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var roomCode: String = ""
    
    @Published var triedToJoin: Bool = false
    
    /// URLS GAME CONFIGURATION
    private var getGameConfigs = Environment.baseURL + "/my-game-configurations/"
    private var createSession = Environment.baseURL + "/game-configurations/"
    private var joinGameSession = Environment.baseURL + "/join-session/"
    
    private let keychain = Keychain(service: "com.InsalataCreativa.Commander")
    
    private var headers: HTTPHeaders = [
        "Accept" : "application/json",
        "Content-Type" : "application/json"
    ]
    
    init () {
        getAllGames()
    }
    
    func joinGame () {
        guard let token = try? keychain.get("accessToken") else {
            print("Token not found")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        triedToJoin = true
        if !roomCode.isEmpty {
            print("roomCode sendato")
            
            let parameters: [String: Any] = [
                "session_room_code": roomCode
            ]
            
            //            AF.request(joinGameSession, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            //                .validate()
            //                .responseDecodable(of: GamesModel.self) { response in
            //                    DispatchQueue.main.async {
            //                        print("Request URL:", response.request?.url?.absoluteString ?? "no url")
            //                        print("Response code:", response.response?.statusCode ?? 0)
            //
            //                        switch response.result {
            //                        case .success(let result):
            //                            print("Ecco le tue partite: \(result)")
            //                            self.gameConfigurationModel = result
            //                        case .failure(let error):
            //                            print("ERROR: Partite non recuperate. \(error)")
            //                            if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
            //                                print("Response body:", responseString)
            //                            }
            //                        }
            
            AF.request(joinGameSession, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodable(of: JoinGameResponse.self) { response in
                    DispatchQueue.main.async {
                        switch response.result {
                        case .success(let result):
                            if let detail = result.detail {
                                print("SUCCESS: \(detail)")
                                // Mostra messaggio di successo
                            } else if let sessionRoomCode = result.sessionRoomCode {
                                print("ALREADY IN SESSION: \(sessionRoomCode.first ?? "")")
                                // Mostra messaggio di "già in sessione"
                            }
                        case .failure(let error):
                            print("ERROR: \(error)")
                        }
                    }
                }
        }
        
        else{
            print("devi inserire qualcosa")
        }}
        
        
        func getAllGames() {
            guard let token = try? keychain.get("accessToken") else {
                print("Token not found")
                return
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json"
            ]
            
            AF.request(getGameConfigs, method: .get, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodable(of: GamesModel.self) { response in
                    DispatchQueue.main.async {
                        print("Request URL:", response.request?.url?.absoluteString ?? "no url")
                        print("Response code:", response.response?.statusCode ?? 0)
                        
                        switch response.result {
                        case .success(let result):
                            print("Ecco le tue partite: \(result)")
                            self.gameConfigurationModel = result
                        case .failure(let error):
                            print("ERROR: Partite non recuperate. \(error)")
                            if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                                print("Response body:", responseString)
                            }
                        }
                    }
                }
            
            
        }
        
        //    func createGameSession() {
        //        guard let token = try? keychain.get("accessToken") else {
        //            print("Token not found")
        //            return
        //        }
        //
        //        let headers: HTTPHeaders = [
        //            "Authorization": "Bearer \(token)",
        //            "Accept": "application/json"
        //        ]
        //        AF.request(getGameConfigs, method: .get, encoding: JSONEncoding.default, headers: headers)
        //            .validate()
        //            .responseDecodable(of: GamesModel.self) { response in
        //                DispatchQueue.main.async {
        //                    print("Request URL:", response.request?.url?.absoluteString ?? "no url")
        //                    print("Response code:", response.response?.statusCode ?? 0)
        //
        //                    switch response.result {
        //                    case .success(let result):
        //                        print("Ecco le tue partite: \(result)")
        //                        self.gameConfigurationModel = result
        //                    case .failure(let error):
        //                        print("ERROR: Partite non recuperate. \(error)")
        //                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
        //                            print("Response body:", responseString)
        //                        }
        //                    }
        //                }
        //            }
        //
        //    }
        
        
        func createGameSession(gameId: String, completion: @escaping (CreateSessionModel?) -> Void) {
            guard let token = try? keychain.get("accessToken") else {
                print("Token not found")
                completion(nil)
                return
            }
            
            let url = "\(Environment.baseURL)/game-configurations/\(gameId)/create-session/"
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json",
                "Content-Type": "application/json"
            ]
            
            AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodable(of: CreateSessionModel.self) { response in
                    DispatchQueue.main.async {
                        print("Create Session URL:", response.request?.url?.absoluteString ?? "no url")
                        print("Status Code:", response.response?.statusCode ?? 0)
                        
                        switch response.result {
                        case .success(let session):
                            print("Session created successfully: \(session)")
                            completion(session)
                        case .failure(let error):
                            print("Failed to create session: \(error)")
                            if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                                print("Response body:", responseString)
                            }
                            completion(nil)
                        }
                    }
                }
        }
    
    
        func getPlayersInSession() {
            guard let token = try? keychain.get("accessToken") else {
                print("Token not found")
                return
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Accept": "application/json"
            ]
            
            
        }
        
    }

