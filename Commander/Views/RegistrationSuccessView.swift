import SwiftUI

struct RegistrationSuccessView: View {
    @Binding var isSheetPresented: Bool
    
    var body: some View {
        ZStack {
            Color(hex: darkColor)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "checkmark.seal.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color(hex: accentCustomColor))
                
                Text("Registration Successful!")
                    .customFont(.bold, size: 28, hexColor: "FFFFFF")
                    .multilineTextAlignment(.center)
                
                Text("You can now log in with your new account.")
                    .customFont(.regular, size: 16, hexColor: "FFFFFF")
                    .opacity(0.7)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    isSheetPresented.toggle()
                    print(isSheetPresented)
                } label: {
                    Text("Go to Login")
                        .customFont(.bold, size: 18, hexColor: darkColor)
                        .modifier(ButtonView(typeBtn: .primary, width: 300, height: 50, cornerRadius: 10))
                }

                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
            
    }
}

