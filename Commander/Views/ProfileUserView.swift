import SwiftUI


struct ProfileView: View {
    @StateObject var profileVM = ProfileViewModel(authVM: AuthtenticationViewModel())
    @EnvironmentObject var authVM: AuthtenticationViewModel
    @State private var isLoggingOut = false

    var body: some View {
        ZStack {
            Color(hex: darkColor)
                .ignoresSafeArea()

            VStack(spacing: 20) {
//                Spacer()
                Text("Profile")
                    .customFont(.bold, size: 35, hexColor: accentCustomColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(Color.white)
               
                   
             
                Text(profileVM.userInfo.username)
                    .customFont(.bold, size: 25, hexColor: accentCustomColor)
                
                Button {} label: {
                    Text("Change Image")
                        .customButton(typeBtn: .primary, width: 150, height: 40, cornerRadius: 8)
                }

                // Profilo utente
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

                Spacer()
            }
            .padding(24)
        }
        .alert(isPresented: $isLoggingOut) {
            Alert(title: Text("Logged Out"),
                  message: Text("You have been logged out."),
                  dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    ProfileView()
}
