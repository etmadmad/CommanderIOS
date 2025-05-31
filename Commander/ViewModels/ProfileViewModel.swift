import Foundation
import Alamofire
import KeychainAccess


struct UserInfo: Codable {
    var username: String = ""
    var email: String = ""
    var first_name: String = ""
    var last_name: String = ""
    var date_of_birth: String = ""
}



class ProfileViewModel: ObservableObject {
    @Published var userInfo = UserInfo()
    @Published var errorMessage: String?
    
    let authVM: AuthtenticationViewModel
    
    private var currentUserURL = Environment.baseURL + "/current-user/"

    private let keychain = Keychain(service: "com.InsalataCreativa.Commander")
    
    
    private var headers: HTTPHeaders = [
        "Accept" : "application/json",
        "Content-Type" : "application/json"
    ]
    
    
    init (authVM: AuthtenticationViewModel) {
        self.authVM = authVM
        if let cachedUser = loadUserInfoFromCache() {
            print("Caricato utente da cache")
            self.userInfo = cachedUser}
        else {
            fetchUserInfo()
        }
    }
    
    
    func fetchUserInfo() {
        guard let token = try? keychain.get("accessToken") else {
            self.errorMessage = "Token non trovato"
            return
        }
        
        headers.add(name: "Authorization", value: "Bearer \(token)")
        print(token)
        
        AF.request(currentUserURL, method: .get, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    
                    let decoder = JSONDecoder()
                    
                    /// if access token ok, saves data user
                    if let user = try? decoder.decode(UserInfo.self, from: data) {
                        print("fetch user chiamato", user)
                        self.userInfo = user
                        self.saveUserInfo(user)
                    }
                    /// access token expired
                    else if let _ = try? decoder.decode(TokenUserExpired.self, from: data) {
                        print("token access about to refresh")
                        self.authVM.refreshAccessToken {
                            self.fetchUserInfo()
                        }
                    }
                    
                    else {
                        print("What the helly")
                    }
                    
                case .failure(let error):
                    print("Errore fetchUserInfo(): \(error)")
                }
            }
        
    }
    

    func saveUserInfo(_ profile: UserInfo) {
        if let encoded = try? JSONEncoder().encode(profile) {
             UserDefaults.standard.set(encoded, forKey: "userProfile")
         }
    }
    
    func loadUserInfoFromCache() -> UserInfo? {
            if let data = UserDefaults.standard.data(forKey: "userProfile"),
               let user = try? JSONDecoder().decode(UserInfo.self, from: data) {
                return user
            }
            return nil
        }
    
    
   }

//    func fetchUserInfo() {
//       guard let token = try? keychain.get("accessToken") else {
//           self.errorMessage = "Token non trovato"
//           return
//       }
//
//       headers.add(name: "Authorization", value: "Bearer \(token)")
//        print(token)
//
//       AF.request(currentUserURL, method: .get, headers: headers)
//           .validate(statusCode: 200..<300)
//           .responseDecodable(of: UserInfo.self) { response in
//               switch response.result {
//
//               case .success(let user):
//                   print("fetch user chiamato")
//                   self.userInfo = user
//                   self.saveUserInfo(user)
//               case .failure(let error):
//                   self.errorMessage = error.localizedDescription
//               }
//           }
//       }

/// if refresh token is still available -> new access Token
//    func refreshAccessToken() {
//        let refreshToken = try? keychain.get("refreshToken")
//
//        if refreshToken != nil {
//            AF.request(tokenRefreshURL, method: .post, parameters: refreshToken, encoder: JSONParameterEncoder.default, headers: self.headers)
//                .validate(statusCode: 200..<300)
//                .responseDecodable(of: RefreshTokenResponseModel.self) { response in
//                    switch response.result {
//
//                    case .success(let accessToken):
//                        print(response.result)
//                        do {
//                            try self.keychain.set(accessToken.access, key: "accessToken")}
//                        catch {
//                            print("Errore nel salvataggio token:", error)
//                        }
//                        self.fetchUserInfo()
//
//                    case .failure(let error):
//                        self.errorMessage = error.localizedDescription
//                        print("Errore refreshAccessToken():", error)
//
//                }
//            }
//        }
//    }
