
import Foundation

struct WebSocketEvent: Codable {
    let type: String
    let player_id: String?
    let status: String?
    let username: String?
}

class WebSocketSessionManager {
    private let sessionRoomCode: String
    private var webSocketTask: URLSessionWebSocketTask?
    private weak var viewModel: GameConfigurationViewModel?

    init(sessionRoomCode: String, viewModel: GameConfigurationViewModel) {
        self.sessionRoomCode = sessionRoomCode
        self.viewModel = viewModel
        let url = URL(string: "ws://5.189.158.70:8000/ws/session/\(sessionRoomCode)/")!
        webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
        webSocketTask?.resume()
    }

    func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket error: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Ricevuto messaggio: \(text)")
           

                    
                if let data = text.data(using: .utf8) {
                    do {
                        let event = try JSONDecoder().decode(WebSocketEvent.self, from: data)
                        print("Evento decodificato: \(event)")

                        switch event.type {

                            case "player_joined":
                                if let username = event.username {
                                    let newPlayer = PlayerInSessionStatus(username: username, profileImage: nil, playerStatus: "Alive")
                                    DispatchQueue.main.async {
                                        self?.viewModel?.addPlayer(newPlayer)
                                    }
                                }

                            // quando ricevi player_status
                            case "player_status":
                                if let username = event.username, let status = event.status {
                                    DispatchQueue.main.async {
                                        self?.viewModel?.updateJoinedPlayerStatus(username: username, status: status)
                                    }
                                }


                        case "session_started":
                            print("Evento session_started ricevuto → imposto isGameStarted = true")
                            DispatchQueue.main.async {
                                self?.viewModel?.isGameStarted = true
                   

                            }
                        

                        case "session_closed":
                            print("Evento session_ended ricevuto → imposto isGameStarted = false")
                            DispatchQueue.main.async {
                                self?.viewModel?.isGameStarted = false
                                self?.viewModel?.didJoinSuccessfully = false
                            }
                            
                        case "session_ended":
                            print("SESSION ENDED")

                        default:
                            print("🤖WEBSOCKET: Evento \(event.type) ignorato")
                        }

                    } catch {
                        print("Errore decodifica JSON: \(error)")
                    }
                }

                case .data(let data):
                    print("Ricevuti dati binari: \(data)")
                @unknown default:
                    break
                }
            }
            // Continua ad ascoltare
            self?.receiveMessage()
        }
    }

    func start() {
        receiveMessage()
    }
    
    
    func close() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        print("Websocket CLOSEDSDDD")
    }
    
    
}






















// WINNER REASON OGGETTO
//                        case "player_joined":
//                            if let username = event.username {
//                                print("Giocatore unito: \(username)")
//                                DispatchQueue.main.async {
//                                    let newPlayer = Player(username: username, profileImageURL: nil)
//                                    self?.viewModel?.addPlayer(newPlayer)
//                                }
//                            }
//
//                        case "player_status":
//                            if let username = event.username, let status = event.status {
//                                print("WS: player_status event — \(username) -> \(status)")
//                                DispatchQueue.main.async { [weak self] in
//                                    self?.viewModel?.handlePlayerStatusEvent(username: username, status: status)
//                                }
//                            } else {
//                                print("WS: player_status senza username/status")
//                            }
                            
                            // WebSocketSessionManager: quando ricevi player_joined
