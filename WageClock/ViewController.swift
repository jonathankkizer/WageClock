//
//  ViewController.swift
//  WageClock
//
//  Created by Jonathan Kizer on 8/19/18.
//  Copyright © 2018 Kizer Co. All rights reserved.
//

import UIKit

class clockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // ALERT & HAPTIC FEEDBACK INITIALIZERS
    var alertController:UIAlertController? = nil
    let notificationImpact = UINotificationFeedbackGenerator()
    
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var outputTableView: UITableView!
    
    // GLOBAL VARIABLES STRUCT
    struct globalVars {
        
        static var workDayArray: [WorkDay] = []
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadWorkDayArray()
        outputTableView.reloadData()
        var salaryText = "\(UserDefaults.standard.float(forKey: "salaryKey"))"
        if salaryText == "nil" {
            salaryText = "1.0"
            salaryTextField.text = salaryText
        } else {
            salaryTextField.text = salaryText
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        outputTableView.dataSource = self
        outputTableView.delegate = self
        outputTableView.rowHeight = 125
        
        // HIDE KEYBOARD CODE
        hideKeyboardWhenTappedAround()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalVars.workDayArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "clockCell", for: indexPath) as! ClockTableViewCell
        
        cell.clockInTime.text = returnTime(dateObject: globalVars.workDayArray[indexPath.row].firstClockIn)
        cell.hourlyWage.text = "\(globalVars.workDayArray[indexPath.row].dayHourlyWage)"
        cell.date.text = "\(globalVars.workDayArray[indexPath.row].workDate)"
        
        
        cell.clockOutTime.text = returnTime(dateObject: globalVars.workDayArray[indexPath.row].finalClockOut)
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    // CLOCK IN BUTTON CODE
    @IBAction func clockIn(_ sender: Any) {
        
        if salaryTextField.text! == "" {
            self.alertController = UIAlertController(title: "No salary entered", message: "Please enter a salary", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            }
            self.alertController!.addAction(OKAction)
            
            notificationImpact.notificationOccurred(.error)
            
            self.present(self.alertController!, animated: true, completion:nil)
        } else {
            
            UserDefaults.standard.set(Float(salaryTextField.text!), forKey: "salaryKey")
            
            for i in globalVars.workDayArray {
                print(i.secsWorked)
            }
            
            let clockInTime = Date()
            
            if (globalVars.workDayArray.count == 0) {
                let floatYearlySalary = Float("\(salaryTextField.text!)")
                let newWorkDayObj = WorkDay(clockIn: clockInTime, yearlySalary: floatYearlySalary!)
                globalVars.workDayArray.append(newWorkDayObj)
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let clockInTimeDate = dateFormatter.string(from: clockInTime)
            for workDay in globalVars.workDayArray {
                if workDay.workDate == clockInTimeDate {
                    print("Current day as same as most recent Work Day")
                    workDay.yearlySalary = Float("\(salaryTextField.text!)")!
                } else {
                    let floatYearlySalary = Float("\(salaryTextField.text!)")
                    let newWorkDayObj = WorkDay(clockIn: clockInTime, yearlySalary: floatYearlySalary!)
                    globalVars.workDayArray.append(newWorkDayObj)
                }
            }
            
            saveWorkDayArray(workDayArray: globalVars.workDayArray)
            
        }
        
        outputTableView.reloadData()
        
    }
    
    // CLOCK OUT BUTTON CODE
    @IBAction func clockOut(_ sender: Any) {
        let clockOutTime = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let clockOutTimeDate = dateFormatter.string(from: clockOutTime)
        
        for workDay in globalVars.workDayArray {
            if workDay.workDate == clockOutTimeDate {
                workDay.finalClockOut = clockOutTime
                workDay.updateWorkDayMethods()
            } else {
                print("HELLO AUSTIN TEXAS")
            }
        }
        
        saveWorkDayArray(workDayArray: globalVars.workDayArray)
        outputTableView.reloadData()
    }
    
    // RETURNS FORMATTED TIME AS STRING FROM DATE OBJECT
    func returnTime(dateObject: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let timeReturn = dateFormatter.string(from: dateObject)
        
        return timeReturn
    }
    
    // SAVES WORK DAY ARRAY TO USERDEFAULTS() BY ENCODING AS JSON OBJECT
    func saveWorkDayArray(workDayArray: [WorkDay]) {
        if let encoded = try? JSONEncoder().encode(workDayArray) {
            UserDefaults.standard.set(encoded, forKey: "currentWorkDayArray")
            print("Saved data...")
        }
    }
    
    // LOADS WORKDAYARRAY FROM USERDEFAULTS
    func loadWorkDayArray() {
        if let userData = UserDefaults.standard.data(forKey: "currentWorkDayArray"),
            let testArray = try? JSONDecoder().decode([WorkDay].self, from: userData) {
            globalVars.workDayArray = testArray
            print("Loaded data...")
        }
    }
}

// DISMISS KEYBOARD CODE
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// ********************************//
/*
 DESIGNABLE CODE -- FOR DESIGNING UIBUTTONS
 */
// ********************************//
@IBDesignable
class DesignableView: UIButton {
    // Corner Radius.
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    //Background Color.
    @IBInspectable var backColor: UIColor? {
        didSet {
            backgroundColor = backColor
        }
    }
    //Border Width.
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    //Border Color.
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
