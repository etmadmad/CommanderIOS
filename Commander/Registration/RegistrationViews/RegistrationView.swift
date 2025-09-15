import SwiftUI

enum RegistrationStep: Hashable {
    case second
    case third
    case successfulRegistration
    case unsuccessfulRegistration
}

struct RegistrationRoot: View {
    @StateObject private var registrationVM = RegisterViewModel()
    @State private var path: [RegistrationStep] = []
    @Binding var isSheetPresented: Bool

    var body: some View {
        NavigationStack(path: $path) {
            FirstRegistrationView1(path: $path)
                .environmentObject(registrationVM)
                .navigationDestination(for: RegistrationStep.self) { step in
                    switch step {
                    
                    case .second:
                        SecondRegistrationView1(path: $path)
                            .environmentObject(registrationVM)
                    case .third:
                        ThirdRegistrationView1(path: $path)
                            .environmentObject(registrationVM)
                    case .successfulRegistration:
                        RegistrationSuccessView(isSheetPresented: $isSheetPresented)
                            .environmentObject(registrationVM)
                    case .unsuccessfulRegistration:
                        InvalidEmailDomainView(isSheetPresented: $isSheetPresented)
                            .environmentObject(registrationVM)
                        
                    }
                }
        }
    }
}



struct FirstRegistrationView1: View {
    @EnvironmentObject var registrationVM: RegisterViewModel
    @Binding var path: [RegistrationStep]

    @State var nameUser: String = ""
    @State var lastNameUser: String = ""
    @State private var date = Date()
    
    @State private var isNavigationActive = false
    @State private var state1 = false
    @State var isFocused = false
    @State private var isDatePickerActive = false

