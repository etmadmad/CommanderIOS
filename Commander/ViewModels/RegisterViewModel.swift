import Foundation

struct UserRegistrationModel: Codable {
    var email: String =  ""
    var username: String = ""
    var password: String = ""
    var first_name: String = ""
    var last_name: String = ""
    var confirm_password: String = ""
    var date_of_birth: Date = Date()
    
    var date_of_birth_string: String = ""
}

class RegisterViewModel: ObservableObject {
    @Published var registrationData = UserRegistrationModel()
    
    @Published var isBirthdayValid: Bool = false
    @Published var triedToLogin: Bool = false
    
    @Published var isPasswordValid: Bool = false
    
    var isEmailValid: Bool = false
    var errorMessage = ""
    
    // prendo giorno corrente // calcola gli anni in base a inpit che riceve da date picker
    func validateAge(minimumAge: Int = 14) {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: registrationData.date_of_birth, to: Date())
        let age = ageComponents.year ?? 0
        isBirthdayValid = age >= minimumAge
    }
    
    func validateEmail() {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: registrationData.email)
    }
    
    func validatePassword () {
       // let passwordRegex = "/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$/"
        //if registrationData.password.
    }
    
    func checkInput() {
        //triedToLogin = true
        if registrationData.username.isEmpty || registrationData.password.isEmpty || registrationData.email.isEmpty {
            return
        }
        validateEmail()
        if !isEmailValid {
           errorMessage = "Invalid email address"
           return
        }
        if !registrationData.password.isEmpty {
            validatePassword()
        }
        
    }
}
