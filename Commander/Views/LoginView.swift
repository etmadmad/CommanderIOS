import SwiftUI

struct LabelledDivider: View {
    
    let label: String
    let horizontalPadding: CGFloat
    let color: Color
    
    init(label: String, horizontalPadding: CGFloat = 20, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }
    
    var body: some View {
        HStack {
            line
            Text(label).foregroundColor(color)
            line
        }
    }
    
    var line: some View {
        VStack { Divider().background(color) }.padding(horizontalPadding)
    }
}


struct LogInView: View {
    @EnvironmentObject var authViewModel: AuthtenticationViewModel
    
    @State private var shakeTrigger = false
    @State private var shakeAnimation = 0.0
    
    @State var isSheetPresented: Bool = false

    var body: some View {

            ZStack {
                Color(hex: darkColor)
                    .ignoresSafeArea(.all, edges: .all)
                    

                VStack {
                    Text("Commander")
                        .customFont(.bold, size: 33, hexColor: accentCustomColor)
                    
                    Spacer()
                    
                    Text("Log In")
                        .customFont(.bold, size: 38, hexColor: "FFFFFF")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Write your email and password to log in")
                        .customFont(.medium, size: 13, hexColor: "FFFFFF")
                        .opacity(0.65)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 20)
                    
                    // EMAIL INPUT, binding perchè non viene gestito qua
                    InputView(
                        inputText: $authViewModel.credentials.email,
                        inputName: "Email",
                        placeholder: "Your email",
                        showError: authViewModel.triedToLogin && authViewModel.credentials.email.isEmpty
                    )
                    .autocorrectionDisabled()
                   
                    
                    if authViewModel.triedToLogin {
                        if authViewModel.credentials.email.isEmpty {
                            Text("Email Required")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                       
                        
                    }
                    
                    // PASSWORD INPUT
                    InputView(
                        inputText: $authViewModel.credentials.password,
                        inputName: "Password",
                        placeholder: "Your password",
                        isSecureField: true,
                        showError: authViewModel.triedToLogin && authViewModel.credentials.password.isEmpty
                    )
                    .autocorrectionDisabled()
                   
                    
                    if authViewModel.triedToLogin {
                        if authViewModel.credentials.password.isEmpty {
                            Text("Password Required")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        
                        }
                    }
                    
                    
                    
                    // Forgot password
                    Button(action: {
                       
                    }) {
                        Text("Forgot your password?")
                            .customFont(.semibold, size: 14, hexColor: accentCustomColor)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.bottom, 36)
                    
                    // LOGIN BUTTON (modifier)
                    Button {
                        authViewModel.checkInput()
                    } label: {
                        Text("Login")
                            .customFont(.bold, size: 18, hexColor: darkColor)
                    }
                    .modifier(ButtonView(typeBtn: .primary, width: 350, height: 50, cornerRadius: 8))
                    
                    LabelledDivider(label: "or")
                  
                    
                    // GOOGLE LOGIN BUTTON (estensione modifier)
                    Button {
                        print("fanculo")
                        authViewModel.login()
                    } label: {
                        Text("Login with Google")
                            .customFont(.regular, size: 18, hexColor: accentCustomColor)
                    }
                    .customButton(typeBtn: .tertiary, width: 350, height: 40, cornerRadius: 8)
                    
                    
                    Spacer()
                    Spacer()
                   
                    HStack {
                        Text("Need an account?")
                            .customFont(.medium, size: 14, hexColor: "FFFFFF")
                        Text("Sign Up")
                                .customFont(.semibold, size: 14, hexColor: accentCustomColor)
                        }
                    .onTapGesture {
                        print("sheet presented")
                        isSheetPresented.toggle()
                      
                    }
                    
                    .sheet(isPresented: $isSheetPresented) {
                        FirstRegistrationView1()
                            .background(Color(hex: darkColor).ignoresSafeArea()) // ← Forzato qui
                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.visible)
                    }


             

                    
                    
                    
                    
                    
                    }
                
                .padding(.horizontal, 24)
                }

            
            }

        }
    


#Preview {
    LogInView()
        .environmentObject(AuthtenticationViewModel())
}
