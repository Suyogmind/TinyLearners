//
//  Attendance_TVCell.swift
//  Rising Leaders
//
//  Created by apple on 2/19/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class Attendance_TVCell: UITableViewCell {

    @IBOutlet weak var check_in_LB : UILabel!
    @IBOutlet weak var check_out_LB : UILabel!
    @IBOutlet weak var day_LB : UILabel!
    @IBOutlet weak var date_LB : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
