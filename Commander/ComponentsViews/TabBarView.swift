import SwiftUI
struct TabBarView: View {
    @EnvironmentObject var authViewModel: AuthtenticationViewModel

    var body: some View {
        TabView {
//            ManageTeamsView()
            GameJoinView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }

            NavigationStack {
                  ProfileView(registrationVM: RegisterViewModel())
              }
              .tabItem {
                  Label("Profile", systemImage: "person.fill")
              }
        }
        .toolbarBackground(.indigo, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

#Preview {
    TabBarView()
}
