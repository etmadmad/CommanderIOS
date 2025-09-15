import Foundation
import CoreLocation

struct PoiDetail: Decodable, Identifiable {
    let id: String
    let point_name: String
    let coordinate_x: String
    let coordinate_y: String
    let description: String?
    let game_configuration: String

    var coordinate: CLLocationCoordinate2D? {
        guard let lat = Double(coordinate_y), let lon = Double(coordinate_x) else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

struct PoiList: Decodable {
    let pois: [PoiDetail]
}



