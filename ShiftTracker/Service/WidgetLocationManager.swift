//
//  GetLocation.swift
//  ShiftTracker
//
//  Created by Runa Alam on 18/3/21.
//

import Foundation
import CoreLocation

class WidgetLocationManager: NSObject, CLLocationManagerDelegate {
    var manager: CLLocationManager?
    private var handler: ((CLLocation) -> Void)?
 
    override init() {
        super.init()
        DispatchQueue.main.async {
            self.manager = CLLocationManager()
            self.manager!.delegate = self
            if self.manager!.authorizationStatus == .notDetermined {
                self.manager!.requestWhenInUseAuthorization()
            }
        }
    }
    
    func fetchLocation(handler: @escaping (_ location : CLLocation) -> Void) {
        self.handler = handler
        self.manager!.requestLocation()
    }
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.handler!(locations.last!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

