//
//  ViewController.swift
//  WageClock
//
//  Created by Jonathan Kizer on 8/19/18.
//  Copyright © 2018 Kizer Co. All rights reserved.
//

import UIKit
import Charts

class clockViewController: UIViewController {
    
    // INITIALIZE UI ELEMENTS
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var salaryTextField: UITextField!
    
    // ALERT & HAPTIC FEEDBACK INITIALIZERS
    var alertController:UIAlertController? = nil
    let notificationImpact = UINotificationFeedbackGenerator()
    
    // GLOBAL VARIABLES STRUCT
    struct globalVars {
        
        static var workDayArray: [WorkDay] = []
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadWorkDayArray()
        var salaryText = "\(UserDefaults.standard.float(forKey: "salaryKey"))"
        if salaryText == "nil" {
            salaryText = "1.0"
            salaryTextField.text = salaryText
        } else {
            salaryTextField.text = salaryText
        }
        
        barChartUpdate()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // HIDE KEYBOARD CODE
        hideKeyboardWhenTappedAround()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // CONFIGURE BARCHARTVIEW DATA AND UPDATE CHART VIEW
    func barChartUpdate() {
        var xValue = 1.0
        var barEntryArray: [BarChartDataEntry] = []
        for item in globalVars.workDayArray {
            let barChartEntry = BarChartDataEntry(x:  xValue, y: Double(item.dayHourlyWage))
            xValue += 1.0
            barEntryArray.append(barChartEntry)
        }
        
        // DATA FORMATTING
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        let dataformatter = DefaultValueFormatter(formatter: numberFormatter)
        let axisFormatter = DefaultAxisValueFormatter(formatter: numberFormatter)
        
        // ADDING TO CHART DATA SET
        let barChartDataSet = BarChartDataSet(values: barEntryArray, label: "Hourly Wage by Day")
        barChartDataSet.valueFormatter = dataformatter
        barChartDataSet.colors = [UIColor(red:0.07, green:0.32, blue:0.64, alpha:1.0)]
        barChartDataSet.highlightColor = UIColor(red:0.07, green:0.32, blue:0.64, alpha:1.0)
        barChartDataSet.drawValuesEnabled = false
        let barChartData = BarChartData(dataSets: [barChartDataSet])
        
        barChartView.data = barChartData
        
        // VISUAL CONFIGURATION
        barChartView.leftAxis.valueFormatter = axisFormatter
        barChartView.chartDescription?.text = ""
        barChartView.xAxis.enabled = false
        barChartView.rightAxis.enabled = false
        
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        
        barChartView.legend.enabled = false
        
        barChartView.leftAxis.labelTextColor = UIColor(red:0.07, green:0.32, blue:0.64, alpha:1.0)
        barChartView.drawValueAboveBarEnabled = true
        barChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 16)
        
        // SCROLLING BEHAVIOR
        // need to configure so that it scrolls; also make sure that the view is not zoomed in and the width of the bars is smaller
        
        
        barChartView.backgroundColor = UIColor(red:1.00, green:0.83, blue:0.39, alpha:1.0)
        
        
        
        
        
        
        barChartView.notifyDataSetChanged()
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
        
        barChartUpdate()
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
