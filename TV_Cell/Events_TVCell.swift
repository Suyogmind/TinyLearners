//
//  Events_TVCell.swift
//  Rising Leaders
//
//  Created by apple on 2/19/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class Events_TVCell: UITableViewCell {

    @IBOutlet weak var Date_V : UIView!
    @IBOutlet weak var Title_LB : UILabel!
    @IBOutlet weak var Info_LB : UILabel!
    @IBOutlet weak var Date_LB : UILabel!
    @IBOutlet weak var Month_LB : UILabel!
    @IBOutlet weak var Year_LB : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
