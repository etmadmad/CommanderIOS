
import MapKit
import SwiftUI
import CoreLocation
import Combine

import SwiftUI


struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 45.5490468, longitude: 8.8935299),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    @State private var hasCentered = false

    var body: some View {
        Map(position: $position, interactionModes: [.all])
            .mapStyle(.imagery(elevation: .realistic))
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .onAppear {
                locationManager.requestPermission()
            }
            .onReceive(locationManager.$userLocation) { coordinate in
                if let coordinate = coordinate, !hasCentered {
                    position = .region(
                        MKCoordinateRegion(
                            center: coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                    )
                    hasCentered = true
                }
            }
    }
}


#Preview {
    MapView()
}

