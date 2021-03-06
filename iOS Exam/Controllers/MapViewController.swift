
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
        
        mapView.removeAnnotations(annotations)
        displayUserMarkers()
    }
    
    func displayUserMarkers(){
        
        allUsers = userManager.fetchAllUsers()
        self.annotations = []
        
        if let allUsers = allUsers {
            for user in allUsers {
                
                guard let latitude = user.latitude else {return}
                guard let longitude = user.longitude else {return}
                guard let lat = Double(latitude) else {return}
                guard let lon = Double(longitude) else {return}
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
