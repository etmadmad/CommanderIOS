import SwiftUI

struct UserInfoView: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    let profile: Profile
    
    var body: some View {
        VStack {
            // Circulo di sfondo
            Circle()
                .fill(Color.green)
                .frame(width: 60, height: 60)

            // Carica immagine del profilo (uso di AsyncImage per URL)
            AsyncImage(url: URL(string: profile.image)) { image in
                image.resizable()
                     .scaledToFill()
                     .frame(width: 40, height: 40)
                     .clipShape(Circle())
            } placeholder: {
             //   ProgressView()  // Mostra un caricamento mentre l'immagine viene scaricata
            }

            // Mostra il nome utente
            Text(profile.username)
                .font(.headline)
        }
        .padding()
    }
}

#Preview {
    let sampleProfile = Profile(username: "JohnDoe", image: "https://via.placeholder.com/150")
    let sampleViewModel = UserInfoViewModel()
    sampleViewModel.users = [sampleProfile]
    
    return UserInfoView(userInfoViewModel: sampleViewModel, profile: sampleProfile)
}

