
import SwiftUI

//struct ProfileInfoView: View {
//    @StateObject var profileVM = ProfileViewModel(authVM: AuthtenticationViewModel())
//    @EnvironmentObject var authVM: AuthtenticationViewModel
//    @StateObject var registrationVM: RegisterViewModel
//    @State private var isLoggingOut = false
//    @State private var isEditingUsername = false
//    @State private var editedUsername = ""
//    @State private var showDropdown = false
//    
//    @State private var hasLoadedUserInfo = false
//    
//    var body: some View {
//        ZStack{
//            Color(hex: darkColor)
//                .ignoresSafeArea()
//            
//            VStack {
//                HStack {
//                    Text("Profile")
//                        .font(.system(size: 32, weight: .bold, design: .default))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    Menu {
//                        //MARK: - CHANGE PASS
//                        Button("Change Password") {
//                            
//                        }
//                        
//                        Divider()
//                        
//                        Button(role: .destructive) {
//                            //isLoggingOut = true
//                            authVM.deleteAccount()
//                            //authVM.isLoggedIn = false
//                        } label: {
//                            Text("Delete Account")
//                                .customFont(.bold, size: 18, hexColor: redError)
//                            
//                                .customButton(typeBtn: .tertiary, width: 350, height: 50, cornerRadius: 8)
//                        }
//                        
//                        
//                    } label: {
//                        Label("", systemImage: "gearshape.fill")
//                            .foregroundStyle(Color.white)
//                    }
//                    
//                }
//                
//                
//                
//                ZStack {
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color.gray.opacity(0.2))
//                        .frame(height: 180)
//                    
//                    HStack(spacing: 18){
//                        
//                        if let imageData = profileVM.selectedImageData,
//                           let uiImage = UIImage(data: imageData) {
//                            Image(uiImage: uiImage)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 200, height: 200)
//                                .clipShape(Circle())
//                        } else if let profileImagePath = profileVM.userInfo.profile_image {
//                            let fullURLString = Environment.imageBaseURL + profileImagePath
//                            if let fullURL = URL(string: fullURLString) {
//                                AsyncImage(url: fullURL) { phase in
//                                    switch phase {
//                                    case .empty:
//                                        ProgressView()
//                                    case .success(let image):
//                                        image
//                                            .resizable()
//                                            .scaledToFill()
//                                            .frame(width: 130, height: 130)
//                                            .clipShape(Circle())
//                                    case .failure:
//                                        Image(systemName: "person.crop.circle.badge.exclam")
//                                            .resizable()
//                                            .frame(width: 130, height: 130)
//                                            .foregroundColor(.gray)
//                                    @unknown default:
//                                        EmptyView()
//                                    }
//                                }
//                            }
//                        } else {
//                            Image(systemName: "person.crop.circle.fill")
//                                .resizable()
//                                .frame(width: 130, height: 130)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        VStack(alignment: .leading){
//                            Text(profileVM.userInfo.first_name + " " + profileVM.userInfo.last_name )
//                                .font(.system(size: 20, weight: .bold, design: .default))
//                            
//                            Text("@" + profileVM.userInfo.username)
//                                .foregroundStyle(Color(hex: lightGray))
//                            Button{
//                                
//                            }label:{
//                                Text("Edit Profile")
//                                    .foregroundColor(.black)
//                                    .padding()
//                                    .frame(width: 120, height: 40)
//                                    .background(Color.white)
//                                    .cornerRadius(20)
//                            }
//                        }
//                    }}
//                .frame(maxWidth: .infinity, alignment: .leading)
//                
//                
//                VStack(spacing: 16) {
//                    Text("Personal Info")
//                        .font(.system(size: 20, weight: .bold))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    InfoCard(title: "Email", value: profileVM.userInfo.email)
//                    
//                    InfoCard(title: "Data di nascita", value: profileVM.userInfo.date_of_birth)
//                }
//                
//                VStack() {
//                    Text("Activity")
//                        .font(.system(size: 20, weight: .bold))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//                
//                
//                Button {
//                    isLoggingOut = true
//                    authVM.logout()
//                    authVM.isLoggedIn = false
//                } label: {
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(Color.gray.opacity(0.2))
//                            .frame(height: 60)
//                        HStack{
//                            Image(systemName: "rectangle.portrait.and.arrow.right")
//                                .foregroundStyle(Color(hex: redError))
//                                .padding(.trailing, 20)
//                            
//                            Text("Logout")
//                                .customFont(.bold, size: 18, hexColor: white)
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.leading, 20)
//                    }
//                    
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                }
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(24)
//            
//            
//            
//            .onAppear {
//                if !hasLoadedUserInfo {
//                    profileVM.fetchUserInfo()
//                    hasLoadedUserInfo = true
//                }
//            }
//            .alert(isPresented: $isLoggingOut) {
//                Alert(title: Text("Logged Out"),
//                      message: Text("You have been logged out."),
//                      dismissButton: .default(Text("OK")))
//            }
//        }
//        
//    }
//}

