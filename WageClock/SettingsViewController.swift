//
//  SettingsViewController.swift
//  WageClock
//
//  Created by Jonathan Kizer on 8/23/18.
//  Copyright © 2018 Kizer Co. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBAction func clearButton(_ sender: Any) {
        let blankWorkDayArray: [WorkDay] = []
        
        if let encoded = try? JSONEncoder().encode(blankWorkDayArray) {
            UserDefaults.standard.set(encoded, forKey: "currentWorkDayArray")
            print("Cleared previous WorkDay array...")
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
