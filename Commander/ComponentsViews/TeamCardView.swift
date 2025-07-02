import SwiftUI


struct TeamsCardview: View {
    var teamColorCard: String
    var members: [String]
    var onMemberDropped: (String) -> Void

    @State private var showSheet = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Team")
                .font(.system(size: 30))
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            Text("\(members.count)")
                .font(.system(size: 100))
                .foregroundStyle(Color.white)

            Button("View") {
                showSheet = true
            }
            .customButton(
                typeBtn: .tertiary,
                width: 120,
                height: 40,
                cornerRadius: 10
            )
        }
        .frame(minWidth: 170, maxWidth: .infinity, minHeight: 320)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .foregroundStyle(Color(hex: teamColorCard))
        )
        .onTapGesture {
            showSheet = true
        }
        .onDrop(of: [.text], isTargeted: nil) { providers in
            if let provider = providers.first {
                _ = provider.loadObject(ofClass: NSString.self) { object, _ in
                    if let username = object as? String {
                        DispatchQueue.main.async {
                            onMemberDropped(username)
                        }
                    }
                }
                return true
            }
            return false
        }
        .sheet(isPresented: $showSheet) {
            ZStack {
                Color(hex: darkColor)
                    .ignoresSafeArea(.all, edges: .all)
                VStack {
                    Text("Players in Team")
                        .font(.title)
                        .padding()
                    if members.isEmpty {
                        Text("No players assigned.")
                            .foregroundColor(.secondary)
                    } else {
                        List(members, id: \.self) { member in
                            Text(member)
                        }
                    }
                    Button("Close") {
                        showSheet = false
                    }
                    .padding()
                }
            }

            .presentationDetents([.medium])
        }
    }
}
