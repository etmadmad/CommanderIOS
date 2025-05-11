import SwiftUI

struct RegistrationView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    var body: some View {
        ZStack {
            Color(hex: darkColor)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
// vogliamo fare che magari ti registri solo con profilo nome?
                Text("Commander")
                    .customFont(.bold, size: 30, hexColor: accentCustomColor)
                Text("Sign Up")
                    .customFont(.bold, size: 38, hexColor: "FFFFFF")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                InputView(inputText: $email,
                          inputName: "Email",
                          placeholder: "Email")
                
                InputView(inputText: $password,
                          inputName: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                
                InputView(inputText: $confirmPassword,
                          inputName: "Confirm Password",
                          placeholder: "Renter your password",
                          isSecureField: true)
                if password == confirmPassword {
           //         print("password uguali \(password)")
                }
                
                Button(""){}
                    .customButton(
                        typeBtn: .primary,
                        textBtn: "Sign In",
                        icon: "",
                        width: 170,
                        height: 50,
                        fontSizeBtn: 18,
                        cornerRadius: 10
                    )
                
                Spacer()
                

            }
            .padding(.horizontal, 30)
        }
        
    }
}

#Preview {
    RegistrationView()
}
