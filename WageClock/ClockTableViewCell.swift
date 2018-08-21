//
//  ClockTableViewCell.swift
//  WageClock
//
//  Created by Jonathan Kizer on 8/19/18.
//  Copyright © 2018 Kizer Co. All rights reserved.
//

import UIKit

class ClockTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var clockInTime: UILabel!
    @IBOutlet weak var clockOutTime: UILabel!
    @IBOutlet weak var hourlyWage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
