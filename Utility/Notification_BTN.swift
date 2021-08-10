//
//  Notification_BTN.swift
//  Rising Leaders
//
//  Created by apple on 2/19/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class Notification_BTN: UIButton {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(UIImage(named: "Notification"), for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 8.5, left: 5.0, bottom: 8.5, right: 24.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setImage(UIImage(named: "Notification"), for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 8.5, left: 5.0, bottom: 8.5, right: 24.0)
    }
    
}
