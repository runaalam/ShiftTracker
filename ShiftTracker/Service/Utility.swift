//
//  Utility.swift
//  ShiftTracker
//
//  Created by Runa Alam on 19/3/21.
//

import Foundation
import UIKit

struct Utility {
    
    //Get current date and time in "yyyy-MM-dd'T'HH:mm:ssZZZZZ" formate.

    static func getCurrentDateTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter.string(from: Date())
    }
    
    //Get a image from a URL
    static func getRandomImage(from string: String) -> UIImage? {
        //1. Get valid URL
        guard let url = URL(string: string)
            else {
                print("Unable to create URL")
                return nil
        }
     
        var image: UIImage? = nil
        do {
            //2. Get valid data
            let data = try Data(contentsOf: url, options: [])
     
            //3. Make image
            image = UIImage(data: data)
        }
        catch {
            print(error.localizedDescription)
        }
     
        return image
    }

}
