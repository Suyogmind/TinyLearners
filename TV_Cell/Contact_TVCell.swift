//
//  Contact_TVCell.swift
//  RisingLeader
//
//  Created by apple on 12/30/19.
//  Copyright © 2019 MindCrew. All rights reserved.
//

import UIKit

class Contact_TVCell: UITableViewCell {
    
    @IBOutlet weak var Selected_V : UIView!
    @IBOutlet weak var IMG_IV : UIImageView!
    @IBOutlet weak var Name_LB : UILabel!
    @IBOutlet weak var Info_LB : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
