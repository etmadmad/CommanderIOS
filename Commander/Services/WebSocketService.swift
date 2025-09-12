
import Foundation

struct PlayerStatusEvent: Codable {
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
                            let event = try JSONDecoder().decode(PlayerStatusEvent.self, from: data)
                            print("Evento decodificato: \(event)")
                            
                            if event.type == "player_joined", let username = event.username {
                                print("CRISTODIO: Giocatore unito: \(username)")
                                DispatchQueue.main.async {
                                    let newPlayer = Player(
//                                        id: event.player_id,
                                        username: username,
                                        profileImageURL: nil // lo recuperiamo dopo
                                    )
                                    
                                    self?.viewModel?.addPlayer(newPlayer)
                                }
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

