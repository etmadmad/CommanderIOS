import Foundation
import Alamofire
import KeychainAccess
import SwiftUI

class GameConfigurationViewModel: ObservableObject {
    /// MODELS
    @Published var gameConfigurationModel = GamesModel()
    private var manager: WebSocketSessionManager?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var roomCode: String = ""
    @Published var triedToJoin: Bool = false
    @Published var currentSessionId: String?
    
    @Published var didJoinSuccessfully = false
    
    /// SESSION CONFIGURATION
    @Published var configurationNameSession: String = ""
    @Published var configurationDescriptionSession: String = ""
    @Published var maxPlayersSession: Int = 0
    @Published var gameModeSession: String = ""
    @Published var gameTimeSession: Int = 0
    @Published var teams: [TeamsModel] = []
    @Published var bombDetails: BombDetails?
    
    @Published var didSessionStart: Bool = false
    @Published var showAlert: Bool = false

    ///FOR NAVIGATION of admin
    @Published var goToManageTeams: Bool = false
    @Published var goToLobbyFFA: Bool = false
    @Published var isGameStarted: Bool = false {
        didSet {
            print("isGameStarted è cambiata: ORA è \(isGameStarted) su thread: \(Thread.current)")
        }
    }
    
    @Published var showBomb: Bool = false
    @Published var showSessionEndedView: Bool = false
    @Published var outcome: SessionOutcome = .draw
    @Published var winners: [WinnerPlayer] = []
    @Published var winnerRaw: Winner?
 
