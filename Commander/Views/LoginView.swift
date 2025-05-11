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
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: darkColor)
                    .ignoresSafeArea()

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

                    InputView(
                        inputText: $email,
                        inputName: "Email",
                        placeholder: "Your email")
                        .autocorrectionDisabled()

                    InputView(
                        inputText: $password,
                        inputName: "Password",
                        placeholder: "Your password",
                        isSecureField: true)
                        .autocorrectionDisabled()
                  

                    Button(action: {
                        // Forgot password action
                    }) {
                        Text("Forgot your password?")
                            .customFont(.semibold, size: 14, hexColor: accentCustomColor)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.bottom, 36)

                    Button(action: {}) {
                        Text("")}
                        .customButton(
                            typeBtn: .primary,
                            textBtn: "Log In",
                            icon: "",
                            width: 350,
                            height: 50,
                            fontSizeBtn: 18,
                            cornerRadius: 10
                                        )

                    LabelledDivider(label: "or")

                    Button(action: {}) {
                        Text("")}
                        .customButton(
                            typeBtn: .secondary,
                            textBtn: "Continue with Google",
                            icon: "globe",
                            width: 350,
                            height: 50,
                            fontSizeBtn: 18,
                            cornerRadius: 10
                        )

                    Spacer()
                    Spacer()

                    HStack {
                        Text("Need an account?")
                            .customFont(.medium, size: 14, hexColor: "FFFFFF")
                        Button(action: {
                            // Navigate to Sign Up
                        }) {
                            Text("Sign Up")
                                .customFont(.semibold, size: 14, hexColor: accentCustomColor)
                        }
                    }
                }
                .padding(24)
            }
        }
    }
}

#Preview {
    LogInView()
}
