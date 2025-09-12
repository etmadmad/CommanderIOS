
import SwiftUI

struct ProfileInfoView: View {
    @StateObject var profileVM = ProfileViewModel(authVM: AuthtenticationViewModel())
    @EnvironmentObject var authVM: AuthtenticationViewModel
    @StateObject var registrationVM: RegisterViewModel
    @State private var isLoggingOut = false
    @State private var isEditingUsername = false
    @State private var editedUsername = ""
    
    @State private var hasLoadedUserInfo = false
    
    var body: some View {
        ZStack{
            Color(hex: darkColor)
                .ignoresSafeArea()
            
            VStack {
                Text("Profile")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
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
                                .foregroundStyle(Color(hex: grayDetails))
                            Button{
                                
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
                    }}
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
            }
        
           
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
                    .customFont(.semibold, size: 14, hexColor: "AAAAAA")
                Text(value)
                    .customFont(.regular, size: 18, hexColor: "FFFFFF")
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
