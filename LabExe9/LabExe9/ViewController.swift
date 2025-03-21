import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var routeButton: UIButton!
    
    var locations: [CLLocationCoordinate2D] = []
    var clickCounter = 0 // Counter for click limit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Set the map to show Ontario only
        let ontarioRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 43.7, longitude: -79.42), // Toronto's center
            span: MKCoordinateSpan(latitudeDelta: 6.0, longitudeDelta: 6.0) // Zoom level for Ontario
        )
        mapView.setRegion(ontarioRegion, animated: true)
        
        // Add gesture recognizer for tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func mapTapped(_ sender: UITapGestureRecognizer) {
        guard clickCounter < 3 else { return } // Limit clicks to 3
        
        let locationInView = sender.location(in: mapView)
        let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
        
        // Remove point if tapped nearby
        if let index = locations.firstIndex(where: { distanceBetween($0, coordinate) < 100 }) {
            locations.remove(at: index)
        } else if locations.count < 3 {
            locations.append(coordinate)
            clickCounter += 1 // Increment click counter
        }
        
        updateMap()
    }
    
    func distanceBetween(_ coord1: CLLocationCoordinate2D, _ coord2: CLLocationCoordinate2D) -> CLLocationDistance {
        let loc1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
        let loc2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
        return loc1.distance(from: loc2)
    }
    
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        
        // Add only the three selected pins
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
        }
        
        if locations.count == 3 {
            let polyline = MKPolyline(coordinates: locations, count: locations.count)
            let polygon = MKPolygon(coordinates: locations, count: locations.count)
            mapView.addOverlay(polyline)
            mapView.addOverlay(polygon)
            showDistances()
        }
    }
    
    func showDistances() {
        // Only add annotations for the user-selected points, no extra pins for distances
            for i in 0..<locations.count {
                let start = locations[i]
                let end = locations[(i + 1) % locations.count]
                let distance = distanceBetween(start, end) / 1000
                
                // Annotation only for the clicked points, not for distances
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(
                    latitude: (start.latitude + end.latitude) / 2,
                    longitude: (start.longitude + end.longitude) / 2
                )
                annotation.title = String(format: "%.2f km", distance)
                mapView.addAnnotation(annotation)
            }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .green // This will make the polyline green
                renderer.lineWidth = 3
                return renderer
            } else if let polygon = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygon)
                renderer.fillColor = UIColor.red.withAlphaComponent(0.5)
                return renderer
            }
            return MKOverlayRenderer()
    }
    
    @IBAction func startRouteNavigation(_ sender: UIButton) {
        guard locations.count == 3 else { return }
        
        // Create route from A to B, B to C, and C back to A
        let request1 = MKDirections.Request()
        request1.source = MKMapItem(placemark: MKPlacemark(coordinate: locations[0]))
        request1.destination = MKMapItem(placemark: MKPlacemark(coordinate: locations[1]))
        request1.transportType = .automobile
        
        let request2 = MKDirections.Request()
        request2.source = MKMapItem(placemark: MKPlacemark(coordinate: locations[1]))
        request2.destination = MKMapItem(placemark: MKPlacemark(coordinate: locations[2]))
        request2.transportType = .automobile
        
        let request3 = MKDirections.Request()
        request3.source = MKMapItem(placemark: MKPlacemark(coordinate: locations[2]))
        request3.destination = MKMapItem(placemark: MKPlacemark(coordinate: locations[0]))
        request3.transportType = .automobile
        
        let directions1 = MKDirections(request: request1)
        let directions2 = MKDirections(request: request2)
        let directions3 = MKDirections(request: request3)
        
        // Calculate and display the routes
        directions1.calculate { response, error in
            guard let route = response?.routes.first else { return }
            self.mapView.addOverlay(route.polyline)
        }
        
        directions2.calculate { response, error in
            guard let route = response?.routes.first else { return }
            self.mapView.addOverlay(route.polyline)
        }
        
        directions3.calculate { response, error in
            guard let route = response?.routes.first else { return }
            self.mapView.addOverlay(route.polyline)
        }
    }
}
