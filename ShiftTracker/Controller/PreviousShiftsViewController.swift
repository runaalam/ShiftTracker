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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        loadALLPreviousShifts()
    }
    
    func loadALLPreviousShifts(){
        DeputyApiClient.requestForGetPreviusShifts(completionHandler: {[self]shifts, error in
                if !shifts!.isEmpty {
                    self.shifts = shifts!
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
        })
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
        
        cell.shiftDate!.text = self.getDate(dateStr: shifts[indexPath.row].start)
        cell.shiftDuration!.text = self.getShiftDuration(start: shifts[indexPath.row].start, end: shifts[indexPath.row].end)
        return cell
    }
    
    //
    func getDate(dateStr: String)-> String {
        Utility.getDateFromISO8601(string: dateStr, formate: Constants.Formate_Shift_Date)
    }
    
    func getShiftDuration(start:String, end:String)-> String{
        let duration = "Worked:  " + Utility.getDateFromISO8601(string: start, formate: Constants.Formate_Shift_Time) + " - " + Utility.getDateFromISO8601(string: end, formate: Constants.Formate_Shift_Time)
        return duration
    }
}
