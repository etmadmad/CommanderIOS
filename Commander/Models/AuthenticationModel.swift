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


// token
struct MessageTokenExpired: Decodable {
    var token_class: String = ""
    var token_type: String = ""
    var message: String = ""
}

struct TokenUserExpired: Decodable {
    var detail: String = ""
    var code: String = ""
    var message: MessageTokenExpired
}


struct RefreshTokenResponseModel: Decodable {
    var access: String
}
