
struct UserInfo: Codable {
    var username: String = ""
    var email: String = ""
    var first_name: String = ""
    var last_name: String = ""
    var date_of_birth: String = ""
    
    var profile_image: String? = nil
}

struct ChangePasswordModel: Codable {
    var old_password: String = ""
    var new_password: String = ""
    var new_password2: String = ""
}

struct ChangePasswordResponseModel: Decodable {
    var detail: String = ""
    var old_password: String? = nil
}

struct ChangeUsernameModel: Codable {
    var username: String = ""
}

struct ChangeUsernameResponseModel: Decodable {
    var detail: String = ""
}
