import SwiftUI

struct InputView: View {
    @Binding var inputText: String
    let inputName: String
    let placeholder: String
    var isSecureField = false
    var opacityGlowBorderInput = 0
    
    var showError: Bool = false
    
    @State private var isPasswordVisible = false
    
    @FocusState private var isFocused: Bool


    var body: some View {
        VStack(spacing: 8) {
            Text(inputName)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Color.white)
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
                .foregroundStyle(isFocused ? Color(hex: accentCustomColor) : Color(hex: white))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(showError && !isFocused ? Color(hex: redError) : (isFocused ? Color(hex: accentCustomColor) :  Color(hex: grayDetails)), lineWidth: 1)

                        .shadow(color: isFocused ? Color(hex: accentCustomColor).opacity(0.6) : .clear, radius: 5)
                        .shadow(color: isFocused ? Color(hex: accentCustomColor).opacity(0.4) : .clear, radius: 10)
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
            InputView(inputText: .constant("ciao"), inputName: "Username", placeholder: "Username")
        }
        .padding()
    }
}
