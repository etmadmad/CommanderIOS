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
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isLoggedIn {
                    if authViewModel.isOTPvalid {
                        TabBarView()
                            .environmentObject(authViewModel)
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
        }
    }
}
