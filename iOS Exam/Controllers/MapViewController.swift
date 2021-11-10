
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet private var mapView: MKMapView!
    let userManager = UserManager()
    var allUsers: [User]?
    var annotations: [MKAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        
        //Set initial location
        let initialLocation = CLLocationCoordinate2D(latitude: 10.500000, longitude: -66.916664)
        mapView.setStartLocation(location: initialLocation, meters: 5000000)
        
        displayUserMarkers()
        navigationController?.navigationItem.title = "Map"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //mapView.removeAnnotations(annotations)
        displayUserMarkers()
    }
    
    func displayUserMarkers(){
        
        allUsers = userManager.fetchAllUsers()
        self.annotations = []
        
        if let allUsers = allUsers {
            for user in allUsers {
                let lat = Double(user.latitude!)!
                let lon = Double(user.longitude!)!
                let firstName = user.firstName! //passing the ID as title since we need to fetch data if the annotation is selected.
                
                let customAnnotation = CustomPointAnnotation()
                customAnnotation.pinCustomImageName = user.pictureThumbnail!
                customAnnotation.userImageData = user.imageDataThumbnail!
                customAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                customAnnotation.title = firstName
                
                annotations.append(customAnnotation)
            }
        }
        
        mapView.addAnnotations(annotations)
    }
}


//MARK: - MapView Custom Pin
extension MapViewController {
    //https://stackoverflow.com/questions/38274115/ios-swift-mapkit-custom-annotation
    //Modified this function to load custom images from urls.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let customPointAnnotation = annotation as! CustomPointAnnotation
        
        DispatchQueue.main.async {
            if let imageData = customPointAnnotation.userImageData {
                annotationView?.image = UIImage(data: imageData)
            } else {
                let pinImage = UIImage(named: "Pin")
                annotationView?.image = pinImage
            }
        }
        
        return annotationView
    }
    //TODO: - Sjekk om vi heller skal ha all koden under her! Da loader hvertfall mappet først.
    
    //What to happen when we click a annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let firstName = view.annotation?.title{
            let currentUser: User = userManager.fetchCurrentUserData(withFirstName: firstName!)
            
            let singleContactVC = self.storyboard?.instantiateViewController(withIdentifier: "SingleContact") as! SingleContactViewController
            singleContactVC.currentUser = currentUser
            navigationController.self?.pushViewController(singleContactVC, animated: true)
        }
    }
}

//MARK: - MapView Extension
extension MKMapView {
    func setStartLocation(location: CLLocationCoordinate2D, meters: CLLocationDistance) {
        let mapCoordinates = MKCoordinateRegion(center: location, latitudinalMeters: meters, longitudinalMeters: meters)
        self.setRegion(mapCoordinates, animated: true)
    }
}

//https://stackoverflow.com/questions/24056205/how-to-use-background-thread-in-swift?rq=1
//MARK: - DispatchQueue Extension
extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}
