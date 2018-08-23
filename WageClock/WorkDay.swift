//
//  WorkDay.swift
//  WageClock
//
//  Created by Jonathan Kizer on 8/22/18.
//  Copyright © 2018 Kizer Co. All rights reserved.
//

import Foundation

class WorkDay {
    
    var firstClockIn: Date
    var finalClockOut: Date
    var secsWorked: Int
    var dayHourlyWage: Float
    var yearlySalary: Float
    var workDate: String
    
    init(clockIn: Date, yearlySalary: Float) {
        self.firstClockIn = clockIn
        self.secsWorked = 0
        self.finalClockOut = clockIn
        self.dayHourlyWage = 0.0
        self.yearlySalary = yearlySalary
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        self.workDate = dateFormatter.string(from: clockIn)
        
    }
    
    func updateSecsWorked() {
        secsWorked = Int(finalClockOut.timeIntervalSinceReferenceDate - firstClockIn.timeIntervalSinceReferenceDate)
    }
    
    func updateFinalClockOut(clockOut: Date) {
        finalClockOut = clockOut
        updateSecsWorked()
    }
    
    func updateDayHourlyWage() {
        dayHourlyWage = (yearlySalary / 260.0) / ((Float(secsWorked)/60)/60)
    }
    
    func updateWorkDayMethods() {
        updateSecsWorked()
        updateDayHourlyWage()
    }
    
}
