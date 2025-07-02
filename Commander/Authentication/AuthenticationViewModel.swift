import SwiftUI
import Foundation
import Alamofire
import KeychainAccess


struct Environment {
    static var baseURL: String {
        let scheme = getConfigValue(forKey: "API_SCHEME")
        let host = getConfigValue(forKey: "API_BASE_URL")
        
        let fullURL = "\(scheme)://\(host)"
        print(fullURL)
        
        guard let validatedURL = URL(string: fullURL), UIApplication.shared.canOpenURL(validatedURL) else {
            fatalError("Invalid URL formed from APP_SCHEME and APP_BASE_URL: \(fullURL)")
        }

        print("API URL:", fullURL)
        return fullURL
    }
    
//    static var staticFileBaseURL: String {
//           let scheme = getConfigValue(forKey: "API_SCHEME")
//           let host = getConfigValue(forKey: "API_BASE_URL")
//           return "\(scheme)://\(host)" // 🚫 niente `/api`
//       }


    static var imageBaseURL: String {
        let scheme = getConfigValue(forKey: "API_SCHEME")
        let host = getConfigValue(forKey: "IMAGE_BASE_URL")
        
        let fullURL = "\(scheme)://\(host)"
        
        guard let validatedURL = URL(string: fullURL), UIApplication.shared.canOpenURL(validatedURL) else {
            fatalError("Invalid Image URL formed: \(fullURL)")
        }

        return fullURL
    }
    
    private static func getConfigValue(forKey key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            fatalError("\(key) not found in Info.plist")
        }
        return value
    }
}


class AuthtenticationViewModel: ObservableObject {
    @Published var credentials = Credentials()
    @Published var user: UserModel?
    @Published var errorMessage: String?
    @Published var authToken: AuthToken?
    @Published var otpModel = OTPVerificationModel()
    
    /// LOGIN
    @Published var isLoggedIn: Bool = false
    @Published var triedToLogin: Bool = false
    
    /// AGE, EMAIL, OTP
    @Published var isBirthdayValid: Bool = false
    @Published var isEmailValid: Bool = true
    @Published var isOTPvalid: Bool = false
    
   /// TOKENS
    var accessToken: String? {
        guard let accessToken = try? keychain.get("accessToken") else { return nil }
        return accessToken
    }
    var refreshToken: String? {
        guard let refreshToken = try? keychain.get("refreshToken") else { return nil }
        return refreshToken
    }
    
    /// HEADERS
    private var headers: HTTPHeaders = [
        "Accept" : "application/json",
        "Content-Type" : "application/json"
    ]
    
    
    /// URLS
    private var loginURL = Environment.baseURL + "/login/"
    private var requestOTPURL = Environment.baseURL + "/login/request-otp/"
    private var verifyOTPURL = Environment.baseURL + "/login/verify-otp/"
    private var tokenRefreshURL = Environment.baseURL + "/token/refresh/"
    private var logoutURL = Environment.baseURL + "/logout/"
    private var deleteAccountURL = Environment.baseURL + "/delete-account/"
    
    
    /// KEYCHAIN
    let keychain = Keychain(service: "com.InsalataCreativa.Commander")
    
    
    init() {
            loadTokensFromKeychain()
        }

    func loadTokensFromKeychain() {
        if accessToken == nil && refreshToken == nil {
            isLoggedIn = false
            return
        }
        isAccessTokenValid { isValid in
            if isValid {
                self.isLoggedIn = true
                self.isOTPvalid = true
//                print(self.accessToken, self.refreshToken)
            } else {
                self.getNewAccessToken { result in
                    switch result {
                        case .success:
                            print("Access token aggiornato con successo")
                            self.isLoggedIn = true
                            self.isOTPvalid = true
                        case .failure(let error):
                            print("Errore durante l'aggiornamento del token:", error)
                            self.isLoggedIn = false
                        }
                }
            }
        }
        
    }
    
