import UIKit
import MapKit

class StoreInfoViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let stores: [Store] = [Store()]
    let multiPointRegionPadding = 1.5
    let singlePointRegionRadius: CLLocationDistance = 2000
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var alreadyLocatedUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        requestUserLocation()
        addStoreAnnotations()
        
        if annotations.first != nil {
            selectFirstStore()
            centerMapOnFirstStore()
        }
    }
    
    lazy var annotations:[StoreMapAnnotation] = {
        return self.stores.map({ store in StoreMapAnnotation(store: store) })
    }()
    
    func selectFirstStore() {
        mapView.selectAnnotation(annotations.first!, animated: false)
        self.mapView.camera.altitude *= multiPointRegionPadding
    }
    
    func centerMapOnFirstStore() {
        let region = stores.first!.regionWithDistance(singlePointRegionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    func centerMapOnFirstStoreAndUser() {
        if annotations.first == nil || mapView.userLocation.location == nil {
            return
        }
        
        let storeAnnotation = annotations.first!
        
        mapView.showAnnotations([storeAnnotation, mapView.userLocation], animated: true)
    }
    
    func addStoreAnnotations() {
        annotations.forEach({ annotation in mapView.addAnnotation(annotation) })
    }
    
    func requestUserLocation() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        handleAuthorizationStatusChange(authorizationStatus)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if alreadyLocatedUser {
            return
        }
        
        centerMapOnFirstStoreAndUser()
        alreadyLocatedUser = true
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        handleAuthorizationStatusChange(status)
    }
    
    private func handleAuthorizationStatusChange(authorizationStatus:CLAuthorizationStatus) {
        if authorizationStatus == CLAuthorizationStatus.Restricted || authorizationStatus == CLAuthorizationStatus.Denied {
            return
        }
        
        if authorizationStatus == CLAuthorizationStatus.NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}