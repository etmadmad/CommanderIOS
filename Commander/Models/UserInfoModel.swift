struct UserInfoModel: Decodable {
    let users: [Profile]
}

struct Profile: Decodable {
    let username: String
    let image: String
}



