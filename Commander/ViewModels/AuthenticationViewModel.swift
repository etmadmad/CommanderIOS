import SwiftUI
import Foundation
import Alamofire
//POST nome cognome data di nascita username email password due volte immagine
//jwt 1 codice per accesso sessione effettiva e dura 1 gg, l'altro per rigenerare il codice di sessione e dura 7 giorni, se metto nel portachiavi codice sessione mi accede direttamente, se invece ho codice 7 gg ti fa riaccedere ma senza OTP
// risponde se c'è qualche problema con i dati ex se due password spono diverse, data d nascita è nel futuro e se è minore di 14 anni non può
// se utente o l'email sono già state usate e se la password non è buona

// non ci sarà sessione nella versione mobile
struct Credentials: Codable {
    var username: String = ""
    var password: String = ""
}

struct Environment {
    static var baseURL: String {
        let scheme = getConfigValue(forKey: "API_SCHEME")
        let host = getConfigValue(forKey: "API_BASE_URL")
        
        let fullURL = "\(scheme)://\(host)"
        
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


struct AuthToken: Decodable {
    var refresh: String
    var access: String
}

struct UserModel: Decodable {
    var username: String
    var emai: String
    var first_name: String
    var last_name: String
    var date_of_birth: String
}

class AuthtenticationViewModel: ObservableObject {
    @Published var credentials = Credentials()
    @Published var user: UserModel?
    @Published var errorMessage: String?
    
    @Published var isLoggedIn: Bool = false
    @Published var triedToLogin: Bool = false
    
    // var for checking if credentials are valid
    @Published var isBirthdayValid: Bool = false
    @Published var isEmailValid: Bool = true
    
    private var headers: HTTPHeaders = [
        "Accept" : "Application/json"
    ]
    private var loginURL = Environment.baseURL + "/login/"
    
    func validateEmail() {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex) // class NSPredicate
        isEmailValid = emailPredicate.evaluate(with: credentials.username)
    }
    
    func checkInput() {
        triedToLogin = true
        if credentials.username.isEmpty || credentials.password.isEmpty {
            return
        }
        validateEmail()
        if !isEmailValid {
           errorMessage = "Invalid email address"
           return
        }
        login()
        
    }
    
    func login() {
        print(loginURL)
        let credentials = ["username": credentials.username, "password": credentials.password]
//        AF.request(loginURL, method: .post, parameters: credentials, encoding: JSONEncoding.default, headers: self.headers)
//            .responseJSON {
//                response in
//                debugPrint(response)
//            }
        AF.request(loginURL, method: .post, parameters: credentials, headers: self.headers)
            .responseDecodable(of: AuthToken.self) { response in
                switch response.result {
                case .success(let token):
                    print(token)
                    self.isLoggedIn = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print(error)
                }
   
            }
    }
    
    func register() {
        isLoggedIn = true
    }
    
}

