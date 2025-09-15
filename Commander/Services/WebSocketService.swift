
import Foundation

struct WebSocketEvent: Decodable {
    let type: String
    let reason: String?
    let winner: Winner?
    let player_id: String?
    let status: String?
    let username: String?
}
struct WinnerPlayer: Codable, Identifiable {
    let id: String
    let username: String
}

///DESERIALIZER
enum Winner: Decodable {
    case players([WinnerPlayer])
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let arr = try? container.decode([WinnerPlayer].self) {
            self = .players(arr)
        } else if let str = try? container.decode(String.self) {
            self = .string(str)
        } else {
            throw DecodingError.typeMismatch(
                Winner.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Winner is neither array nor string"
                )
            )
        }
    }
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
                    self?.handleMessageWebsocket(text: text)
                case .data(let data):
                    print("Ricevuti dati binari: \(data)")
                @unknown default:
                    break
                }
            }
            self?.receiveMessage()
        }
    }

    
    func handleMessageWebsocket(text: String) {
        print("Ricevuto messaggio: \(text)")
        guard let data = text.data(using: .utf8) else { return }
        do {
            let event = try JSONDecoder().decode(WebSocketEvent.self, from: data)
            print("Evento decodificato: \(event)")
            switch event.type {
            case "player_joined":
                if let username = event.username {
                    DispatchQueue.main.async {
                        self.viewModel?.addPlayer(PlayerInSessionStatus(username: username, profileImage: nil, playerStatus: "Alive"))
                    }
                }
            case "player_status":
                if let username = event.username, let status = event.status {
                    DispatchQueue.main.async {
                        self.viewModel?.updateJoinedPlayerStatus(username: username, status: status)
                    }
                }
            case "session_started":
                DispatchQueue.main.async {
                    self.viewModel?.isGameStarted = true
                }
            case "session_closed":
                DispatchQueue.main.async {
                    self.viewModel?.isGameStarted = false
                    self.viewModel?.didJoinSuccessfully = false
                }
            case "session_ended":
                self.handleSessionEnded(event)
                self.viewModel?.showSessionEndedView = true
                print("🟡🟡🟡🟡🟡🟡🟡SESSIONE TERMINATA")
            default:
                print("🤖WEBSOCKET: Evento \(event.type) ignorato")
            }
        } catch {
            print("Errore decodifica JSON: \(error)")
        }
    }

    
    func handleSessionEnded(_ event: WebSocketEvent) {
        print("SESSION ENDED: reason=\(event.reason ?? "nil")")
        var winnersArray: [WinnerPlayer]? = nil
        if let winner = event.winner {
            /// IF WINNER IS STRING OR ARRAY
               switch winner {
               case .players(let array):
                   winnersArray = array
               case .string(_):
                   winnersArray = nil
               }
           }
           DispatchQueue.main.async {
               self.viewModel?.handleSessionEnded(reason: event.reason, winners: event.winner)
           }

    }

    func start() {
        receiveMessage()
    }

    func close() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        print("WebSocket CLOSED")
    }
}
