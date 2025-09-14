//
//  MapKitProvaaaa.swift
//  Commander
//
//  Created by ethimad on 25/08/25.
//
import SwiftUI
import Foundation
import MapKit



struct LocationButtonTestView: View {
    @StateObject var locationManager = LocationManager2()
    @State private var cameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 45.4642, longitude: 9.19),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    
    let marker = CLLocationCoordinate2D(latitude: 45.4642, longitude: 9.19)
    
    var body: some View {
        VStack {
            Map(position: $cameraPosition) {
                // Marker custom
                Marker("SUCA", coordinate: marker)

                // Posizione utente
                UserAnnotation()
            }
            .mapStyle(.imagery(elevation: .realistic))
            .mapControls {
                MapCompass()
                MapPitchToggle()
                MapScaleView()
                MapUserLocationButton()
                   .foregroundStyle(Color(hex: accentCustomColor))
                   .background(Color(hex: accentCustomColor).opacity(0.2))
                

            }
            .onAppear {
                locationManager.requestPermission()
            }
            .onChange(of: locationManager.lastLocation) { newLocation in
                
              if let location = newLocation {
                    // Quando cambia la posizione, aggiorna la camera
                    withAnimation {
                        cameraPosition = .region(
                            MKCoordinateRegion(
                                center: location.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            )
                        )
                    }
                }
            }
        }
    }
}
#Preview {
    LocationButtonTestView()
}


class LocationManager2: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var lastLocation: CLLocation?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.lastLocation = location
        }
    }
}


