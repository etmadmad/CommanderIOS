import Foundation

struct BombDetails: Codable {
    let bombCoordinateX: String
    let bombCoordinateY: String
    let bombNfcCode: String
    let defuseTimeSeconds: Int

    enum CodingKeys: String, CodingKey {
        case bombCoordinateX = "bomb_coordinate_x"
        case bombCoordinateY = "bomb_coordinate_y"
        case bombNfcCode = "bomb_nfc_code"
        case defuseTimeSeconds = "defuse_time_seconds"
    }
}

struct FounderGame: Codable {
    let id: String
    let configurationName: String
    let configurationDescription: String
    let game_mode_name: String
    let maxPlayers: Int
    let bombDetails: BombDetails?
    let matchDurationMinutes: Int

    enum CodingKeys: String, CodingKey {
        case id
        case configurationName = "configuration_name"
        case configurationDescription = "configuration_description"
        case game_mode_name = "game_mode_name"
        case maxPlayers = "max_players"
        case bombDetails = "bomb_details"
        case matchDurationMinutes = "match_duration_minutes"
    }
}

struct GamesModel: Codable {
    var founderGames: [FounderGame] = []
    var adminGames: [FounderGame] = [] 

    enum CodingKeys: String, CodingKey {
        case founderGames = "founder_games"
        case adminGames = "admin_games"
    }
}

struct CreateSessionModel: Decodable {
    var id: String
    var session_status: String
    var session_room_code: String
}

struct JoinGameResponse: Decodable {
    let detail: String?
    let session_room_code: String?
    
}

struct PlayersInSessionResponse: Decodable {
    let players: [PlayerModel]
}

struct PlayerModel: Decodable {
    let id: String
    let username: String
    let player_status: String
    let profile_image: String?
}

struct LeaveSessionResponseModel: Decodable {
    let detail: String
}

struct SessionConfigResponseModel: Codable {
    let id, configurationName, configurationDescription: String
    let maxPlayers: Int
    let gameModeName: String
    let bombDetails: BombDetails?
    let matchDurationMinutes: Int

    enum CodingKeys: String, CodingKey {
        case id
        case configurationName = "configuration_name"
        case configurationDescription = "configuration_description"
        case maxPlayers = "max_players"
        case gameModeName = "game_mode_name"
        case bombDetails = "bomb_details"
        case matchDurationMinutes = "match_duration_minutes"
    }
}

struct Player: Identifiable, Codable, Hashable {
    var id: String { username }
    var username: String
    var profileImageURL: String? // la riempiamo con la chiamata API successiva
}

struct UserImageResponse: Codable {
    let profile_image: String
}

struct TeamsModel: Codable {
    let id: String?
    let team_name: String
}
 
struct SessionStartedResponse: Codable {
    let detail: String?
    let non_field_errors: String?
}
