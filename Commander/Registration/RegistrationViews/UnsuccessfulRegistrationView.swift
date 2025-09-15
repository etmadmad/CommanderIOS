import SwiftUI

struct InvalidEmailDomainView: View {
    @Binding var isSheetPresented: Bool

    var body: some View {
        ZStack {
            Color(hex: darkColor)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "xmark.octagon.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
                
                Text("Unsuccessful Registration")
                    .customFont(.bold, size: 28, hexColor: "FFFFFF")
                    .multilineTextAlignment(.center)
                
                Text("Unsuccessful Registration. Please try again later.")
                    .customFont(.regular, size: 16, hexColor: "FFFFFF")
                    .opacity(0.7)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    isSheetPresented.toggle()
                } label: {
                    Text("Try Again")
                        .customFont(.bold, size: 18, hexColor: darkColor)
                        .modifier(ButtonView(typeBtn: .primary, width: 300, height: 50, cornerRadius: 10))
                }

                Spacer()
            }
            .padding()
        }
//        .navigationBarBackButtonHidden(true)
    }
}

