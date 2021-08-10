//
//  App_BTN.swift
//  Noyo
//
//  Created by Retina on 20/08/18.
//  Copyright © 2018 Pavan. All rights reserved.
//

import UIKit

class App_BTN: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        self.backgroundColor = hexStringToUIColor(hex: "#2D31AC")
        layer.cornerRadius = 4.0
        layer.masksToBounds = false
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        self.backgroundColor = hexStringToUIColor(hex: "#2D31AC")
        layer.cornerRadius = 4.0
        layer.masksToBounds = false
        self.setTitleColor(UIColor.white, for: .normal)
    }
}
