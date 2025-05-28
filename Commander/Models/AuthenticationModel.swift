import Foundation

/// Backend responds with authtoken
struct Credentials: Codable {
    var username: String = ""
    var password: String = ""
}

struct AuthToken: Decodable {
    var refresh: String
    var access: String
}

struct AuthError: Decodable {
    var detail: String?
}

struct UserModel: Decodable {
    var username: String
    var email: String
    var first_name: String
    var last_name: String
    var date_of_birth: String
}

struct OTPRequestResponseModel: Decodable {
    var detail: String
}

/// OTP VERIFICATION MODELS
struct OTPVerificationModel: Codable {
    var username: String = ""
    var otp: String = ""
}

struct OTPVerificationResponseModel: Decodable {
    var refresh: String
    var access: String
}

