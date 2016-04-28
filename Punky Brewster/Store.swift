import Foundation
import MapKit

class Store: NSObject {
    let name = "Punky Brewster"
    let shortAddress = "22B Tyne Street"
    let location = CLLocation(latitude: -43.5368540539132, longitude: 172.608717675136)
    let hours = "Mon/Tues: CLOSED\nWed/Thur: 12pm - 7pm\nFri/Sat: 12pm - 8pm\nSun: 12pm - 5pm"
    
    lazy var annotation:StoreMapAnnotation = {
        return StoreMapAnnotation(store: self)
    }()
    
    var coordinate:CLLocationCoordinate2D {
        return location.coordinate
    }
    
    
    func regionWithDistance(distance:CLLocationDistance) -> MKCoordinateRegion {
        return MKCoordinateRegionMakeWithDistance(coordinate, distance, distance)
    }
}
