import Foundation
import Alamofire
import KeychainAccess
import UIKit

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
    @Published var selectedImageData: Data? = nil
    
    let authVM: AuthtenticationViewModel
    
    private var currentUserURL = Environment.baseURL + "/current-user/"
    private var uploadImageURL = Environment.baseURL + "/change-profile-image/"
    
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
                    
                    /// if access token is ok, it saves data user
                    if let user = try? decoder.decode(UserInfo.self, from: data) {
                        print("access token ok", user)
                        self.userInfo = user
                        self.saveUserInfo(user)
                    }
                    /// access token expired
                    //                    else if let _ = try? decoder.decode(TokenUserExpired.self, from: data) {
                    //                        print("token access about to refresh")
                    //                        self.authVM.refreshAccessToken {
                    //                            self.fetchUserInfo()
                    //                        }
                    //                    }
                    
                    else if let _ = try? decoder.decode(TokenUserExpired.self, from: data) {
                        print("token access about to refresh")
                        self.authVM.getNewAccessToken { result in
                            switch result {
                            case .success:
                                self.fetchUserInfo()
                            case .failure:
                                print("Refresh token failed, user has been logged out.")
                                self.authVM.logout()
                            }
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
    
    
    
    
    func uploadProfileImage(_ image: UIImage) {
        guard let token = try? keychain.get("accessToken") else {
                print("Token not found")
                return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-type": "multipart/form-data"
        ]
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to get JPEG data from image")
            return
        }
        
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "profile_image", fileName: "image.jpg", mimeType: "image/jpeg")
            },
            to: uploadImageURL,
            method: .post,
            headers: headers
        ).response { response in
            switch response.result {
            case .success(let data):
                print("Server responded with: \(String(data: data ?? Data(), encoding: .utf8) ?? "")")
            case .failure(let error):
                print("Upload failed with error: \(error)")
            }
        }
    }
}

