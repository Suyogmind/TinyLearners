//
//  App_TV.swift
//  RisingLeader
//
//  Created by apple on 12/31/19.
//  Copyright © 2019 MindCrew. All rights reserved.
//

import UIKit

class App_TV: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 1.0
        
        self.textColor = hexStringToUIColor(hex: "#8780A1")
        self.backgroundColor = UIColor.white
        
        self.layer.borderColor = hexStringToUIColor(hex: "#CFCCD9").cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = hexStringToUIColor(hex: "#CFCCD9").cgColor
        
        self.textColor = hexStringToUIColor(hex: "#8780A1")
        self.backgroundColor = UIColor.white
    }
}