    var body: some View {
  
        ZStack {
            Color(hex: darkColor)
                .ignoresSafeArea(.all, edges: .all)
                .onTapGesture {
                    isFocused = false
                }
            
            VStack {
                Spacer()
                Text("Commander")
                    .customFont(.bold, size: 30, hexColor: accentCustomColor)
                Spacer()
                Text("Sign Up")
                    .customFont(.bold, size: 38, hexColor: "FFFFFF")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                /// NAME
                InputView(inputText: $registrationVM.registrationData.first_name,
                          inputName: "Name",
                          placeholder: "Name",
                          showError: registrationVM.triedStep1 && registrationVM.registrationData.first_name.isEmpty)
                
                /// NAME IS REQUIRED
                errorText(registrationVM.triedStep1 && registrationVM.registrationData.first_name.isEmpty, message: "Name is required")
                
                
                /// LAST NAME
                InputView(inputText: $registrationVM.registrationData.last_name,
                          inputName: "Last Name",
                          placeholder: "Last Name",
                          showError: registrationVM.triedStep1 && registrationVM.registrationData.last_name.isEmpty)
                
                errorText(registrationVM.triedStep1 && registrationVM.registrationData.last_name.isEmpty, message: "Last Name is required")
                
                
                /// BIRTHDAY
                HStack {
                    Text("Birthday")
                        .foregroundStyle(Color.white)
                    Spacer()
                    
                    
                    DatePicker(
                        "",
                        selection: $registrationVM.registrationData.date_of_birth,
                        displayedComponents: [.date]
                    )
                    
                    .environment(\.colorScheme, .light)
                    .labelsHidden()
                    .colorMultiply(.white)
                    .tint(Color(hex: accentCustomColor)) //inside calendar
                    .cornerRadius(10)
                    .padding()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                
                errorText(registrationVM.triedStep1 && !registrationVM.isBirthdayValid, message: "You need to be at least 14 years old")
                
                Spacer()
                
                Button(action: {
                    if registrationVM.validateStep1() {
                        
                        path.append(.second)
                      
                    }
                }) {
                    Text("Next").customButton(typeBtn: .primary, width: 120, height: 50, cornerRadius: 15)
                }
                
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                
                Spacer()
                    }
                .padding(.horizontal, 30)
        }
               
    }
}


struct SecondRegistrationView1: View {
    @EnvironmentObject var registrationVM: RegisterViewModel
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @Binding var path: [RegistrationStep]
    @State private var isNextTapped: Bool = false
    
    
    var body: some View {
    
            ZStack {
                Color(hex: darkColor)
                    .ignoresSafeArea()
            
                VStack {
                    Spacer()
                    Text("Commander")
                        .customFont(.bold, size: 30, hexColor: accentCustomColor)
                    Spacer()
                    Text("Sign Up")
                        .customFont(.bold, size: 38, hexColor: "FFFFFF")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                   
                    VStack (spacing: 16){
                        /// EMAIL
                        InputView(inputText: $registrationVM.registrationData.email,
                                  inputName: "Email",
                                  placeholder: "Email",
                                  showError: (!registrationVM.isEmailValid && !registrationVM.registrationData.email.isEmpty) ||
                                              registrationVM.isEmailTaken ||
                                              (registrationVM.triedStep2 && registrationVM.registrationData.email.isEmpty))
                        
                        .onChange(of: registrationVM.registrationData.email) {
                            registrationVM.validateEmail()
                        }
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        
                        /// EMAIL REQUIRED
                        errorText(registrationVM.triedStep2 && registrationVM.registrationData.email.isEmpty,
                                  message: "Email is required")
                        
                        /// EMAIL NOT VALID
                        errorText(!registrationVM.registrationData.email.isEmpty && !registrationVM.isEmailValid,
                                  message: "Email not valid")
                        
                        /// EMAIL ALREADY TAKEN
                        errorText(!registrationVM.registrationData.email.isEmpty && registrationVM.isEmailTaken,
                                  message: "Email already taken")
          
                        /// PASSWORD
                        InputView(inputText: $registrationVM.registrationData.password,
                                  inputName: "Password",
                                  placeholder: "Enter your password",
                                  isSecureField: true,
                                  showError: registrationVM.triedStep2 && registrationVM.registrationData.password.isEmpty || registrationVM.triedStep2 && !registrationVM.isPasswordValid)
                        .onChange(of: registrationVM.registrationData.password) {
                            registrationVM.validateImmediatelyPassword()
                        }
                        
                        /// PASSWORD REQUIRED
                        errorText(registrationVM.triedStep2 && registrationVM.registrationData.password.isEmpty, message: "Password is required")
                        
                        /// PASSWORD NOT VALID
                        errorText(!registrationVM.registrationData.password.isEmpty && !registrationVM.isPasswordValid, message: registrationVM.errorMessage)
                        
                        /// CONFIRM PASSWORD
                        InputView(inputText: $registrationVM.registrationData.password2,
                                  inputName: "Confirm Password",
                                  placeholder: "Re-enter your password",
                                  isSecureField: true,
                                  showError: registrationVM.triedStep2 && registrationVM.registrationData.password2.isEmpty || registrationVM.triedStep2 && !registrationVM.doPasswordsMatch)
                       
                        /// EMPTY CONFIRM PASSWORD
                        errorText(registrationVM.triedStep2 && registrationVM.registrationData.password2.isEmpty, message: "Confirm Password is required")
                        
                        
                        /// PASSWORDS DO NOT MATCH
                        errorText(registrationVM.triedStep2 && !registrationVM.doPasswordsMatch, message: "Passwords do not match")
                    }
                    
                  
                    
                    Spacer()
                    HStack{
                        Button(action: {
                            path.removeLast()
                        }) {
                            Text("Back")}
                        .customButton(typeBtn: .tertiary, width: 120, height: 50, cornerRadius: 15)
                        
                        Button(action: {
                            if  registrationVM.validateStep2() {
                                path.append(.third)
                            
                            }
                                
                            
                        }) {
                            Text("Next")
                                .customButton(typeBtn: .primary, width: 120, height: 50, cornerRadius: 15)
                        }
                       
                        .frame(maxWidth: .infinity, alignment: .trailing)
                                      
                        
                    }

                    Spacer()
                }
                .padding(.horizontal, 30)
            }
        
            .navigationBarBackButtonHidden(true)
    
                    
    }
}
  

struct ThirdRegistrationView1: View {
    @EnvironmentObject var registrationVM: RegisterViewModel
    @Binding var path: [RegistrationStep]
    @State private var selectedImageData: Data? = nil

    
  
