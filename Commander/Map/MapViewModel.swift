import MapKit
import CoreLocation
import Combine
import Foundation
import KeychainAccess
import Alamofire
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    @Published var userLocation: CLLocationCoordinate2D?
//    private let manager = CLLocationManager()
//
//    override init() {
//        super.init()
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//
//    func requestPermission() {
//        if manager.authorizationStatus == .notDetermined {
//            manager.requestWhenInUseAuthorization()
//        } else if manager.authorizationStatus == .authorizedWhenInUse {
//            manager.requestAlwaysAuthorization()
//        }
//        manager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        DispatchQueue.main.async {
//            self.userLocation = location.coordinate
//        }
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
//            manager.startUpdatingLocation()
//        }
//    }
//}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?
    private let manager = CLLocationManager()
    
    private let keychain = Keychain(service: "com.InsalataCreativa.Commander")
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if manager.authorizationStatus == .authorizedWhenInUse {
            manager.requestAlwaysAuthorization()
        }
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func getPoi(gameId: String, completion: @escaping (PoiList?) -> Void) {
        guard let token = try? keychain.get("accessToken") else {
            print("Token not found")
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        let getPoiURL = "\(Environment.baseURL)/game-configurations/\(gameId)/pois/"
        
        AF.request(getPoiURL, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: PoiList.self) { response in
                DispatchQueue.main.async {
                    print("Create Session URL:", response.request?.url?.absoluteString ?? "no url")
                    print("Status Code:", response.response?.statusCode ?? 0)
                    
                    switch response.result {
                    case .success(let session):
                        print("Session created successfully: \(session)")
                        completion(session)
                    case .failure(let error):
                        print("Failed to create session: \(error)")
                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            print("Response body:", responseString)
                        }
                        completion(nil)
                        
                    }
                }
            }
    }
}
