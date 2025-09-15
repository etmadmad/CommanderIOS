import Foundation

//MARK: - FOR GETTING GAME CONFIGURATIONS

struct GamesModel: Codable {
    var founderGames: [FounderGame] = []
    var adminGames: [FounderGame] = []

    enum CodingKeys: String, CodingKey {
        case founderGames = "founder_games"
        case adminGames = "admin_games"
    }
}
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



//MARK: - CREATE SESSION
struct CreateSessionModel: Decodable {
    var id: String
    var session_status: String
    var session_room_code: String
}

//MARK: - JOIN SESSION

struct JoinGameResponse: Decodable {
    let detail: String?
    let session_room_code: String?
    
}

//MARK: - LEAVE SESSION

struct LeaveSessionResponseModel: Decodable {
    let detail: String
}


//MARK: - PLAYERS IN SESSION
struct PlayersInSessionResponse: Decodable {
    let players: [PlayerModel]
}

struct PlayerModel: Decodable {
    let id: String
    let username: String
    let player_status: String
    let profile_image: String?
}



//MARK: - SESSION CONFIGURATION
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



//MARK: - TEAMS
struct TeamsModel: Codable {
    let id: String?
    let team_name: String
}
 
struct SessionStartedResponse: Codable {
    let detail: String?
    let non_field_errors: String?
}


//MARK: - PLAYERS (in session + in the teams)
struct Player: Identifiable, Codable, Hashable {
    var id: String { username }
    var username: String
    var profileImageURL: String? 
}

struct UserImageResponse: Codable {
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
  
    }
}

/// PLAYERS IN THE TEAMS
struct PlayersInTeamResponse: Decodable {
    let id, teamName: String
    var players: [PlayerInSessionStatus]

    enum CodingKeys: String, CodingKey {
        case id
        case teamName = "team_name"
        case players
    }
}

/// PLAYER IN SESSION MODEL
struct PlayerInSessionStatus:  Codable, Identifiable, Equatable {
    var id: String { username }
    let username: String
    var profileImage: String?
    var playerStatus: String

    enum CodingKeys: String, CodingKey {
        case username
        case profileImage = "profile_image"
        case playerStatus = "player_status"
    }
}

//MARK: - CHANGE STATUS PLAYER
struct ChangeStatusPlayerModel: Encodable {
    let playerStatus: String
    
    enum CodingKeys: String, CodingKey {
        case playerStatus = "player_status"
    }
}

struct ChangeStatusPlayerResponse: Decodable {
    let detail: String?
    let winner: [String]?
}
