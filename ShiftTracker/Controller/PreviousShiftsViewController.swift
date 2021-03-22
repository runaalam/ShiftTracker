//
//  PreviusShiftsViewController.swift
//  ShiftTracker
//
//  Created by Runa Alam on 19/3/21.
//

import UIKit

class PreviousShiftsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    
//    private var previousShiftsVM : PreviousShiftsViewModel!
    
    var shifts : PreviousShifts = []
    var webLinkImages : [WebLinkImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetUp()
        self.loadAllPreviousShifts()
    }
    
    func tableViewSetUp(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 120
    }
    
    func loadAllPreviousShifts(){
        DeputyApiClient.requestForGetPreviusShifts(completionHandler: {[self]shifts, error in
                if !shifts!.isEmpty {
                    self.shifts = shifts!
                    DispatchQueue.main.async {
                        loadWebLinkImage()
                        self.tableView.reloadData()
                    }
                }
        })
    }
    
    func loadWebLinkImage(){
        for shift in shifts {
            let webImage = WebLinkImage(id: shift.id, url: URL(string: shift.image)!)
            webLinkImages.append(webImage)
        }
    }
    
    //MARK: - TableViewDelegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ShiftRecordTableViewCell", owner: self, options: nil)?.first as! ShiftRecordTableViewCell
        
        cell.shiftDate!.text = DateUtility.getDate(dateStr: shifts[indexPath.row].start)
        cell.shiftDuration!.text = DateUtility.getShiftDuration(start: shifts[indexPath.row].start, end: shifts[indexPath.row].end)
        let  webImage : WebLinkImage = webLinkImages[indexPath.row]
        cell.shiftImageView.image = webImage.image
        
        return cell
    }
}
