//
//  MKCoordinateRegion+Extensions.swift
//  FindUserLocation
//
//  Created by Mohammad Azam on 9/27/20.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    
    static var defaultRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D.init(latitude: 29.726819, longitude: -95.393692), latitudinalMeters: 100, longitudinalMeters: 100)
    }
    
}
