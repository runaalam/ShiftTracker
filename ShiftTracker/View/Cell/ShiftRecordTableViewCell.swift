//
//  ShiftRecordTableViewCell.swift
//  ShiftTracker
//
//  Created by Runa Alam on 21/3/21.
//

import UIKit

class ShiftRecordTableViewCell: UITableViewCell {

  
    @IBOutlet weak var randomImage: UIImageView!
    @IBOutlet weak var shiftDate: UILabel!
    @IBOutlet weak var shiftDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
