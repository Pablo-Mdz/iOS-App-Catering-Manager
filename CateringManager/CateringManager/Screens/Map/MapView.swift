//
//  MapView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 11/07/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var locationManager = LocationService()
    @State private var cameraPosition = MapCameraPosition.camera(
        MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), distance: 100.0)
    )
    @State private var markerCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var address: String
    var eventName: String

    var body: some View {
        VStack {
            Map(position: $cameraPosition) {
                Marker(eventName, coordinate: markerCoordinate)
                    .tint(.orange)
            }
            .onChange(of: locationManager.location) { oldLocation, newLocation in // swiftlint:disable:this unused_closure_parameter
                setCameraPosition(newLocation)
            }
            .onAppear {
                getCoordinate(address: address)
            }
            .mapControls {
                MapCompass()
                MapScaleView()
//                MapUserLocationButton()
            }
            .clipShape(RoundedRectangle(cornerRadius: 15.0))
            .padding()
        }
    }

    private func setCameraPosition(_ location: CLLocation?) {
        guard let location = location else { return }
        cameraPosition = .camera(
            MapCamera(centerCoordinate: location.coordinate, distance: 2500)
        )
    }

    private func getCoordinate(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let coordinate = placemarks?.first?.location?.coordinate {
                cameraPosition = .camera(
                    MapCamera(centerCoordinate: coordinate, distance: 2500)
                )
                markerCoordinate = coordinate
            } else if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
            }
        }
    }
}
#Preview {
    MapView(address: "Godoy Cruz 2168, guaymallen, mendoza.", eventName: "Geburstag 50")
}
