//
//  PreviusShiftsViewController.swift
//  ShiftTracker
//
//  Created by Runa Alam on 19/3/21.
//

import UIKit

class PreviousShiftsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
        
    var displayShifts : [ShiftRecordViewModel] = []
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetUp()
        setActivityIndicator(view: self.view)
        activateActivityIndicator(value: true)
        loadAllShifts()
    }
    
    func tableViewSetUp(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 120
    }
    
    func setActivityIndicator(view: UIView) {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func activateActivityIndicator(value: Bool){
        if value{
            activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func loadAllShifts(){
        DeputyApiClient.requestForGetPreviusShifts(completionHandler: {[self] displayShifts, error in
            if !displayShifts!.isEmpty {
                self.displayShifts = displayShifts!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    activateActivityIndicator(value: false)
                }
            }
        })
    }
    
    //MARK: - TableViewDelegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayShifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ShiftRecordTableViewCell", owner: self, options: nil)?.first as! ShiftRecordTableViewCell
        
        cell.shiftDate!.text = displayShifts[indexPath.row].date
        cell.shiftDuration!.text = displayShifts[indexPath.row].duration
        cell.shiftImageView.image = displayShifts[indexPath.row].image
        return cell
    }
}
