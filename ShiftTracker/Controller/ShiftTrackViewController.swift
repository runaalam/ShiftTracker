//
//  ViewController.swift
//  ShiftTracker
//
//  Created by Runa Alam on 18/3/21.
//

import UIKit
import MapKit
import CoreLocation

class ShiftTrackViewController: UIViewController, CLLocationManagerDelegate {
    let widgetLocation = WidgetLocationManager()
    
    @IBOutlet weak var shiftStarButton: UIButton!
    @IBOutlet weak var shiftEndButton: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @IBAction func shiftStartButtonPressed(_ sender: Any) {
        let url = DeputyApiClient.Endpoints.shiftStart.url
        saveUserShift(url: url)
    }
    
    @IBAction func shiftEndButtonPressed(_ sender: Any) {
        let url = DeputyApiClient.Endpoints.shiftEnd.url
        saveUserShift(url: url)
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
                shiftLat = String(location.coordinate.latitude)
                shiftLon = String(location.coordinate.longitude)
                let shift = Shift(time: shiftTime, latitude: shiftLat, longitude: shiftLon)
                completionHandler(shift)
            })
        }
    }
}

