import SwiftUI


struct ProfileView: View {
    @StateObject var profileVM = ProfileViewModel(authVM: AuthtenticationViewModel())
    @EnvironmentObject var authVM: AuthtenticationViewModel
    @StateObject var registrationVM: RegisterViewModel
    @State private var isLoggingOut = false
    @State private var isEditingUsername = false
    @State private var editedUsername = ""
    
    @State private var hasLoadedUserInfo = false
    
    var body: some View {
        ZStack {
            Color(hex: darkColor)
                .ignoresSafeArea()
            
            VStack {
                Text("Profile")
                    .customFont(.bold, size: 35, hexColor: accentCustomColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    if isEditingUsername {
                        VStack{
                            TextField("Username", text: $profileVM.newUsernameData.username)
                                .customFont(.bold, size: 25, hexColor: white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .autocapitalization(.none)
                                .textInputAutocapitalization(.never)
                                .onChange(of: profileVM.newUsernameData.username) {
                                    profileVM.validateNewUsername()
                                    
                                }
                            errorText(profileVM.isNewUsernameValid && !profileVM.newUsernameData.username.isEmpty, message: "Username is already taken")
                            
                        }
                        Button(action: {
                            if profileVM.isNewUsernameValid && !profileVM.newUsernameData.username.isEmpty {
                                isEditingUsername = true
                            }
                            else{
                                isEditingUsername = false
                                print($profileVM.newUsernameData.username)
                                profileVM.changeUsername()
                            }
                        }) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 26))
                                .foregroundStyle(Color(hex: accentCustomColor))
                        }
                        Button(action: {
                          
                            isEditingUsername = false
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 26))
                                .foregroundStyle(Color(hex: redError))
                        }
                    } else {
                        Text("@\(profileVM.userInfo.username)")
                            .customFont(.bold, size: 25, hexColor: white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Button(action: {
                            editedUsername = profileVM.userInfo.username
                            isEditingUsername = true
                        }) {
                            Image(systemName: "pencil")
                                .font(.system(size: 26))
                                .foregroundStyle(Color(hex: grayDetails))
                                .symbolEffect(.bounce)
                            
                        }
                    }
             }
                
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
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                            case .failure:
                                Image(systemName: "person.crop.circle.badge.exclam")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)
                }

                
                
                
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Name")
                        .customFont(.semibold, size: 14, hexColor: "AAAAAA")
                    Text(profileVM.userInfo.first_name)
                        .customFont(.regular, size: 18, hexColor: "FFFFFF")
                    
                    
                    Text("Last Name")
                        .customFont(.semibold, size: 14, hexColor: "AAAAAA")
                    Text(profileVM.userInfo.last_name)
                        .customFont(.regular, size: 18, hexColor: "FFFFFF")
                    
                    Text("Birthday")
                        .customFont(.semibold, size: 14, hexColor: "AAAAAA")
                    Text(profileVM.userInfo.date_of_birth)
                        .customFont(.regular, size: 18, hexColor: "FFFFFF")
                    
                    HStack {
                        Text("Password")
                            .customFont(.semibold, size: 14, hexColor: "AAAAAA")
                        NavigationLink(destination: ChangePasswordView()) {
                            Image(systemName: "pencil")
                                .font(.system(size: 20))
                                .foregroundStyle(Color(hex: grayDetails))
                        }
                        
                        
                    }
                    Text("********")
                        .customFont(.regular, size: 18, hexColor: "FFFFFF")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                /// LOGOUT BTN
                Button {
                    isLoggingOut = true
                    authVM.logout()
                    authVM.isLoggedIn = false
                } label: {
                    Text("Logout")
                        .customFont(.bold, size: 18, hexColor: white)
                    
                        .customButton(typeBtn: .tertiary, width: 350, height: 50, cornerRadius: 8)
                }
                
                Button {
                    //                    isLoggingOut = true
                    authVM.deleteAccount()
                    //                    authVM.isLoggedIn = false
                } label: {
                    Text("Delete Account")
                        .customFont(.bold, size: 18, hexColor: redError)
                    
                        .customButton(typeBtn: .tertiary, width: 350, height: 50, cornerRadius: 8)
                }
                
                Spacer()
            }
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
    }}

//#Preview {
//    let authVM = AuthtenticationViewModel()
//    let registrationVM = RegisterViewModel()
//    return ProfileView(registrationVM: registrationVM)
//        .environmentObject(authVM)
//}
