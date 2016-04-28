import UIKit
import MapKit

class StoreInfoViewController: UIViewController, MKMapViewDelegate {
    let stores: [Store] = [Store()]
    let regionRadius: CLLocationDistance = 2000
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStoreAnnotations()
        centerMapOnFirstStore()
    }
    
    var annotations:[StoreMapAnnotation] {
        return stores.map({ store in StoreMapAnnotation(store: store) })
    }
    
    func centerMapOnFirstStore() {
        mapView.selectAnnotation(mapView.annotations.first!, animated: false)
        
        let coordinateRegion = stores.first!.regionWithDistance(regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addStoreAnnotations() {
        annotations.forEach({ annotation in mapView.addAnnotation(annotation) })
    }
}