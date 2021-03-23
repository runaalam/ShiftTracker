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

class ShiftTrackViewController: UIViewController, MagicTimerViewDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var shiftStarButton: UIButton!
    @IBOutlet weak var shiftEndButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timer: MagicTimerView!
    
    /// initialization for WidgetLocationManager
    let widgetLocation = WidgetLocationManager()
    
    ///enum for shift status
    enum ShiftStatus: String {
        case start, end
    }
    
    // MARK: - override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMap()
        setTimmer()
    }
        
    // MARK: - IBAction
    
    @IBAction func shiftStartButtonPressed(_ sender: Any) {
        actionForShift(status: ShiftStatus.start)
    }
    
    @IBAction func shiftEndButtonPressed(_ sender: Any) {
        actionForShift(status: ShiftStatus.end)
    }
    
    //MARK:- Initial setup methods
    
    ///MagicTimer setup
    func setTimmer(){
        timer.isActiveInBackground = false
        timer.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        timer.mode = .stopWatch
        timer.delegate = self
    }
    
    ///MapView setup
    func setMap(){
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    ///Sender button will be disable and other button will be enable
    /// - Parameter senderButton: UIButton
    /// - Parameter otherButton: UIButton
    func toggleShiftButton(senderButton: UIButton, otherButton: UIButton){
        senderButton.isEnabled = false
        otherButton.isEnabled = true
    }
    
    ///This method updates the view for shift action that includes the toggle button, timer handling. It also calls service method to save in the database
    /// - Parameter status: ShiftStatus
    func actionForShift(status: ShiftStatus) {
        var url : URL?
        switch status {
        case .start:
            toggleShiftButton(senderButton: shiftStarButton, otherButton: shiftEndButton)
            timer.resetToDefault()
            timer.startCounting()
            url = DeputyApiClient.Endpoints.shiftStart.url
        case .end:
            toggleShiftButton(senderButton: shiftEndButton, otherButton: shiftStarButton)
            timer.stopCounting()
            url = DeputyApiClient.Endpoints.shiftEnd.url
        }
        if url != nil {
            saveShiftRecord(url: url!)
        }
    }
    
    
    //MARK:- Service to connect network api
    
    ///Save shift record
    /// - Parameter url: URL
    func saveShiftRecord(url: URL) {
        let clStatus = widgetLocation.manager!.authorizationStatus
        
        createShiftDataToSave(authorizationStatus: clStatus, completionHandler: {shift in
            DeputyApiClient.requestForPostShift(shiftUrl: url, shift: shift!, completionHandler: { [self]success, error in
                if success {
                    print("Susscessfuly saved shift record")
                    updateOtherVc()
                } else {
                    print(error as Any)
                }
            })
        })
    }
     
    ///This method prepare data to save on database, depending on location authorizationStatus. If status is not restricted it calls 'init' method that stores the location attributes and return the model as completionHandler.
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
   
    //Update preview list after added new shift
    func updateOtherVc(){
        let secondTab = self.tabBarController?.viewControllers![1] as! PreviousShiftsViewController
        secondTab.needUpdate = true
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

