
import Foundation

struct PlayerStatusEvent: Codable {
    let type: String
    let player_id: String
    let status: String?
    let username: String?
}

class WebSocketSessionManager {
    private let sessionRoomCode: String
    private var webSocketTask: URLSessionWebSocketTask?

    init(sessionRoomCode: String) {
        self.sessionRoomCode = sessionRoomCode
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
    }
}

