

import SwiftUI

struct ChangePasswordView: View {
    @StateObject var profileVM = ProfileViewModel(authVM: AuthtenticationViewModel())
    @State var triedSubmit = false
    @State var isPasswordChanged = false

    var body: some View {
        ZStack {
            Color(hex: darkColor)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Commander")
                    .customFont(.bold, size: 30, hexColor: accentCustomColor)
                Spacer()
                Text("Change Password")
                    .customFont(.bold, size: 38, hexColor: "FFFFFF")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 16) {
                    /// OLD PASSWORD
                    InputView(
                        inputText: $profileVM.changePasswordData.old_password,
                        inputName: "Current Password",
                        placeholder: "Enter your current password",
                        isSecureField: true,
                        showError: triedSubmit && profileVM.changePasswordData.old_password.isEmpty
                    )
                    errorText(triedSubmit && profileVM.changePasswordData.old_password.isEmpty, message: "Current password is required")
                    
                    errorText(triedSubmit && !profileVM.isOldPasswordCorrect, message: "Old password is not correct")
                    
                    
                    /// NEW PASSWORD
                    InputView(
                        inputText: $profileVM.changePasswordData.new_password,
                        inputName: "New Password",
                        placeholder: "Enter your new password",
                        isSecureField: true
                    )
                    errorText(triedSubmit && profileVM.changePasswordData.new_password.isEmpty, message: "New password is required")
                    errorText(!profileVM.changePasswordData.new_password.isEmpty && !profileVM.isNewPasswordValid, message: profileVM.errorMessage ?? "")
                    errorText(profileVM.changePasswordData.old_password == profileVM.changePasswordData.new_password, message: "New password must be different from old password")
                    .onChange(of: profileVM.changePasswordData.new_password) {
                        profileVM.validateChangePassword()
                    }
                    
                    /// CONFIRM PASSWORD
                    InputView(
                        inputText: $profileVM.changePasswordData.new_password2,
                        inputName: "Confirm New Password",
                        placeholder: "Re-enter your new password",
                        isSecureField: true
                    )
                    /// CONFIRM PASSWORD EMPTY
                    errorText(triedSubmit && profileVM.changePasswordData.new_password2.isEmpty, message: "Please confirm your new password")
                   
                    .onChange(of: profileVM.changePasswordData.new_password2) {
                        profileVM.validateChangePassword()
                    }
                    /// PASSWORDS DO NOT MATCH
                    errorText(triedSubmit && !profileVM.doNewPasswordMatch, message: "Passwords do not match")
                }
                
                Spacer()
                Button(action: {
                    triedSubmit = true
                    profileVM.validateChangePassword()
                    if profileVM.isNewPasswordValid && profileVM.doNewPasswordMatch && !profileVM.changePasswordData.old_password.isEmpty {
                        
                        profileVM.changePassword()
                        isPasswordChanged = true
                    }
                }) {
                    Text("Change Password")
                        .customButton(typeBtn: .primary, width: 200, height: 50, cornerRadius: 15)
                }
                Spacer()
            }
            .padding(.horizontal, 30)
        }
//        .navigationBarBackButtonHidden(true)
        // (opzionale) alert di successo
      
    }
}

struct PasswordChangedSuccessView: View {
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color(hex: darkColor)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                
                Text("Password Changed")
                    .customFont(.bold, size: 32, hexColor: "FFFFFF")
                
                Text("Your password has been updated successfully.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(.horizontal, 30)
                
                Button(action: onDismiss) {
                    Text("OK")
                        .customButton(typeBtn: .primary, width: 200, height: 50, cornerRadius: 15)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}
