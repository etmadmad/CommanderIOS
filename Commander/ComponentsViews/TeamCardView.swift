import SwiftUI

//
//struct TeamsCardview: View {
//    var numberTeam: Int
//    var teamColorCard: String
//    
//    var body: some View {
//        VStack(spacing: 40) {
//            
//            Text("Team")
//                .font(.system(size: 30))
//                .fontWeight(.bold)
//                .foregroundStyle(Color.white)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal)
//            Text("1")
//                .font(.system(size: 100))
//                .foregroundStyle(Color.white)
//                
//            Button("View") {}
//                .customButton(
//                    typeBtn: .tertiary,
//                    width: 120,
//                    height: 40,
//                    cornerRadius: 10
//                )
//            
//        }
//        .frame(minWidth: 170, maxWidth: .infinity, minHeight: 320)
//        .background(
//            RoundedRectangle(cornerRadius: 24)
//                .foregroundStyle(Color(hex: teamColorCard))
//        )
//        
//    }
//}
//
//#Preview {
//    TeamsCardview(numberTeam: 2, teamColorCard: "#233445")
//}



struct TeamsCardview: View {
    var numberTeam: Int
    var teamColorCard: String

    @State private var members: [String] = []

    var body: some View {
        VStack(spacing: 20) {
            Text("Team")
                .font(.system(size: 30))
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            Text("\(numberTeam)")
                .font(.system(size: 100))
                .foregroundStyle(Color.white)

            Button("View") {}
                .customButton(
                    typeBtn: .tertiary,
                    width: 120,
                    height: 40,
                    cornerRadius: 10
                )

            VStack(alignment: .leading, spacing: 5) {
                ForEach(members, id: \.self) { member in
                    Text(member)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(6)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
        .frame(minWidth: 170, maxWidth: .infinity, minHeight: 320)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .foregroundStyle(Color(hex: teamColorCard))
        )
        .onDrop(of: [.text], isTargeted: nil) { providers in
            if let provider = providers.first {
                _ = provider.loadObject(ofClass: NSString.self) { object, _ in
                    if let username = object as? String {
                        DispatchQueue.main.async {
                            if !members.contains(username) {
                                members.append(username)
                            }
                        }
                    }
                }
                return true
            }
            return false
        }
    }
}
