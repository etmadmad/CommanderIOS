import Alamofire
import SwiftUI
import Foundation


class UserInfoViewModel: ObservableObject {
    @Published var users: [Profile] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchUsers(limit: Int = 20) {
        isLoading = true
        errorMessage = nil

        let url = "https://dummyjson.com/users?limit=\(limit)"

        AF.request(url)
            .validate()
            .responseDecodable(of: UserInfoModel.self) { response in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch response.result {
                    case .success(let userInfo):
                        self.users = userInfo.users
                        print("dati caricati")
                    case .failure(let error):
                        self.errorMessage = "Errore: \(error.localizedDescription)"
                    }
                }
            }
    }
}