struct ProfileInfoView: View {
    @StateObject var profileVM = ProfileViewModel(authVM: AuthtenticationViewModel())
    @EnvironmentObject var authVM: AuthtenticationViewModel
    @StateObject var registrationVM: RegisterViewModel
    @State private var isLoggingOut = false
    @State private var isEditingUsername = false
    @State private var editedUsername = ""
    @State private var showDropdown = false

    @State private var hasLoadedUserInfo = false
    @State private var path = NavigationPath()   // 👈 per la navigation

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(hex: darkColor)
                    .ignoresSafeArea()
                
                
                VStack {
                    
                    HStack {
                        Text("Profile")
                            .font(.system(size: 32, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Menu {
                            //MARK: - CHANGE PASS
                            Button("Change Password") {
                                path.append("changePassword")   // 👈 push sulla stack
                            }
                            
                            Divider()
                            
                            Button(role: .destructive) {
                                authVM.deleteAccount()
                            } label: {
                                Text("Delete Account")
                                    .customFont(.bold, size: 18, hexColor: redError)
                                    .customButton(typeBtn: .tertiary, width: 350, height: 50, cornerRadius: 8)
                            }
                        } label: {
                            Label("", systemImage: "gearshape.fill")
                                .foregroundStyle(Color.white)
                        }
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 180)

                        HStack(spacing: 18){

                            if let imageData = profileVM.selectedImageData,
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                            } else if let profileImagePath = profileVM.userInfo.profile_image {
                                let fullURLString = Environment.imageBaseURL + profileImagePath
                                if let fullURL = URL(string: fullURLString) {
                                    AsyncImage(url: fullURL) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 130, height: 130)
                                                .clipShape(Circle())
                                        case .failure:
                                            Image(systemName: "person.crop.circle.badge.exclam")
                                                .resizable()
                                                .frame(width: 130, height: 130)
                                                .foregroundColor(.gray)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                }
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 130, height: 130)
                                    .foregroundColor(.gray)
                            }

                            VStack(alignment: .leading){
                                Text(profileVM.userInfo.first_name + " " + profileVM.userInfo.last_name )
                                    .font(.system(size: 20, weight: .bold, design: .default))

                                Text("@" + profileVM.userInfo.username)
                                    .foregroundStyle(Color(hex: lightGray))
                                Button{
                                    path.append("editProfile")
                                }label:{
                                    Text("Edit Profile")
                                        .foregroundColor(.black)
                                        .padding()
                                        .frame(width: 120, height: 40)
                                        .background(Color.white)
                                        .cornerRadius(20)
                                }
                            }
                        }}
                    .frame(maxWidth: .infinity, alignment: .leading)
        
                        VStack(spacing: 16) {
                            Text("Personal Info")
                                .font(.system(size: 20, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            InfoCard(title: "Email", value: profileVM.userInfo.email)
        
                            InfoCard(title: "Data di nascita", value: profileVM.userInfo.date_of_birth)
                        }
        
                        VStack() {
                            Text("Activity")
                                .font(.system(size: 20, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
        
        
                        Button {
                            isLoggingOut = true
                            authVM.logout()
                            authVM.isLoggedIn = false
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 60)
                                HStack{
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .foregroundStyle(Color(hex: redError))
                                        .padding(.trailing, 20)
        
                                    Text("Logout")
                                        .customFont(.bold, size: 18, hexColor: white)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                            }
        
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
            
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
                .onAppear {
                    if !hasLoadedUserInfo {
                        profileVM.fetchUserInfo()
                        hasLoadedUserInfo = true
                    }
                }
                .alert(isPresented: $isLoggingOut) {
                    Alert(title: Text("Logged Out"),
                          message: Text("You have been logged out."),
                          dismissButton: .default(Text("OK")))
                }
            }

            .navigationDestination(for: String.self) { value in
                if value == "changePassword" {
                    ChangePasswordView()
                } else if value == "editProfile" {
                    EditProfileView()
                        .environmentObject(authVM)  
                }
            }
            .onAppear {
                profileVM.fetchUserInfo() // 🔄 sempre aggiornato
            }
        }
    }
}

    
    
struct InfoCard: View {
    let title: String
    let value: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 80)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                
                    .foregroundStyle(Color(hex: lightGray))
                Text(value)
                    .foregroundStyle(Color.white)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}




 
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
                        
                        //                        profileVM.changePassword()
                        //                        isPasswordChanged = true
                        
                        profileVM.changePassword()
                        withAnimation {
                            isPasswordChanged = true
                        }
                        // Nascondi automaticamente dopo 2 secondi
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isPasswordChanged = false
                            }
                        }
                    }
                }) {
                    Text("Change Password")
                        .customButton(typeBtn: .primary, width: 200, height: 50, cornerRadius: 15)
                }
                Spacer()
            }
            .padding(.horizontal, 30)
            if isPasswordChanged {
                SuccessAlertView(message: "Password changed successfully")
//                    .transition(.scale.combined(with: .opacity))
            }
        }
        
        
        
    }
}

