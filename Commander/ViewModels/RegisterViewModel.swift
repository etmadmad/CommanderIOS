import Foundation
import Alamofire


class RegisterViewModel: ObservableObject {
    @Published var registrationData = UserRegistrationModel()
    
    @Published var triedStep1: Bool = false
    @Published var triedStep2: Bool = false
    @Published var triedStep3: Bool = false
    
    @Published var isBirthdayValid: Bool = false
    @Published var isPasswordValid: Bool = false
    @Published var doPasswordsMatch: Bool = false
    @Published var isUsernameTaken: Bool = false
    
    @Published var isEmailValid: Bool = false
    @Published var isEmailTaken: Bool = false
    @Published var registrationSuccess: Bool = false
    @Published var triedApiCall: Bool = false
    
//    @Published var selectedImageData: Data? = nil

    
    
    private var emailDebounceTimer: Timer?
    private var usernameDebounceTimer: Timer?
    
    private var checkEmailURL = Environment.baseURL + "/check-email/"
    private var checkUsernameURL = Environment.baseURL + "/check-username/"
    private var registerUserURL = Environment.baseURL + "/register/"
    
    
    var errorMessage = ""
    
    func validateAge(minimumAge: Int = 14) {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: registrationData.date_of_birth, to: Date())
        let age = ageComponents.year ?? 0
        isBirthdayValid = age >= minimumAge
    }
    
    func validateEmail() {
        emailDebounceTimer?.invalidate()
        
        /// TIMER
        emailDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            let email = self.registrationData.email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            print(email)
            
            /// REGEX
            let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
            let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
            self.isEmailValid = emailPredicate.evaluate(with: email)
            
            guard self.isEmailValid && !email.isEmpty else {
                self.isEmailTaken = false // resetta errore se non valido
                return
            }
            
            /// API CALL
            let paramsEmail = ["email": email]
            AF.request(self.checkEmailURL, method: .post, parameters: paramsEmail, encoding: JSONEncoding.default)
                .responseDecodable(of: EmailTakenModel.self) { response in
                    switch response.result {
                    case .success(let result):
                        DispatchQueue.main.async {
                            self.isEmailTaken = result.email_taken
                        }
                    case .failure:
                        DispatchQueue.main.async {
                            self.isEmailTaken = false
                        }
                    }
                }
        }
    }
    
    
    func validateImmediatelyPassword() {
        let password = registrationData.password
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
        // aggiunto sterlina e simbolo euro
        if password.range(of: "[#?!@$%^&*\\-£€]", options: .regularExpression) == nil {
            errors.append("Password must contain at least one special character.")
        }
        
        isPasswordValid = errors.isEmpty
        
        errorMessage = errors.first ?? ""
        print(errors)
        
        doPasswordsMatch = registrationData.password2.isEmpty || registrationData.password == registrationData.password2
        
        
    }
    
    func validateUsername() {
        /// TIMER
        usernameDebounceTimer?.invalidate()
        
        usernameDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            let username = self.registrationData.username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            
            guard !username.isEmpty else {
                self.isUsernameTaken = false
                return
            }
            
            /// API CALL
            AF.request(self.checkUsernameURL, method: .post, parameters: ["username": username])
                .validate()
                .responseDecodable(of: UsernameTakenModel.self) { response in
                    DispatchQueue.main.async {
                        switch response.result {
                            
                        case .success(let result):
                            self.isUsernameTaken = result.username_taken
                            print("chiamata af fatta, username taken:", result)
                        case .failure:
                            
                            self.isUsernameTaken = false
                        }
                    }
                }
            
        }
    }
    
    func validateStep1() -> Bool {
        triedStep1 = true
        validateAge()
        
        let isFirstNameValid = !registrationData.first_name.trimmingCharacters(in: .whitespaces).isEmpty
        let isLastNameValid = !registrationData.last_name.trimmingCharacters(in: .whitespaces).isEmpty
        
        return isFirstNameValid && isLastNameValid && isBirthdayValid
    }
    
    func validateStep2() -> Bool {
        triedStep2 = true
        validateEmail()
        validateImmediatelyPassword()
        
        return isEmailValid && isPasswordValid && doPasswordsMatch && !isEmailTaken
    }
    
    func validateStep3() -> Bool {
        triedStep3 = true
        registerUser()
        
        return !isUsernameTaken && !registrationData.username.isEmpty
    }
    

    func registerUser() {
        // per la data di nascita
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)



        print(registrationData)
        AF.request(registerUserURL, method: .post, parameters: self.registrationData, encoder: JSONParameterEncoder(encoder: encoder))
            .validate(statusCode: 200..<300)
            .responseDecodable(of: RegistrationResponse.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let message):
                        self.triedApiCall = true
                        self.registrationSuccess = true
                        print("Utente registrato: ", message)
                        print("nel VIEW MODEL", self.registrationSuccess)

                    case .failure(let error):
                        self.triedApiCall = true
                        self.errorMessage = error.localizedDescription
                        print(error)

                    }



                }
            }

    }
    
//    func registerUser() {
//        triedApiCall = true
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dobString = dateFormatter.string(from: registrationData.date_of_birth)
//
//        AF.upload(
//            multipartFormData: { multipartFormData in
//                multipartFormData.append(Data(self.registrationData.first_name.utf8), withName: "first_name")
//                multipartFormData.append(Data(self.registrationData.last_name.utf8), withName: "last_name")
//                multipartFormData.append(Data(dobString.utf8), withName: "date_of_birth")
//                multipartFormData.append(Data(self.registrationData.email.utf8), withName: "email")
//                multipartFormData.append(Data(self.registrationData.password.utf8), withName: "password")
//                multipartFormData.append(Data(self.registrationData.password2.utf8), withName: "password2")
//                multipartFormData.append(Data(self.registrationData.username.utf8), withName: "username")
//                
//                // ✅ Aggiungi l'immagine come File se presente
//                if let imageData = self.selectedImageData {
//                    multipartFormData.append(imageData, withName: "profile_image", fileName: "profile.jpg", mimeType: "image/jpeg")
//                }
//            },
//            to: registerUserURL
//        )
//        .validate(statusCode: 200..<300)
//        .responseDecodable(of: RegistrationResponse.self) { response in
//            DispatchQueue.main.async {
//                switch response.result {
//                case .success(let message):
//                    self.registrationSuccess = true
//                    print("Utente registrato: \(message)")
//                case .failure(let error):
//                    print(self.selectedImageData)
//                    
//                    print(self.registrationData)
//                    self.registrationSuccess = false
//                    self.errorMessage = error.localizedDescription
//                    print("Errore: \(error)")
//                }
//            }
//        }
//    }

    
    
    
    
    
    
}
