//
//  WebLinkImage.swift
//  ShiftTracker
//
//  Created by Runa Alam on 22/3/21.
//

import Foundation
import UIKit

struct DisplayShift {
    let id: Int
    let date: String
    let duration: String
    let url: URL
    var image = UIImage(systemName: "info.circle")
    
    init(id: Int, url: URL, date: String, start: String, end: String){
        self.id = id
        self.url = url
        self.date =  DateUtility.getDate(dateStr: date)
        self.duration = DateUtility.getShiftDuration(start: start, end: end)
        if let data = try? Data(contentsOf: url) {
            self.image = UIImage(data: data)
        }
    }
    
    func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        if let data = try? Data(contentsOf: url) {
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        } else {
            DispatchQueue.main.async {
                completion(UIImage(systemName: "info.circle"))
            }
        }
    }
}
