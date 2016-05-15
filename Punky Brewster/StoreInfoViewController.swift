import UIKit
import MapKit

class StoreInfoViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let multiPointRegionPadding = 1.5
    let singlePointRegionRadius: CLLocationDistance = 2000
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var alreadyLocatedUser:Bool = false
    
    var firstStore:Store? {
        return StatusRequest.cachedStores[0]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        addStoreAnnotations()
        selectFirstStore()
        requestUserLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        alreadyLocatedUser = false
        
        if annotations.first != nil {
            focusMap()
        }
    }
    
    lazy var annotations:[StoreMapAnnotation] = {
        return StatusRequest.cachedStores.map({ store in StoreMapAnnotation(store: store) })
    }()
    
    func focusMap() {
        if mapView.userLocation.location == nil {
            centerMapOnFirstStore()
        } else {
            centerMapOnFirstStoreAndUser()
        }
        
    }
    
    func selectFirstStore() {
        mapView.selectAnnotation(annotations.first!, animated: false)
        self.mapView.camera.altitude *= multiPointRegionPadding
    }
    
    func centerMapOnFirstStore() {
        if firstStore != nil {
            let region = StatusRequest.cachedStores.first!.regionWithDistance(singlePointRegionRadius)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func centerMapOnFirstStoreAndUser() {
        if !annotations.isEmpty {
            let storeAnnotation = annotations.first!
            mapView.showAnnotations([storeAnnotation, mapView.userLocation], animated: true)
        }
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
        
        focusMap()
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