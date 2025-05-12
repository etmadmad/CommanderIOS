import SwiftUI

struct FirstRegistrationView: View {
  
    @State var nameUser: String = ""
    @State var lastNameUser: String = ""
    
    @State private var date = Date()
    
    @State private var state1 = false
    @State var isFocused = false

    
    var body: some View {
        ZStack {
            Color(hex: darkColor)
                .ignoresSafeArea()
                .onTapGesture {
                    isFocused = false
                                }
            
            VStack{
                Spacer()
// vogliamo fare che magari ti registri solo con profilo nome?
                Text("Commander")
                    .customFont(.bold, size: 30, hexColor: accentCustomColor)
                Spacer()
                Text("Sign Up")
                    .customFont(.bold, size: 38, hexColor: "FFFFFF")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // email, password, username, nome e cognome, data di nascita e foto (si può anche non caricare)
                InputView(inputText: $nameUser,
                          inputName: "Name",
                          placeholder: "Name")
                
                InputView(inputText: $lastNameUser,
                          inputName: "Last Name",
                          placeholder: "Last Name")
                
                HStack (){
                    Text("Birthday")
                        .foregroundStyle(Color.white)
                    Spacer()
                    DatePicker(
                        "Start Date",
                        selection: $date,
                        displayedComponents: [.date])
                    .labelsHidden()
                    .colorMultiply(.white)// imposta il colore del testo in bianco
                    .tint(Color(hex: accentCustomColor))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                    
                Spacer()
                NavigationLink(destination: SecondRegistrationView()){
                    Button(""){}
                        .customButton(
                            typeBtn: .primary,
                            textBtn: "Next",
                            icon: "arrow.forward",
                            width: 170,
                            height: 50,
                            fontSizeBtn: 18,
                            cornerRadius: 10
                        )}
                
                Spacer()
                

            }
            .padding(.horizontal, 30)
        }
        
    }
}


struct SecondRegistrationView: View {
    @State var username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    var body: some View {
        ZStack {
            Color(hex: darkColor)
                .ignoresSafeArea()
            VStack{
                Spacer()

                Text("Commander")
                    .customFont(.bold, size: 30, hexColor: accentCustomColor)
                Spacer()
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
                Spacer()

                NavigationLink(destination: SecondRegistrationView()){
                    Button(""){}
                        .customButton(
                            typeBtn: .primary,
                            textBtn: "Next",
                            icon: "arrow.forward",
                            width: 170,
                            height: 50,
                            fontSizeBtn: 18,
                            cornerRadius: 10
                        )}
                
                Spacer()
                 
            }
            .padding(.horizontal, 30)
  
        }
    }
}

struct ThirdRegistrationView: View {
    @State private var username: String = ""
    var body: some View {
        ZStack {
            Color(hex: darkColor)
                .ignoresSafeArea()
            VStack {
                Spacer()

                Text("Commander")
                    .customFont(.bold, size: 30, hexColor: accentCustomColor)
                
                Text("Sign Up")
                    .customFont(.bold, size: 38, hexColor: "FFFFFF")
                    .frame(maxWidth: .infinity, alignment: .leading)
                


                InputView(inputText: $username, inputName: "Username", placeholder: "Username")
                Spacer()
                
            }
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    FirstRegistrationView()
}


#Preview {
    SecondRegistrationView()
}

#Preview {
    ThirdRegistrationView()
}
