//import SwiftUI
//
//@main
//struct CommanderApp: App {
//    @StateObject var authViewModel = AuthtenticationViewModel()
//    
//    var body: some Scene {
//        WindowGroup {
//            Group {
//                if authViewModel.isLoggedIn {
//                    if authViewModel.isOTPvalid {
//                        ContentView()
//                            .environmentObject(authViewModel)
//                        TabBarView()
//                        
////                        ProfileView()
////                            .environmentObject(authViewModel)
//                    } else {
//                        OTPVerificationView()
//                            .environmentObject(authViewModel)
//                    }
//                } else {
//                    LogInView()
//                        .environmentObject(authViewModel)
//                }
//            }
//        }
//    }
//}

//import SwiftUI
//
//@main
//struct CommanderApp: App {
////    @StateObject var authViewModel = AuthtenticationViewModel()
//    
//    var body: some Scene {
//        WindowGroup {
//            MapView()
//        }
//       
//    }
//}


import SwiftUI

@main
struct CommanderApp: App {
    @StateObject var authViewModel = AuthtenticationViewModel()
    @StateObject var gameConfigVM = GameConfigurationViewModel()
    
//    @State private var gameConfigVM = GameConfigurationViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isLoggedIn {
                    if authViewModel.isOTPvalid {
                        TabBarView()
                            .environmentObject(authViewModel)
                            .environmentObject(gameConfigVM)
     
//                        ProfileView()
//                            .environmentObject(authViewModel)
                    } else {
                        OTPVerificationView()
                            .environmentObject(authViewModel)
                    }
                } else {
                    LogInView()
                        .environmentObject(authViewModel)
                }
            }
//            .environmentObject(gameConfigVM)
            .onChange(of: authViewModel.isOTPvalid) { otpValid in
                if otpValid {
                    gameConfigVM.getAllGames()
                }}
            /// EVITARE STATE LEAK
//            .onChange(of: authViewModel.isLoggedIn) { loggedIn in
//                if loggedIn {
//                    // nuovo utente → crea nuovo VM fresco
//                    gameConfigVM = GameConfigurationViewModel()
//                    gameConfigVM.getAllGames()
//                } else {
//                    // logout → svuota
//                    gameConfigVM = GameConfigurationViewModel()
//                }
//            }

        }
    }
}
