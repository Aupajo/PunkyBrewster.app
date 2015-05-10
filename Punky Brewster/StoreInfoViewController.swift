import UIKit
import MapKit

class StoreInfoViewController: UIViewController, MKMapViewDelegate {
    let store: Store = Store()
    let regionRadius: CLLocationDistance = 1000
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStoreAnnotation()
        centerMapOnStore()
    }
    
    var annotation:StoreMapAnnotation {
        return StoreMapAnnotation(store: store)
    }
    
    func centerMapOnStore() {
        let coordinateRegion = store.regionWithDistance(regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addStoreAnnotation() {
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(mapView.annotations.first as! MKAnnotation, animated: false)
    }
}