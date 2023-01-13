//
//  BelarusBank.swift
//  task_4
//
//  Created by Artem Sulzhenko on 12.01.2023.
//

import Foundation
import MapKit

class BelarusBank: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    var cityB: String {
        return ""
    }

}
