//
//  Notifications_TVCell.swift
//  RisingLeader
//
//  Created by apple on 12/23/19.
//  Copyright © 2019 MindCrew. All rights reserved.
//

import UIKit

class Notifications_TVCell: UITableViewCell {

    @IBOutlet weak var Title_LB : UILabel!
    @IBOutlet weak var IMG_IV : UIImageView!
    @IBOutlet weak var Time_LB : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
