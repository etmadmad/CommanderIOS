import SwiftUI

struct UserProfileView: View {
    let player: PlayerInSessionStatus
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                
                if let urlString = player.profileImage, let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                            .frame(width: 60, height: 60)
                    }
                    .padding(1)
                } else {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                        .frame(width: 60, height: 60)
                    
                    
                    
                }
            }
            
            Text(player.username.count > 7 ? String(player.username.prefix(7)) + "..." : player.username)
                .font(.system(size: 16))
                .foregroundStyle(Color.white)
                .lineLimit(1)
                .onDrag {
                    NSItemProvider(object: player.username as NSString)
                }
        }
        .padding(.horizontal, 8)
    }
    
}
