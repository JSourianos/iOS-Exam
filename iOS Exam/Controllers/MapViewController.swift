
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet private var mapView: MKMapView!
    let userManager = UserManager()
    var allUsers: [User]?
    var annotations: [MKAnnotation] = []
    
    //TODO: - Do we need viewDidLoad?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        
        //Set initial location
        let initialLocation = CLLocationCoordinate2D(latitude: 10.500000, longitude: -66.916664)
        mapView.setStartLocation(location: initialLocation, meters: 5000000)
        
        displayUserMarkers()
        
        navigationItem.title = "Map"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //mapView.removeAnnotations(annotations)
        displayUserMarkers()
    }
    
    func displayUserMarkers(){
        DispatchQueue.background(delay: 1.5, background: {
            self.allUsers = self.userManager.fetchAllUsers()
            self.annotations = [] //reset annotation array
            
            if let allUsers = self.allUsers {
                for user in allUsers {
                    let lat = Double(user.latitude!)!
                    let lon = Double(user.longitude!)!
                    let firstName = user.firstName! //passing the ID as title since we need to fetch data if the annotation is selected.
                    
                    let customAnnotation = CustomPointAnnotation()
                    customAnnotation.pinCustomImageName = user.pictureThumbnail!
                    customAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    customAnnotation.title = firstName
                    
                    self.annotations.append(customAnnotation)
                }
            }
        }, completion: {
            self.mapView.addAnnotations(self.annotations)
        })
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
            if let imageData = try? Data(contentsOf: URL(string: customPointAnnotation.pinCustomImageName!)!) {
                annotationView?.image = UIImage(data: imageData)
            } else {
                let pinImage = UIImage(named: "Pin")
                //Since we fetch the images from the internet, we need a custom pin to ensure that we have a picture when we have no internet.
                annotationView?.image = pinImage
            }
        }
        
        return annotationView
    }
    //TODO: - Sjekk om vi heller skal ha all koden under her! Da loader hvertfall mappet først.
    
    /*
     func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
     <#code#>
     }
     */
    
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
