import SwiftUI

struct TabBarView: View {
    var body: some View {
        Spacer()
        HStack{
            TabView{
                Tab("Home", systemImage: "house") {
                    
                }
              
                Tab("Map", systemImage: "map") {
                    
                }
                
                .badge("2")
                Tab("Profile", systemImage: "person.fill") {
                }

            }
        }
        .border(Color.red)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    TabBarView()
}