    /// FOR PLAYERS
    @Published var joinedPlayers: [PlayerInSessionStatus] = []{
        didSet {
            for player in joinedPlayers {
                if player.profileImage == nil {
                    self.fetchProfileImage(for: player.username)
                }
            }
        }
    }
    @Published var currentUsername: String? = nil
    @Published var playersInTeams: [PlayersInTeamResponse] = []
    

    
    /// URLS GAME CONFIGURATION
    private var getGameConfigs = Environment.baseURL + "/my-game-configurations/"
    private var createSession = Environment.baseURL + "/game-configurations/"
    private var joinGameSession = Environment.baseURL + "/join-session/"
    
    
    /// KEYCHAIN
    private let keychain = Keychain(service: "com.InsalataCreativa.Commander")
    
    
    ///HEADERS
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
            let parameters: [String: Any] = [
                "session_room_code": roomCode
            ]
            AF.request(joinGameSession, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodable(of: JoinGameResponse.self) { response in
                    DispatchQueue.main.async {
                        switch response.result {
                        case .success(let result):
                            self.getSessionConfiguration(roomCode: self.roomCode)
                            self.didJoinSuccessfully = true
                            print("didJoinSuccessfully: \(self.didJoinSuccessfully)")
                            self.manager = WebSocketSessionManager(sessionRoomCode: self.roomCode, viewModel: self)
                            self.manager?.start()
                            self.currentSessionId = self.roomCode
                        case .failure(let error):
                            print("Join failed: \(error)")
                            self.didJoinSuccessfully = false
                        }
                    }
                }
        }
    }
    
    
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
    
    
    func createGameSession(sessionId: String, completion: @escaping (CreateSessionModel?) -> Void) {
        guard let token = try? keychain.get("accessToken") else {
            print("Token not found")
            completion(nil)
            return
        }
        
        /// GAME ID = ID SESSION
        let url = "\(Environment.baseURL)/game-configurations/\(sessionId)/create-session/"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: CreateSessionModel.self, queue: .main) { response in
                print("Create Session URL:", response.request?.url?.absoluteString ?? "no url")
                print("Status Code:", response.response?.statusCode ?? 0)
                
                switch response.result {
                case .success(let session):
                    print("Session created successfully: \(session)")
                    
                    let roomCode = session.session_room_code
                    self.manager = WebSocketSessionManager(sessionRoomCode: roomCode, viewModel: self)
                    self.manager?.start()
                    self.currentSessionId = roomCode
                    print("CURRENT ID: \(self.currentSessionId ?? "NONE")")
                    self.getSessionConfiguration(roomCode: roomCode)
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
    
    
    func leaveGameSession(roomCode: String) {
        

        
        goToLobbyFFA = false
        goToManageTeams = false
        isGameStarted = false
        
        teams.removeAll()


        currentSessionId = nil
        joinedPlayers = []
        playersInTeams = []
        showBomb = false
        
        
        
        guard let token = try? keychain.get("accessToken") else {
            print("Token not found")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let URLLeaveSession = "\(Environment.baseURL)/sessions/\(roomCode)/leave/"
        
        AF.request(URLLeaveSession, method: .post, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: LeaveSessionResponseModel.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let detail):
                        print("👋 Succesfully left session: \(detail)")

                        
                            self.manager?.close()
                            self.manager = nil
                        

                        
                        print("GAME STARTED? \(self.isGameStarted)")
                        
                    case .failure(let error):
                        print("ERROR: \(error)")
                    }
                }
            }
    }
    
    
    
    func getSessionConfiguration(roomCode: String) {
        guard let token = try? keychain.get("accessToken") else {
            print("Token not found")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        let URLGetSessionConfiguration = "\(Environment.baseURL)/sessions/\(roomCode)/configuration/"
        
        AF.request(URLGetSessionConfiguration, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: SessionConfigResponseModel.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let detail):
                        print("Session Configuration: \(detail)")
                        self.configurationNameSession = detail.configurationName
                        self.configurationDescriptionSession = detail.configurationDescription
                        self.gameModeSession = detail.gameModeName
                        self.maxPlayersSession = detail.maxPlayers
                        self.gameTimeSession = detail.matchDurationMinutes
                        
                        self.bombDetails = detail.bombDetails

                    case .failure(let error):
                        print("ERROR: \(error)")
                    }
                }
            }
    }
    
    func addPlayer(_ player: PlayerInSessionStatus) {
        
        if !joinedPlayers.contains(where: { $0.id == player.id }) {
            
            joinedPlayers.append(player)
            print("🟢\(player), aggiunto all'array joined players ", joinedPlayers)
            
        }
    }
    
    
    
    
    func getPlayersInSession(roomCode: String, completion: @escaping () -> Void) {
        
        guard let token = try? keychain.get("accessToken") else {
            print("Token not found")
            completion()
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        let URLPlayers = "\(Environment.baseURL)/sessions/\(roomCode)/players/"
        
        AF.request(URLPlayers, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [PlayerInSessionStatus].self) { response in
                
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let players):
                        print("🟢 PLAYERS IN SESSION:", players)
                        self.joinedPlayers = players

                 
                    case .failure(let error):
                        print("❌ ERROR PLAYER IN SESSION: \(error)")
                        
                    }
                    completion()
                }
            }}
    
    
    func fetchProfileImage(for username: String) {
        guard let token = try? keychain.get("accessToken") else {
            print("Token not found")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        let URLUserImage = "\(Environment.baseURL)/user/\(username)/profile-image/"
        
        
        
        AF.request(URLUserImage, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: UserImageResponse.self) { response in
                switch response.result {
                case .success(let imageResponse):
                    print("🟢 IMAGE USER FETCHED:", imageResponse)
                    
                    
                    DispatchQueue.main.async {
                        if let index = self.joinedPlayers.firstIndex(where: { $0.username == username }) {
                            self.joinedPlayers[index].profileImage = imageResponse.profileImage
                        }
                    }
                case .failure(let error):
                    print("❌ Error FETCH IMAGE USER: \(error)")
                }
            }
        
    }
    
    
    func createTeams(roomCode: String, teamName: String, completion: @escaping (Bool) -> Void) {
        guard let token = try? keychain.get("accessToken") else {
            print("Token not found")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        let parameters: [String: Any] = [
            "team_name": teamName
        ]
        
        let URLCreateTeams = "\(Environment.baseURL)/sessions/\(roomCode)/teams/create/"
        
        AF.request(URLCreateTeams, method: .post, parameters: parameters,
                   encoding: JSONEncoding.default, headers: headers,)
        .validate()
        .responseDecodable(of: TeamsModel.self) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let teamResponse):
                    print("TEAM CREATED:", teamResponse)
                    self.teams.append(teamResponse)
                    completion(true)
                case .failure(let error):
                    print("ERROR: \(error)")
                    if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response body for CREATE TEAMS:", responseString)
                    }
                    completion(false)
                }
            }
        }
        
        
    }

    func assignPlayerToTeam(username: String, roomCode: String, teamId: String, completion: @escaping (Bool) -> Void) {
        print("Assigning player \(username) to teamId \(teamId) in session \(roomCode)")

        guard let token = try? keychain.get("accessToken"),
              let sessionId = self.currentSessionId else {
            print("Token o Session ID non trovati")
            completion(false)
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]

        let URLAssignPlayer = "\(Environment.baseURL)/sessions/\(roomCode)/assign-player/"

        let parameters: [String: Any] = [
            "player_username": username,
            "team_id": teamId
        ]

        AF.request(URLAssignPlayer, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .response { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success:
                        print("🟢 PLAYER ASSIGNED TO TEAM: \(username) - \(teamId)")
                        completion(true)
//                        self.startSession(gameId: gameId)
                    case .failure(let error):
                        print("ERROR ASSIGNING PLAYER \(username) to team \(teamId) in the game \(roomCode): \(error)")
                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            print("Corpo della risposta:", responseString)
                        }
                        completion(false)
                    }
                }
            }
    }
    
    func startSession(roomCode: String, completion: (() -> Void)? = nil) {
        guard let token = try? keychain.get("accessToken") else{
            print("Token non trovati")
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]

        let URLStartSession = "\(Environment.baseURL)/sessions/\(roomCode)/start/"
        
        AF.request(URLStartSession, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: SessionStartedResponse.self) { response in
                switch response.result {
                case .success(let imageResponse):
                    print("🟢 START SESSION:", imageResponse)
//                    self.isGameStarted = true
//                    print("GAME STARTED??? \(self.isGameStarted)")
                    DispatchQueue.main.async {
                        self.isGameStarted = true
                        completion?()
                                    }
                
                case .failure(let error):
                    print("❌ Error START SESSION: \(error)")
                }
            }
    }
    
    func getPlayersInTeams(roomCode:String) {
        guard let token = try? keychain.get("accessToken") else{
            print("Token non trovati")
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]

        let URLGetPlayersInTeams = "\(Environment.baseURL)/sessions/\(roomCode)/teams/"
        
        AF.request(URLGetPlayersInTeams, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [PlayersInTeamResponse].self) { response in
                switch response.result {
                case .success(let players):
                    self.playersInTeams = players
                    print("💕💕💕💕💕💕 PLAYERS IN TEAM:", self.playersInTeams)

                    if let username = self.currentUsername {
                        self.updateShowBomb(for: username)
                    }
                
                case .failure(let error):
                    print("❌ Errore nella richiesta dei players: \(error)")
                }
            }
    }
    
    
    func membersOfMyTeam(for username: String?) -> [PlayerInSessionStatus] {
        guard let username = username else {
            print("⚠️ currentUser è nil")
            return []
        }
        print("🔍 Cerco i compagni per utente:", username)

        for team in playersInTeams {
            print("➡️ Team:", team.teamName, "Players:", team.players.map { $0.username })
            if team.players.contains(where: { $0.username == username }) {
                print("✅ Match trovato nel team:", team.teamName)
                return team.players
            }
        }

        print("❌ Nessun match trovato")
        return []
    }
    
    func changeStatusPlayer(roomCode: String, newStatus: String = "Eliminated") {
        
        guard let token = try? keychain.get("accessToken") else{
            print("Token non trovati")
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "player_status": newStatus
        ]
        
        let URLChangeStatusPlayer = "\(Environment.baseURL)/session/\(roomCode)/me/status/"
        
        AF.request(URLChangeStatusPlayer, method: .post,  parameters: parameters,
                   encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: ChangeStatusPlayerResponse.self) { response in
                switch response.result {
                case .success(let detailStatusPlayer):
                    print("🟢 CHANGED PLAYER STATUS:", detailStatusPlayer)

                    
                case .failure(let error):
                    print("❌ Errore nella cambiamento di status: \(error)")
                }
            }
    
    }

    /// GAME STARTED VIEW UI
    func updateShowBomb(for username: String) {
        // Controllo modalità
        guard gameModeSession.lowercased() == "bomb defuse" else {
            showBomb = false
            return
        }
        
        // Controllo se l'utente è in Team 2
        let isInTeam2 = playersInTeams.first(where: { $0.teamName == "Team 2" })?
            .players.contains(where: { $0.username == username }) ?? false
        
        showBomb = isInTeam2
        print("💣💣💣💣💣💣SHOW BOMB: ", showBomb)
    }


    /// GAME STARTED VIEW UI
    func updateJoinedPlayerStatus(username: String, status: String) {
        DispatchQueue.main.async {
            var updated = false

            /// FREE FOR ALL
            if let idx = self.joinedPlayers.firstIndex(where: { $0.username == username }) {
                self.joinedPlayers[idx].playerStatus = status
                self.joinedPlayers = self.joinedPlayers
                updated = true
            }

            /// TEAM-BASED MATCHES (DEATHMATCH & BOMB DEFUSE)
            for teamIndex in self.playersInTeams.indices {
                if let playerIndex = self.playersInTeams[teamIndex].players.firstIndex(where: { $0.username == username }) {
                    self.playersInTeams[teamIndex].players[playerIndex].playerStatus = status
                    self.playersInTeams = self.playersInTeams
                    updated = true
                }
            }

            if updated {
                print("✅ updated status: \(username) -> \(status)")
                return
            }

            
            let gameId = self.currentSessionId ?? self.roomCode
            if !gameId.isEmpty {
                print("⚠️ giocatore \(username) non trovato localmente, ricarico dal server")
                self.getPlayersInTeams(roomCode: gameId)
                self.getPlayersInSession(roomCode: gameId) { }
            }
        }
    }
    
    func handleSessionEnded(reason: String?, winners: Winner?) {
        guard let reason else { return }
        showSessionEndedView = true
        self.winnerRaw = winners
        let winnersArray: [WinnerPlayer]
        switch winners {
        case .players(let arr):
            winnersArray = arr
        case .string(let teamName):
            winnersArray = playersInTeams.first(where: { $0.teamName == teamName })?.players.map {
                WinnerPlayer(id: $0.id, username: $0.username)
            } ?? []
        default:
            winnersArray = []
        }
      

        switch reason {
        case "all_opponents_eliminated", "all_attackers_eliminated", "bomb_defused":
            let youWin = winnersArray.contains(where: { $0.username == currentUsername })
            outcome = youWin ? .victory : .defeat
            self.winners = winnersArray

        case "time_over":
            if winnersArray.isEmpty {
                outcome = .draw
                self.winners = []
            } else {
                let youWin = winnersArray.contains(where: { $0.username == currentUsername })
                outcome = youWin ? .victory : .defeat
                self.winners = winnersArray
            }
        default:
            self.winners = []
        }
    }
    
    func endSession(roomCode: String) {
        guard let token = try? keychain.get("accessToken") else{
            print("Token non trovati")
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]

        let URLEndSession = "\(Environment.baseURL)/sessions/\(roomCode)/end/"
        
        let parameters: [String: Any] = [
            "reason": "bomb_defused",
            "winner": currentUsername
        ]
        AF.request(URLEndSession, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: [PlayersInTeamResponse].self) { response in
                switch response.result {
                case .success(let players):
                    self.playersInTeams = players
                    print("💕💕💕💕💕💕 PLAYERS IN TEAM:", self.playersInTeams)

                    if let username = self.currentUsername {
                        self.updateShowBomb(for: username)
                    }
                
                case .failure(let error):
                    print("❌ Errore nella richiesta dei players: \(error)")
                }
            }
    }

}

