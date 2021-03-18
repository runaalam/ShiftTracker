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
    let getLocation = GetLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        getLocation.run {
            if let location = $0 {
                print("location = \(location.coordinate.latitude) \(location.coordinate.longitude)")
            } else {
                print("Get Location failed \(self.getLocation.didFailWithError)")
            }
        }
    }
}