struct SuccessAlertView: View {
    var message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.green)
            Text(message)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding(30)
        .background(Color.black.opacity(0.8))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}




struct EditProfileView: View {
    @EnvironmentObject var authVM: AuthtenticationViewModel
    @StateObject var profileVM = ProfileViewModel(authVM: AuthtenticationViewModel())

    @State private var triedSubmit = false
    @State private var isUsernameChanged = false
    @State private var showImagePicker = false
    @State private var selectedUIImage: UIImage? = nil

    var body: some View {
        ZStack {
            Color(hex: darkColor).ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Edit Profile")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // 👇 FOTO PROFILO MODIFICABILE
                ZStack {
                    if let imageData = profileVM.selectedImageData,
                       let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 130, height: 130)
                            .clipShape(Circle())
                    } else if let profileImagePath = profileVM.userInfo.profile_image,
                              let url = URL(string: Environment.imageBaseURL + profileImagePath) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 130, height: 130)
                                    .clipShape(Circle())
                            case .failure:
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 130, height: 130)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 130, height: 130)
                            .foregroundColor(.gray)
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        showImagePicker = true
                    } label: {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color(hex:accentCustomColor))
                            .clipShape(Circle())
                    }
                }

                // 👇 USERNAME INPUT
                InputView(
                    inputText: $profileVM.newUsernameData.username,
                    inputName: "Username",
                    placeholder: "Enter your new username",
                    showError: triedSubmit && profileVM.newUsernameData.username.isEmpty || profileVM.isNewUsernameValid && !profileVM.newUsernameData.username.isEmpty
                )
                .onChange(of: profileVM.newUsernameData.username) { _ in
                    profileVM.validateNewUsername()
                }

                // ❌ Errori validazione
                if triedSubmit && profileVM.newUsernameData.username.isEmpty {
                    Text("Username is required")
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                if profileVM.isNewUsernameValid && !profileVM.newUsernameData.username.isEmpty {
                    Text("Username not available")
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                if !profileVM.isNewUsernameValid && !profileVM.newUsernameData.username.isEmpty {
                    Text("Username available")
                        .foregroundColor(.green)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer()

                Button {
                    triedSubmit = true
                    if !profileVM.newUsernameData.username.isEmpty && profileVM.isNewUsernameValid {
                        profileVM.changeUsername()
                        withAnimation { isUsernameChanged = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isUsernameChanged = false
                        }
                    }
                } label: {
                    Text("Save")
                        .customButton(typeBtn: .primary, width: 350, height: 50, cornerRadius: 12)
                }
            }
            .padding(24)

            if isUsernameChanged {
                SuccessAlertView(message: "Username changed successfully")
            }
        }
        // 📸 Picker sheet
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedUIImage)
                .onDisappear {
                    if let uiImage = selectedUIImage {
                        profileVM.selectedImageData = uiImage.jpegData(compressionQuality: 0.8)
                        profileVM.uploadProfileImage(uiImage) // 🔥 upload immediato
                    }
                }
        }
    }
}


    
    
    
    
    
    
    
    
    
    
    
    
    
    
//}
//
//struct PasswordChangedSuccessView: View {
//    var onDismiss: () -> Void
//
//    var body: some View {
//        ZStack {
//            Color(hex: darkColor)
//                .ignoresSafeArea()
//            
//            VStack(spacing: 32) {
//                Spacer()
//                
//                Image(systemName: "checkmark.circle.fill")
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                    .foregroundColor(.green)
//                
//                Text("Password Changed")
//                    .customFont(.bold, size: 32, hexColor: "FFFFFF")
//                
//                Text("Your password has been updated successfully.")
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(.white)
//                    .font(.subheadline)
//                    .padding(.horizontal, 30)
//                
//                Button(action: onDismiss) {
//                    Text("OK")
//                        .customButton(typeBtn: .primary, width: 200, height: 50, cornerRadius: 15)
//                }
//                
//                Spacer()
//            }
//            .padding()
//        }
//    }
//}
//
