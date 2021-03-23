//
//  ViewController.swift
//  ShiftTracker
//
//  Created by Runa Alam on 18/3/21.
//

import UIKit
import MapKit
import CoreLocation
import MagicTimer

protocol ShiftTrackDelegate {
    func addShift()
}

class ShiftTrackViewController: UIViewController, MagicTimerViewDelegate {
    
    @IBOutlet weak var shiftStarButton: UIButton!
    @IBOutlet weak var shiftEndButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timer: MagicTimerView!
    
    let widgetLocation = WidgetLocationManager()
    
    let defaults = UserDefaults.standard
    
  //  var delegate : ShiftTrackDelegate?
    
    enum ShiftStstus: String {
        case start, end
    }
    
    // MARK: - override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMap()
        setTimmer()
       // toggleShiftButton(senderButton: shiftEndButton, otherButton: shiftStarButton)
    }
        
    // MARK: - IBAction
    
    @IBAction func shiftStartButtonPressed(_ sender: Any) {
        actionForShiftStatus(status: ShiftStstus.start)
    }
    
    @IBAction func shiftEndButtonPressed(_ sender: Any) {
        actionForShiftStatus(status: ShiftStstus.end)
    }
    
    //MARK:- Initial setup methods
    func setTimmer(){
        timer.isActiveInBackground = false
        timer.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        timer.mode = .stopWatch
        timer.delegate = self
    }
  
    func setMap(){
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    //Sender button will be disable and other button will be enable
    func toggleShiftButton(senderButton: UIButton, otherButton: UIButton){
        senderButton.isEnabled = false
        otherButton.isEnabled = true
    }
    
    //Start and end Button action
    func actionForShiftStatus(status: ShiftStstus) {
        var url : URL?
        switch status {
        case .start:
            toggleShiftButton(senderButton: shiftStarButton, otherButton: shiftEndButton)
            timer.resetToDefault()
            timer.startCounting()
            url = DeputyApiClient.Endpoints.shiftStart.url
            defaults.set(Constants.Message_Shift_Started, forKey: "Shift")
        case .end:
            toggleShiftButton(senderButton: shiftEndButton, otherButton: shiftStarButton)
            timer.stopCounting()
            url = DeputyApiClient.Endpoints.shiftEnd.url
            defaults.set(Constants.Message_Shift_Ended, forKey: "Shift")
        }
        if url != nil {
            saveShiftRecord(url: url!)
        }
    }
    
    
    //MARK:- Service to connect network api
    
    //Save shift record
    func saveShiftRecord(url: URL) {
        let clStatus = widgetLocation.manager!.authorizationStatus
        
        createShiftDataToSave(authorizationStatus: clStatus, completionHandler: {shift in
            DeputyApiClient.requestForPostShift(shiftUrl: url, shift: shift!, completionHandler: {success, error in
                if success {
                    //delegate!.addShift()
                    print("Susscessfuly saved shift record")
                } else {
                    print(error as Any)
                }
            })
        })
    }
    
    //Prepare data to save
    func createShiftDataToSave(authorizationStatus: CLAuthorizationStatus, completionHandler: @escaping (_ shift : Shift?) -> Void){
        let shiftTime = DateUtility.getCurrentDateTimeString()
        
        switch authorizationStatus {
        case .denied,.restricted:
            let shift = Shift(time: shiftTime)
            completionHandler(shift)
        default:
            widgetLocation.fetchLocation(handler: { location in
                let shift = Shift(time: shiftTime, latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude))
                completionHandler(shift)
            })
        }
    }
}

extension ShiftTrackViewController: CLLocationManagerDelegate, MKMapViewDelegate{
    
    //MARK:- Methods for Mapview
        
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

