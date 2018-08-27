//
//  workDayTableViewController.swift
//  WageClock
//
//  Created by Jonathan Kizer on 8/26/18.
//  Copyright © 2018 Kizer Co. All rights reserved.
//

/*import UIKit

class workDayTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var outputTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        outputTableView.dataSource = self
        outputTableView.delegate = self
        
        outputTableView.rowHeight = 125


    }
    
    override func viewWillAppear(_ animated: Bool) {
        outputTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clockViewController.globalVars.workDayArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "clockCell", for: indexPath) as! ClockTableViewCell
        
        cell.clockInTime.text = returnTime(dateObject: clockViewController.globalVars.workDayArray[indexPath.row].firstClockIn)
        cell.hourlyWage.text = "\(clockViewController.globalVars.workDayArray[indexPath.row].dayHourlyWage)"
        cell.date.text = "\(clockViewController.globalVars.workDayArray[indexPath.row].workDate)"
        
        
        cell.clockOutTime.text = returnTime(dateObject: clockViewController.globalVars.workDayArray[indexPath.row].finalClockOut)
        cell.selectionStyle = .none
        
        return cell
    }
    
}

// RETURNS FORMATTED TIME AS STRING FROM DATE OBJECT
func returnTime(dateObject: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm"
    let timeReturn = dateFormatter.string(from: dateObject)
    
    return timeReturn
}
*/
