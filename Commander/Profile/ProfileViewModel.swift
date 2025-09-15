import Foundation
import Alamofire
import KeychainAccess
import UIKit


class ProfileViewModel: ObservableObject {
    @Published var userInfo = UserInfo()
    @Published var changePasswordData = ChangePasswordModel()
    @Published var newUsernameData = ChangeUsernameModel()
    
    @Published var isNewPasswordValid: Bool = false
    @Published var errorMessage: String?
    @Published var selectedImageData: Data? = nil
    @Published var doNewPasswordMatch: Bool = false
    
    @Published var isNewUsernameValid: Bool = false
    @Published var isOldPasswordCorrect: Bool = false
    
    let authVM: AuthtenticationViewModel
    private var usernameDebounceTimer: Timer?
    
    private var currentUserURL = Environment.baseURL + "/current-user/"
    private var uploadImageURL = Environment.baseURL + "/change-profile-image/"
    private var changePasswordURL = Environment.baseURL + "/change-password/"
    private var checkUsernameURL = Environment.baseURL + "/check-username/"
    private var changeUsernameURL = Environment.baseURL + "/change-username/"
    
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
                        print("Profile image URL:", user.profile_image ?? "Nessuna immagine")
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
                self.fetchUserInfo()
            case .failure(let error):
                print("Upload failed with error: \(error)")
            }
        }
    }
    
    func validateChangePassword() {
        let password = changePasswordData.new_password
        var errors: [String] = []

        if password.count < 8 {
            errors.append("Password must be at least 8 characters long.")
        }
        if password.range(of: "[A-Z]", options: .regularExpression) == nil {
            errors.append("Password must contain at least one uppercase letter.")
        }
        if password.range(of: "[a-z]", options: .regularExpression) == nil {
            errors.append("Password must contain at least one lowercase letter.")
        }
        if password.range(of: "[0-9]", options: .regularExpression) == nil {
            errors.append("Password must contain at least one number.")
        }
        if password.range(of: "[#?!@$%^&*\\-£€]", options: .regularExpression) == nil {
            errors.append("Password must contain at least one special character.")
        }

        if errors.isEmpty {
            isNewPasswordValid = true
            errorMessage = ""
        } else {
            isNewPasswordValid = false
            errorMessage = errors.first ?? ""
        }

        doNewPasswordMatch = changePasswordData.new_password == changePasswordData.new_password2
    }
    
    
    func validatePasswordViaAPI() {
        let password = changePasswordData.new_password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !password.isEmpty else {
            self.isNewPasswordValid = false
            self.errorMessage = "Password cannot be empty"
            return
        }
        
        let params = ["password": password]
        
        AF.request(changePasswordURL, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: PasswordValidationResponseModel.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let result):
                        print("password also checked with api")
                        self.isNewPasswordValid = result.password_valid
                        self.errorMessage = result.error ?? ""
                    case .failure(let error):
                        print("Errore validazione password: \(error)")
                        self.isNewPasswordValid = false
                        self.errorMessage = "Errore di connessione al server"
                    }
                }
            }
    }
    /// CONVALIDATION NEW USERNAME
    func validateNewUsername() {
        /// TIMER
        usernameDebounceTimer?.invalidate()
        
        usernameDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            let username = newUsernameData.username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            
            guard !username.isEmpty else {
                self.isNewUsernameValid = false
                return
            }
            
            /// API CALL
            AF.request(checkUsernameURL, method: .post, parameters: ["username": username], encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodable(of: UsernameTakenModel.self) { response in
                    DispatchQueue.main.async {
                        switch response.result {
                            
                        case .success(let result):
                            self.isNewUsernameValid = result.username_taken
                            print("chiamata af fatta, username taken:", result)
                        case .failure:
                            self.isNewUsernameValid = false
                    }
                }
            }
        }
    }
    /// CHANGE NEW USERNAME
    func changeUsername() {
        guard let token = try? keychain.get("accessToken") else {
            self.errorMessage = "Token non trovato"
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept" : "application/json",
            "Content-Type" : "application/json"]
        
        AF.request(changeUsernameURL, method: .post, parameters: ["username": newUsernameData.username],
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate()
            .responseDecodable(of: ChangeUsernameResponseModel.self) { response in
                    switch response.result {
                    case .success(let result):
                        self.fetchUserInfo()
                        print("Username changed successfully: \(result)")
                        
                    case .failure(let result):
                        print(result)
                        print("ERROR: Username change failed.")
                    
                }
            }
    }
    
    func changePassword() {
        guard let token = try? keychain.get("accessToken") else {
            self.errorMessage = "Token non trovato"
            return
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept" : "application/json",
            "Content-Type" : "application/json"
        ]

        let params: [String: String] = [
            "old_password": changePasswordData.old_password,
            "new_password": changePasswordData.new_password,
            "new_password2": changePasswordData.new_password2
        ]
        AF.request(changePasswordURL, method: .post, parameters: params,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate()
            .responseDecodable(of: ChangePasswordResponseModel.self) { response in
                
                    switch response.result {
                    case .success(let result):
                        self.isOldPasswordCorrect = true
                        print("Password changed successfully: \(result)")
                        
                    case .failure(let result):
                        self.isOldPasswordCorrect = false

                       if let data = response.data,
                          let decodedError = try? JSONDecoder().decode(ChangePasswordResponseModel.self, from: data) {
                           if let oldPasswordError = decodedError.old_password {
                               self.errorMessage = oldPasswordError
                           } else {
                               self.errorMessage = decodedError.detail
                           }
                       } else {
                           self.errorMessage = "Errore generico nella modifica della password."
                       }
                        print("ERROR: Password change failed.")
                    
                }
            }
    }
}

