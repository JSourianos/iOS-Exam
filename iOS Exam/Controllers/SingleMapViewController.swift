//
//  SingleMapViewController.swift
//  iOS Exam
//
//  Created by Thomas Sourianos on 27/10/2021.
//

import UIKit
import MapKit

class SingleMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var singleMapView: MKMapView!
    var currentUser = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        singleMapView.delegate = self
        
        //User information
        let lat = Double(currentUser.latitude!)
        let lon = Double(currentUser.longitude!)
        let userName = "\(currentUser.firstName!) \(currentUser.lastName!)"
        let userInformation = "\(currentUser.city!), \(currentUser.state!)"
        
        let initialLocation = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)

        createCustomAnnotation(imageName: currentUser.pictureThumbnail!, coordinates: CLLocationCoordinate2D(latitude: lat!, longitude: lon!), userName: userName, userInformation: userInformation, mapView: singleMapView)
            
        singleMapView.setStartLocation(location: initialLocation, meters: 50000)
    }
    
    //Maybe move this out?
    func createCustomAnnotation(imageName: String, coordinates: CLLocationCoordinate2D, userName: String, userInformation: String, mapView: MKMapView){
        let customAnnotation = CustomPointAnnotation()
        customAnnotation.pinCustomImageName = imageName
        customAnnotation.coordinate = coordinates
        customAnnotation.title = userName
        customAnnotation.subtitle = userInformation
        mapView.addAnnotation(customAnnotation)
    }
}


//MARK: - MapView Custom Pin (FIND A WAY TO REFACTOR)
extension SingleMapViewController {
    //https://stackoverflow.com/questions/30262269/custom-marker-image-on-swift-mapkit
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
            annotationView?.image = UIImage()
        }
        
        return annotationView
    }
}
