//
//  ViewController.swift
//  ShiftTracker
//
//  Created by Runa Alam on 18/3/21.
//

import UIKit
import MapKit
import CoreLocation

class ShiftTrackViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    let widgetLocation = WidgetLocationManager()
    
    @IBOutlet weak var shiftStarButton: UIButton!
    @IBOutlet weak var shiftEndButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        toggleShiftButton(senderButton: shiftEndButton, otherButton: shiftStarButton)
    }
        
    @IBAction func shiftStartButtonPressed(_ sender: Any) {
        toggleShiftButton(senderButton: shiftStarButton, otherButton: shiftEndButton)
        let url = DeputyApiClient.Endpoints.shiftStart.url
        saveUserShift(url: url)
    }
    
    @IBAction func shiftEndButtonPressed(_ sender: Any) {
        toggleShiftButton(senderButton: shiftEndButton, otherButton: shiftStarButton)
        let url = DeputyApiClient.Endpoints.shiftEnd.url
        saveUserShift(url: url)
    }
    
    func toggleShiftButton(senderButton: UIButton, otherButton: UIButton){
        senderButton.isEnabled = false
        otherButton.isEnabled = true
    }
    
    func saveUserShift(url: URL) {
        createUserShiftRecord(completionHandler: {shift in
            DeputyApiClient.requestForPostShift(shiftUrl: url, shift: shift!, completionHandler: {success, error in
                if success {
                    print("Susscessfuly saved")
                }
            })
        })
    }
    
    func createUserShiftRecord(completionHandler: @escaping (_ shift : Shift?) -> Void){
        let shiftTime = Utility.getCurrentDateTimeString()
        var shiftLat = "0.00000"
        var  shiftLon = "0.00000"
        
        if widgetLocation.manager!.authorizationStatus == .denied || widgetLocation.manager!.authorizationStatus == .restricted {
            let shift = Shift(time: shiftTime, latitude: shiftLat, longitude: shiftLon)
            completionHandler(shift)
        } else {
            
            widgetLocation.fetchLocation(handler: { location in
                self.addAnotationToMap(location: location)
                shiftLat = String(location.coordinate.latitude)
                shiftLon = String(location.coordinate.longitude)
                let shift = Shift(time: shiftTime, latitude: shiftLat, longitude: shiftLon)
                completionHandler(shift)
            })
        }
    }
    
    func addAnotationToMap(location: CLLocation){
        let annotations = MKPointAnnotation()
        annotations.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        self.mapView.addAnnotation(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.pinTintColor = .red
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
        }
}

