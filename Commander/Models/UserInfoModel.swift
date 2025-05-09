//struct UserInfoModel: Decodable {
  //  let username: String
    //let profilePic: String
    //let stateUser: String
//}


struct UserInfoModel: Decodable {
    let users: [Profile]
}

struct Profile: Decodable {
    let username: String
    let image: String
}



