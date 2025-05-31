import Foundation

struct UserRegistrationModel: Codable {
    var username: String = ""
    var password: String = ""
    var password2: String = ""
    var email: String =  ""
    var first_name: String = ""
    var last_name: String = ""
    var date_of_birth: Date = Date()
//    var profile_image: String? = nil
    
}

//  prima era var profile_image: Data? = nil

struct UsernameTakenModel: Decodable {
    let username_taken: Bool
}

struct EmailTakenModel: Decodable {
    let email_taken: Bool
}

struct RegistrationResponse: Decodable {
    var message: String = ""
    let user: User
}

/// tolto ?
struct User: Codable {
    let id: String
    let username: String
    let email: String
    let first_name: String
    let last_name: String
    let date_of_birth: String
    let profile_image: String?
}

