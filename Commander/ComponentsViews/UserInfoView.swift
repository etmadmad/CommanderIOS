import SwiftUI

struct UserInfoView: View {
    @ObservedObject var userInfoViewModel: UserInfoViewModel
    let profile: Profile
    
    var body: some View {
        VStack {
            ZStack{
                Circle()
                    .fill(Color.white)
                AsyncImage(url: URL(string: profile.image)) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } placeholder: {
                    
                }
                
                .padding(1)}
            Text(profile.username)
                
                .font(.system(size: 16))
                .foregroundStyle(Color.white)
                .lineLimit(1)
                //.truncationMode(.tail) //tronca la fine
            
                .onDrag {
                    // Quando l'elemento viene trascinato, trasferiamo il nome dell'utente
                    return NSItemProvider(object: profile.username as NSString)
                                }
            
                
        }
        
        .padding()
    }
}

