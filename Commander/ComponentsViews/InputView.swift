import SwiftUI

struct InputView: View {
    @Binding var inputText: String
    let inputName: String
    let placeholder: String
    var isSecureField = false
    
    @State private var isPasswordVisible = false

    var body: some View {
        VStack(spacing: 8) {
            Text(inputName)
                .customFont(.regular, size: 15, hexColor: "#FFFFFF")
                .frame(maxWidth: .infinity, alignment: .leading)

            ZStack(alignment: .trailing) {
                Group {
                    if isSecureField && !isPasswordVisible {
                        SecureField(placeholder, text: $inputText)
                    } else {
                        TextField(placeholder, text: $inputText)
                    }
                }
                .padding(.trailing, 40)
                .padding()
                .foregroundStyle(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.1))
                        .stroke(Color(hex: "EDF1F3").opacity(0.05), lineWidth: 2)
                        .frame(height: 46)
                )
                .autocorrectionDisabled(true)

                if isSecureField {
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.trailing, 12)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color(hex: darkColor)
            .ignoresSafeArea()
        VStack(spacing: 20) {
            InputView(inputText: .constant("password123"), inputName: "Password", placeholder: "Enter password", isSecureField: true)
            InputView(inputText: .constant(""), inputName: "Username", placeholder: "Username")
        }
        .padding()
    }
}
