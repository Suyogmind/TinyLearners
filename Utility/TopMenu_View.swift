//
//  TopMenu_View.swift
//  Noyo
//
//  Created by Retina on 07/08/18.
//  Copyright © 2018 Pavan. All rights reserved.
//

import UIKit

class TopMenu_View: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = TopMenuBGColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = TopMenuBGColor
    }
}
