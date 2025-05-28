import SwiftUI

struct OTPVerificationView: View {
    
    @State private var otp: String = ""
    @FocusState private var isOTPFieldFocused: Bool
    private let numberOfFieldsInOTP = 6
    
    @EnvironmentObject var authViewModel: AuthtenticationViewModel
    @FocusState private var focusedField: Int?
    @State private var codeDigits: [String] = Array(repeating: "", count: 6)
    @State private var errorMessage: String?
    
    var body: some View {
        ZStack {
            Color(hex: darkColor).ignoresSafeArea()

            VStack(spacing: 34) {
                Spacer()
                
                Text("Commander")
                    .customFont(.bold, size: 30, hexColor: accentCustomColor)

                Text("Verify Code")
                    .customFont(.bold, size: 34, hexColor: white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Enter the 6-digit code sent to your email.")
                    .customFont(.medium, size: 15, hexColor: "FFFFFF")
                    .opacity(0.7)
                    .frame(maxWidth: .infinity, alignment: .leading)

                
                OTPFieldView(numberOfFields: numberOfFieldsInOTP, otp: $otp)

                if let error = errorMessage {
                    Text(error)
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer()

                Button {
                    guard otp.count == 6 else {
                        errorMessage = "The code must be 6 digits."
                        return
                    }
                    errorMessage = nil
                    authViewModel.otpModel.otp = otp
                    authViewModel.verifyOTP()
                } label: {
                    Text("Verify")
                        .customFont(.bold, size: 18, hexColor: darkColor)
                        .modifier(ButtonView(typeBtn: .primary, width: 350, height: 50, cornerRadius: 8))
                }

                Button {
                    authViewModel.requestOTP()
                    focusedField = 0
                    codeDigits = Array(repeating: "", count: 6)
                    errorMessage = nil
                } label: {
                    Text("Resend code")
                        .customFont(.semibold, size: 14, hexColor: accentCustomColor)
                        .customButton(typeBtn: .tertiary, width: 350, height: 50, cornerRadius: 8)
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .onAppear {
                focusedField = 0
            }
        }
    }
}
