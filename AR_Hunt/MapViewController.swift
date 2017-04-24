import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!
  
  var targets = [ARItem]()
  let locationManager = CLLocationManager()
  var userLocation: CLLocation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
    setupLocations()
    
    if CLLocationManager.authorizationStatus() == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  
  //replace with coordinates near me long: 34.18 lat: -188.311
  func setupLocations() {
    let firstTarget = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 34.1804, longitude: -118.311), itemNode: nil)
    targets.append(firstTarget)
    
//    let secondTarget = ARItem(itemDescription: "wolf", location: CLLocation(latitude: 34.18, longitude: -118.311), itemNode: nil)
//    targets.append(secondTarget)
//    
//    let thirdTarget = ARItem(itemDescription: "dragon", location: CLLocation(latitude: 34.18, longitude: -118.311), itemNode: nil)
//    targets.append(thirdTarget)
    
    for item in targets {
      let annotation = MapAnnotation(location: item.location.coordinate, item: item)
      self.mapView.addAnnotation(annotation)
    }
  }
}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    self.userLocation = userLocation.location
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    let coordinate = view.annotation!.coordinate
    
    if let userCoordinate = userLocation {
      //50 meters away!!
      if userCoordinate.distance(from: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) < 1000 {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "ARViewController") as? ViewController {
          
          if let mapAnnotation = view.annotation as? MapAnnotation {
            
            viewController.target = mapAnnotation.item
            viewController.userLocation = mapView.userLocation.location!
            self.present(viewController, animated: true, completion: nil)
          }
        }
      }
    }
  }
}