    private func isAccessTokenValid(completion: @escaping (Bool) -> Void) {
        guard let token = accessToken else {
            completion(false)
            return
        }
        
        var headersCheck = headers
        headersCheck.add(name: "Authorization", value: "Bearer \(token)")
        
        AF.request("\(Environment.baseURL)/current-user/", headers: headersCheck).validate().response {
            response in
            if response.response?.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    func validateEmail() {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex) // class NSPredicate
        isEmailValid = emailPredicate.evaluate(with: credentials.username)
    }
    
    func checkInput() {
        print("hai checkato gli input")
        triedToLogin = true
        if credentials.username.isEmpty || credentials.password.isEmpty {
            print("field vuoti")
            return
        }
        else {
            validateEmail()
            print(isEmailValid)
            
            /// TOLTO CHECK VALIDITÀ EMAIL PERCHÈ USERNAME
            
            //            if !isEmailValid {
            //                print("email non valida")
            //               errorMessage = "Invalid email address"
            //               return
            //            }
            //            else {
            print("provato il login")
            login()
            
        }
    }
        
    func login() {
        // added JSONParameterEncoder.default, controlla l'encoder anche di email
        print("Login Requested", credentials)
        AF.request(loginURL, method: .post, parameters: credentials, encoder: JSONParameterEncoder.default, headers: self.headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: AuthToken.self) { response in
                switch response.result {
                    
                case .success(let token):
                    self.authToken = token
                    self.isLoggedIn = true
                    
                    print(response.result, self.isLoggedIn)
                    if self.isLoggedIn {
                        self.requestOTP()
                        print("è logged in e ha fatto la request otp")
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Errore Ethi", error)
                    
                                              
                }
            }
    }
    
//    func deleteAccount () {
//        print("Delete Account Requested")
//        AF.request(deleteAccountURL, method: .delete, parameters: accessToken, encoder: JSONParameterEncoder.default)
//            .validate(statusCode: 200..<300)
//            .response { response in
//                if let error = response.error {
//                    self.errorMessage = error.localizedDescription
//                    print("Error Delete Account", error)
//                    return
//                }
//                // Success
//                print("Account Deleted")
//                self.isLoggedIn = false
//                self.authToken = nil
//                self.isOTPvalid = false
//                self.credentials = Credentials()
//                self.user = nil
//            }
//    }
    
    func deleteAccount () {
        print("Delete Account Requested")
        guard let token = accessToken else {
            self.errorMessage = "Token non trovato"
            print("Token non trovato")
            return
        }
        var headersWithAuth = headers
        headersWithAuth.add(name: "Authorization", value: "Bearer \(token)")

        AF.request(deleteAccountURL, method: .delete, headers: headersWithAuth)
            .validate(statusCode: 200..<300)
            .response { response in
                if let error = response.error {
                    self.errorMessage = error.localizedDescription
                    print("Error Delete Account", error)
                    return
                }
                
                print("Account Deleted")
                self.isLoggedIn = false
                self.authToken = nil
                self.isOTPvalid = false
                self.credentials = Credentials()
                self.user = nil
            }
    }
        
        
    func requestOTP() {
        AF.request(requestOTPURL, method: .post, parameters: credentials)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: OTPRequestResponseModel.self) { response in
                switch response.result {
                case .success(let token):
                    
                    print("OTP Requested", token)
                    
                case .failure (let error):
                    self.errorMessage = error.localizedDescription
                    print("ERROR OTP Request", error)
                }}
    }
        
    func verifyOTP() {
        let otp = otpModel.otp
        otpModel.username = credentials.username
        AF.request(verifyOTPURL, method: .post, parameters: ["username": otpModel.username, "otp" : otp])
            .validate(statusCode: 200..<300)
            .responseDecodable(of: OTPVerificationResponseModel.self) { response in
                switch response.result {
                case .success(let token):
                    print("Il risultato della tua verifica otp è", token)
                    do {
                       try self.keychain.set(token.access, key: "accessToken")
                       try self.keychain.set(token.refresh, key: "refreshToken")
                       print("Tokens salvati con KeychainAccess")
                   } catch {
                       print("Errore nel salvataggio token:", error)
                   }
                    self.isOTPvalid = true
                case .failure (let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                }}
        
        
    }
    

    enum AuthError: Error {
        case refreshTokenNotFound
        case keychainSaveError(Error)
        // altri casi di errore se necessario
    }

    func getNewAccessToken(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let refreshToken = try? keychain.get("refreshToken") else {
            completion(.failure(AuthError.refreshTokenNotFound)) // Definisci un errore apposito
            logout() // Logout se non c'è il refresh token
            return
        }

        AF.request(tokenRefreshURL, method: .post, parameters: ["refresh": refreshToken], encoder: JSONParameterEncoder.default, headers: self.headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: RefreshTokenResponseModel.self) { response in
                switch response.result {
                case .success(let token):
                    do {
                        try
                        ///  if refresh token is valid, it sends me a new access token
                        self.keychain.set(token.access, key: "accessToken")
                        print("Access token refreshed.")
                        completion(.success(()))
                    } catch {
                        print("Errore salvataggio nuovo token:", error)
                        completion(.failure(error))
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Errore refreshAccessToken():", error)
                    self.logout()
                    completion(.failure(error))
                }
            }
    }
    
    func logout() {
        /// remove tokens and clears data saved in userDefaults
        do {
            try keychain.remove("accessToken")
            try keychain.remove("refreshToken")
            UserDefaults.standard.removeObject(forKey: "userProfile")
        } catch {
            print("Errore rimozione token:", error)
        }
        
        authToken = nil
        isLoggedIn = false
        isOTPvalid = false
        credentials = Credentials() // resetta credenziali
        user = nil
    }

}


