//
//  Activities_TVCell.swift
//  RisingLeader
//
//  Created by apple on 12/26/19.
//  Copyright © 2019 MindCrew. All rights reserved.
//

import UIKit

class Activities_TVCell: UITableViewCell {

    @IBOutlet weak var Dot_V : UIView!
    
    @IBOutlet weak var Title_LB : UILabel!
    @IBOutlet weak var Time_LB : UILabel!
    
    @IBOutlet weak var PerformanceResultBG_V : UIView!
    @IBOutlet weak var PerformanceResult_V : UIView!
    @IBOutlet weak var PerformanceResult_LB : UILabel!
    @IBOutlet weak var PerformanceResult_IV : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
