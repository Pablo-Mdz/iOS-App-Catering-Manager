//
//  MapViewModel.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 11/07/2024.
//

import Foundation
import Combine
import MapKit
import SwiftUI

class MapViewModel: ObservableObject {
    @Published var mapCameraPosition: MapCameraPosition = .automatic
    @Published var location: CLLocation?
    private var lastKnownCoordinate: CLLocationCoordinate2D?
    private let locationService = LocationService()
    private var cancelBag = Set<AnyCancellable>()
//    @Published var destinationName: String = ""
//    @Published var route: MKRoute?
//    
    init() {
        self.locationService.requestLocation()
        self.locationService.$location
            .sink { location in
                if let location {
                    self.mapCameraPosition = .camera(.init(centerCoordinate: location.coordinate, distance: 1500))
                }
            }
            .store(in: &cancelBag)
    }
    func requestLocation() {
           locationService.requestLocation()
       }

    func lookupAddress(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in // swiftlint:disable:this unused_closure_parameter
            if let location = placemarks?.first?.location {
                self.mapCameraPosition = .camera(.init(centerCoordinate: location.coordinate, distance: 1500))
            }
        }
    }

//    @MainActor
//    func fetchRoute() {
//        if let lastKnownCoordinate = self.lastKnownCoordinate {
//            let request = MKDirections.Request()
//            
//            Task {
//                let destinations = try await CLGeocoder().geocodeAddressString(destinationName)
//                if let firstPlacemark = destinations.first {
//                    request.source = MKMapItem(placemark: MKPlacemark(coordinate: lastKnownCoordinate))
//                    request.destination = MKMapItem(placemark: MKPlacemark(placemark: firstPlacemark))
//                    request.transportType = .automobile
//                    
//                    let result = try? await MKDirections(request: request).calculate()
//                    self.route = result?.routes.first
//                }
//            
//            }
//        }
//    }
}
