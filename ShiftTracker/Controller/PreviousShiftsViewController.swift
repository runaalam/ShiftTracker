//
//  PreviusShiftsViewController.swift
//  ShiftTracker
//
//  Created by Runa Alam on 19/3/21.
//

import UIKit

class PreviousShiftsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {
   
    @IBOutlet weak var tableView: UITableView!
        
    //Array to display shift record in table view
    var displayShifts : [ShiftRecord] = []

    //ActivityIndicator initialization
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    //Flag for list update if other controller adds new data
    var needUpdate = false
    
    //MARK: - UIViewController override methods
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //Method call during loading
        tableViewSetUp()
        setActivityIndicator(view: self.view)
        activateActivityIndicator(value: true)
        loadAllShifts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //if other controller set this value true, then need to update list to load new data
        if needUpdate {
            activateActivityIndicator(value: true)
            loadAllShifts()
            needUpdate = false
        }
    }
    
    //MARK: - Initial setup methods
    
    func tableViewSetUp(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 120
    }
    
    ///Call this function to load all data for ShiftRecord to display in TableView
    func loadAllShifts(){
        DeputyApiClient.requestForGetPreviusShifts(completionHandler: {shifts, error in
            if !shifts!.isEmpty {
                self.displayShifts = shifts!
                DispatchQueue.main.async { [self] in
                    self.tableView.reloadData()
                    activateActivityIndicator(value: false)
                }
            }
        })
    }
    
    //MARK: - Methods for ActivityIndicator
    
    //Set ActivityIndicator to the view
    func setActivityIndicator(view: UIView) {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    /**
    Call this function to activate or deactivate ActivityIndicator
    */
  
    func activateActivityIndicator(value: Bool){
        if value{
            activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
        
    //MARK: - TableViewDelegate methods
    
    //number of section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //number of row for table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayShifts.count
    }
    
    //Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("ShiftRecordTableViewCell", owner: self, options: nil)?.first as! ShiftRecordTableViewCell
        
        cell.shiftDate.text = DateUtility.getDate(dateStr: displayShifts[indexPath.row].start)
        cell.shiftDuration.text = DateUtility.getShiftDuration(start: displayShifts[indexPath.row].start, end: displayShifts[indexPath.row].end)
        cell.shiftImageView.setImageFromUrl(ImageURL: displayShifts[indexPath.row].image)
        
        return cell
    }
}
