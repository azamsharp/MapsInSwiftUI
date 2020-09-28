//
//  ContentView.swift
//  FindUserLocation
//
//  Created by Mohammad Azam on 9/27/20.
//

import SwiftUI
import MapKit
import Combine

struct PizzaAnnotation: Identifiable, Decodable {
    var id = UUID()
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: CodingKey {
        case latitude
        case longitude
    }
}

struct ContentView: View {
    
    @ObservedObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion.defaultRegion
    @State private var cancellable: AnyCancellable?
    @State private var annotations = [PizzaAnnotation]()
    
    private func setCurrentLocation() {
        cancellable = locationManager.$location.sink { location in
            region = MKCoordinateRegion(center: location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: 500, longitudinalMeters: 500)
        }
    }
    
    private func loadLocations() {
        
        guard let path = Bundle.main.path(forResource: "locations", ofType: "json") else {
            fatalError("File locations.json not found!")
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return }
        
        let annotations = try? JSONDecoder().decode([PizzaAnnotation].self, from: data)
        if let annotations = annotations {
            self.annotations = annotations
        }
        
    }
    
    var body: some View {
        
        VStack {
            if locationManager.location != nil {
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: nil, annotationItems: annotations) { annotation in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude)) {
                        Image("pizza")
                            .resizable()
                            .frame(width: 50, height: 50) 
                    }
                }
            } else {
                Text("Locating user location...")
            }
        }
        
        .onAppear {
            setCurrentLocation()
            loadLocations()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
