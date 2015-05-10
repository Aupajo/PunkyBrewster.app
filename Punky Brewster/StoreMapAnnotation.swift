import MapKit

class StoreMapAnnotation: NSObject, MKAnnotation {
    let store:Store
    
    init(store:Store) {
        self.store = store
        super.init()
    }
    
    var coordinate: CLLocationCoordinate2D {
        return store.coordinate
    }
    
    var title:String {
        return store.name
    }
    
    var subtitle:String {
        return store.address
    }
}