    var body: some View {
            ZStack {
                Color(hex: darkColor)
                    .ignoresSafeArea()
            
                VStack {
                    Spacer()
                    
                    Text("Commander")
                        .customFont(.bold, size: 30, hexColor: accentCustomColor)
                    
                    Spacer()
                    Text("Sign Up")
                        .customFont(.bold, size: 38, hexColor: "FFFFFF")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                  
//                    ImagePickerView(selectedImageData: $registrationVM.selectedImageData,
//                        onImageSelected: { image in
//                        registrationVM.uploadImage(image)
//                                        })
                    
                    
//                    .onChange(of: registrationVM.registrationSuccess) {
//                        if registrationVM.registrationSuccess {
//                            if let data = registrationVM.selectedImageData,
//                               let image = UIImage(data: data) {
//                                registrationVM.uploadImage(image)
//                            }
//                            path.append(.successfulRegistration)
//                        }
//                    }
                    
                    
                    
//                        .onChange(of: registrationVM.registrationSuccess) {
//                            if registrationVM.registrationSuccess {
//                                print("Registrazione riuscita. Tenterò di caricare immagine.")
//                                
//                                if let data = registrationVM.selectedImageData {
//                                    print("Image data presente, grandezza: \(data.count) byte")
//                                    if let image = UIImage(data: data) {
//                                        registrationVM.uploadImage(image)
//                                    } else {
//                                        print("Non sono riuscito a creare UIImage da data")
//                                    }
//                                } else {
//                                    print("selectedImageData è nil — niente immagine da caricare")
//                                }
//                                
//                                path.append(.successfulRegistration)
//                            }
//                        }

                    InputView(inputText: $registrationVM.registrationData.username,
                              inputName: "Username",
                              placeholder: "Username",
                              showError: registrationVM.isUsernameTaken && !registrationVM.registrationData.username.isEmpty || registrationVM.triedStep3 && registrationVM.registrationData.username.isEmpty)
                    .autocapitalization(.none)
                    .textInputAutocapitalization(.never)
                    .onChange(of: registrationVM.registrationData.username){
                        registrationVM.validateUsername()

                    }
                    
                    
                    errorText(registrationVM.isUsernameTaken && !registrationVM.registrationData.username.isEmpty, message: "Username is already taken")
                    
                    
                    if !registrationVM.isUsernameTaken && !registrationVM.registrationData.username.isEmpty {
                        Text("Username available")
                            .font(.system(size: 14))
                            .foregroundStyle(Color(hex: accentCustomColor))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack{
                        /// BACK - 3
                        Button(action: {
                            path.removeLast()
                        }){
                            Text("Back")
                        }
                        .customButton(typeBtn: .tertiary, width: 120, height: 50, cornerRadius: 15)
                        
                        /// SIGN IN - 3
                        Button(action: {
                            if  registrationVM.validateStep3()  {
                                print(registrationVM.registrationData.password, registrationVM.registrationData.password2)
                                print("risultato registrazione nel view", registrationVM.registrationSuccess)
                            }}) {
                                Text("Sign Up")
                            }
                            .customButton(typeBtn: .primary, width: 120, height: 50, cornerRadius: 15)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            /// when registration successful --> append successful reg view
                            .onChange(of: registrationVM.registrationSuccess) {
                                if registrationVM.registrationSuccess {
                                    path.append(.successfulRegistration)
                                }
                            }
                            /// when registration NOT successful & tried call api --> append UNsuccessful reg view
                            .onChange(of: registrationVM.triedApiCall) {
                                if registrationVM.triedApiCall && !registrationVM.registrationSuccess {
                                    path.append(.unsuccessfulRegistration)
                                }
                            }
                    }
                    Spacer()
                    }
                    .padding(.horizontal, 30)
                }
            .navigationBarBackButtonHidden(true)
                
            }

            
        }
    


func errorText(_ condition: Bool, message: String) -> some View {
    Group {
        if condition {
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

/// PREVIEW FIRST VIEW
struct FirstRegistrationView1_Preview: View {
    @State var path: [RegistrationStep] = []
    var body: some View {
        FirstRegistrationView1(path: $path)
            .environmentObject(RegisterViewModel())
    }
}
#Preview {
    FirstRegistrationView1_Preview()
}

/// PREVIEW SECOND VIEW
struct SecondRegistrationView1_Preview: View {
    @State var path: [RegistrationStep] = []
    
    var body: some View {
        SecondRegistrationView1(path: $path)
            .environmentObject(RegisterViewModel())
    }
}
#Preview {
    SecondRegistrationView1_Preview()
}


/// PREVIEW THIRD VIEW
struct ThirdRegistrationView1_Preview: View {
    @State var path: [RegistrationStep] = []
    
    var body: some View {
        ThirdRegistrationView1(path: $path)
            .environmentObject(RegisterViewModel())
    }
}
#Preview {
    ThirdRegistrationView1_Preview()
}
