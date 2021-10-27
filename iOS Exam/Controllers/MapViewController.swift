
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet private var mapView: MKMapView!

    //CoreData Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var coreDataUsers = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsers() //fetch users from db
        
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        
        //Set initial location
        let initialLocation = CLLocationCoordinate2D(latitude: 10.500000, longitude: -66.916664)
        mapView.setStartLocation(location: initialLocation, meters: 5000000)
        
        displayUserMarkers()
                
        navigationItem.title = "Map"
    }
    
    func displayUserMarkers(){
        for user in coreDataUsers {
            //Convert our String locations to Double
            let lat = Double(user.latitude!)!
            let lon = Double(user.longitude!)!
            let userName = "\(user.firstName!) \(user.lastName!)"
            let userInformation = "\(user.city!), \(user.state!)"
            
            let customAnnotation = CustomPointAnnotation()
            customAnnotation.pinCustomImageName = user.pictureThumbnail!
            customAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            customAnnotation.title = userName
            customAnnotation.subtitle = userInformation
            
            mapView.addAnnotation(customAnnotation)
        }
    }
    
    //Create a manager for this
    func fetchUsers() {
        do {
            self.coreDataUsers = try context.fetch(User.fetchRequest())
        } catch {
            print("Error retrieveing data: \(error.localizedDescription)")
        }
    }
}

//This needs some form of refactor..
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
        
        if let imageData = try? Data(contentsOf: URL(string: customPointAnnotation.pinCustomImageName!)!) {
            annotationView?.image = UIImage(data: imageData)
        } else {
            //Maybe start to cache images files?
            //Since we fetch the images from the internet, we need a custom pin to ensure that we have a picture when we have no internet.
            annotationView?.image = UIImage(named: "Pin")
        }

        return annotationView
    }
}


//MARK: - MapView Extension
extension MKMapView {
    func setStartLocation(location: CLLocationCoordinate2D, meters: CLLocationDistance) {
        let mapCoordinates = MKCoordinateRegion(center: location, latitudinalMeters: meters, longitudinalMeters: meters)
        self.setRegion(mapCoordinates, animated: true)
    }
}
