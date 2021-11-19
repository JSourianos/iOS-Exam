import UIKit
import MapKit

class SingleMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var singleMapView: MKMapView!
    var userManager = UserManager()
    var currentUserId = ""
    var currentUser = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singleMapView.delegate = self
        currentUser = userManager.fetchCurrentUserData(withId: currentUserId)
        pinUserToMap()
        
        navigationController?.navigationItem.title = currentUser.firstName
    }
}

//MARK: - Pin User to Map
extension SingleMapViewController {
    func pinUserToMap() {
        //User information
        guard let lat = Double(currentUser.latitude!) else {return}
        guard let lon = Double(currentUser.longitude!) else {return}
        let userName = "\(currentUser.firstName!) \(currentUser.lastName!)"
        let userInformation = "\(currentUser.city!), \(currentUser.state!)"
        
        let initialLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        createCustomAnnotation(imageName: currentUser.pictureThumbnail!, coordinates: CLLocationCoordinate2D(latitude: lat, longitude: lon), userName: userName, userInformation: userInformation, userImageData: currentUser.imageDataThumbnail!, mapView: singleMapView)
        
        singleMapView.setStartLocation(location: initialLocation, meters: 50000)
    }
}

//MARK: - MapView Custom Pin & MapView override
extension SingleMapViewController {
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
    
    func createCustomAnnotation(imageName: String, coordinates: CLLocationCoordinate2D, userName: String, userInformation: String, userImageData: Data, mapView: MKMapView){
        let customAnnotation = CustomPointAnnotation()
        customAnnotation.pinCustomImageName = imageName
        customAnnotation.coordinate = coordinates
        customAnnotation.title = userName
        customAnnotation.subtitle = userInformation
        customAnnotation.userImageData = userImageData
        mapView.addAnnotation(customAnnotation)
    }
}
