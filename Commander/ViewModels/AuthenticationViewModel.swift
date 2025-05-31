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

        print("✅ API URL:", fullURL)
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
    
    // var for login
    @Published var isLoggedIn: Bool = false
    @Published var triedToLogin: Bool = false
    
    // var for checking if credentials are valid
    @Published var isBirthdayValid: Bool = false
    @Published var isEmailValid: Bool = true
    
    // for tokens
    @Published var accessToken: String?
    @Published var refreshToken: String?
    
    @Published var isOTPvalid: Bool = false
    
    private var headers: HTTPHeaders = [
        "Accept" : "application/json",
        "Content-Type" : "application/json"
    ]
    
    
    /// LOG IN URL
    private var loginURL = Environment.baseURL + "/login/"
    
    ///OTP URLS
    private var requestOTPURL = Environment.baseURL + "/login/request-otp/"
    private var verifyOTPURL = Environment.baseURL + "/login/verify-otp/"
    
    /// REFRESH TOKEN
    private var tokenRefreshURL = Environment.baseURL + "/token/refresh/"
    
    
    let keychain = Keychain(service: "com.InsalataCreativa.Commander")
    
    init() {
            loadTokensFromKeychain()
        }

    func loadTokensFromKeychain() {
        do {
            accessToken = try keychain.get("accessToken")
            refreshToken = try keychain.get("refreshToken")
            if accessToken != nil {
                isLoggedIn = true
                isOTPvalid = true
                print(isLoggedIn)

            } else {
                isLoggedIn = false
            }
        } catch {
            print("Errore caricamento token:", error)
            isLoggedIn = false
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
        print("Ciao Ethi", credentials)
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
        
        
        // request otp codable: username & password
    func requestOTP() {
        AF.request(requestOTPURL, method: .post, parameters: credentials)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: OTPRequestResponseModel.self) { response in
                switch response.result {
                case .success(let token):
                    
                    print("Hai requestato l'OTP", token)
                    
                case .failure (let error):
                    self.errorMessage = error.localizedDescription
                    print("Hai requestato l'OTP", error)
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
////                        .fetchUserInfo()
//                        
//                    case .failure(let error):
//                        self.errorMessage = error.localizedDescription
//                        print("Errore refreshAccessToken():", error)
//                           
//                }
//            }
//        }
//    }
    
    func refreshAccessToken(completion: (() -> Void)? = nil) {
        guard let refreshToken = try? keychain.get("refreshToken") else { return }

        AF.request(tokenRefreshURL, method: .post, parameters: ["refresh": refreshToken], encoder: JSONParameterEncoder.default, headers: self.headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: RefreshTokenResponseModel.self) { response in
                switch response.result {
                case .success(let token):
                    do {
                        try self.keychain.set(token.access, key: "accessToken")
                        self.accessToken = token.access
                        print("Access token refreshed.")
                        completion?()
                    } catch {
                        print("Errore salvataggio nuovo token:", error)
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Errore refreshAccessToken():", error)
                }
            }
    }

    
    func logout() {
        /// remove tokenbs and clears data saved in userDefaults
        do {
            try keychain.remove("accessToken")
            try keychain.remove("refreshToken")
            UserDefaults.standard.removeObject(forKey: "userProfile")
        } catch {
            print("Errore rimozione token:", error)
        }
        
        accessToken = nil
        refreshToken = nil
        authToken = nil
        isLoggedIn = false
        isOTPvalid = false
        credentials = Credentials() // resetta credenziali
        user = nil
    }

}

