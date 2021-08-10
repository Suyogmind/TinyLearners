//
//  Menu_BTN.swift
//  Rising Leaders
//
//  Created by apple on 2/19/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class Menu_BTN: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(UIImage(named: "Menu"), for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 14.5, left: 24, bottom: 14.5, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setImage(UIImage(named: "Menu"), for: .normal)
        self.contentEdgeInsets =  UIEdgeInsets(top: 14.5, left: 24, bottom: 14.5, right: 0)
    }
    
}
