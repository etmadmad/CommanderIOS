//import Foundation
//
//let sessionRoomCode = "ABC123" // Sostituisci con il codice reale della sessione
//let url = URL(string: "ws://5.189.158.70/ws/session/\(sessionRoomCode)/")!
//let webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
//webSocketTask.resume()
//
//func receiveMessage() {
//    webSocketTask.receive { result in
//        switch result {
//        case .failure(let error):
//            print("WebSocket error: \(error)")
//        case .success(let message):
//            switch message {
//            case .string(let text):
//                print("Ricevuto messaggio: \(text)")
//                // Qui puoi fare il parsing del JSON e aggiornare la UI
//            case .data(let data):
//                print("Ricevuti dati binari: \(data)")
//            @unknown default:
//                break
//            }
//        }
//        // Continua ad ascoltare
//        receiveMessage()
//    }
//}
//
//// Avvia la ricezione
//receiveMessage()
//{
//  "type": "player_status",
//  "player_id": "42",
//  "status": "Eliminated",
//  "username": "pippo"
//}
//
//struct PlayerStatusEvent: Codable {
//    let type: String
//    let player_id: String
//    let status: String
//    let username: String
//}
//
//


import Foundation

struct PlayerStatusEvent: Codable {
    let type: String
    let player_id: String
    let status: String
    let username: String
}

class WebSocketSessionManager {
    private let sessionRoomCode = "ABC123"
    private var webSocketTask: URLSessionWebSocketTask?

    init() {
        let url = URL(string: "ws://5.189.158.70/ws/session/\(sessionRoomCode)/")!
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
                    // Parsing del JSON
                    if let data = text.data(using: .utf8) {
                        do {
                            let event = try JSONDecoder().decode(PlayerStatusEvent.self, from: data)
                            print("Evento decodificato: \(event)")
                            // Qui aggiorna la UI o gestisci l'evento
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
}

// USO:
let manager = WebSocketSessionManager()
manager.start()

// Esempio di messaggio JSON ricevuto:
// {
//   "type": "player_status",
//   "player_id": "42",
//   "status": "Eliminated",
//   "username": "pippo"
// }
