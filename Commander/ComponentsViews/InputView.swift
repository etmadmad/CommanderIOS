import SwiftUI

struct InputView: View {
    @Binding var inputText: String
    let inputName: String
    let placeholder: String
    var isSecureField = false
    var opacityGlowBorderInput = 0
    
    @State private var isPasswordVisible = false
    
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 8) {
            Text(inputName)
                .customFont(.regular, size: 15, hexColor: "#FFFFFF")
                .frame(maxWidth: .infinity, alignment: .leading)

            ZStack(alignment: .trailing) {
                Group {
                    if isSecureField && !isPasswordVisible {
                        SecureField(placeholder, text: $inputText)
                            .focused($isFocused)
                    } else {
                        TextField(placeholder, text: $inputText)
                        
                    }
                }
                .padding(.trailing, 40)
                .padding()
                .foregroundStyle(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isFocused ? Color(hex: "#00FF33") : Color.gray, lineWidth: 1)
                        .shadow(color: isFocused ? Color(hex: "#00FF33").opacity(0.6) : .clear, radius: 5)
                        .shadow(color: isFocused ? Color(hex: "#00FF33").opacity(0.4) : .clear, radius: 10)
                        .frame(height: 46)
                        .animation(.easeInOut(duration: 0.3), value: isFocused)
                )
                .autocorrectionDisabled(true)
                .focused($isFocused)
                .onTapGesture {isFocused = true}
                
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
