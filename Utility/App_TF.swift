//
//  App_TF.swift
//  RunEarn
//
//  Created by apple on 3/4/19.
//  Copyright © 2019 MindCrew. All rights reserved.
//

import UIKit

class App_TF: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 1.0
        
        self.textColor = hexStringToUIColor(hex: "#100043")
        self.backgroundColor = UIColor.white
        
        self.layer.borderColor = hexStringToUIColor(hex: "#CFCCD9").cgColor
        
        let Left_V = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: self.frame.size.height))
        self.leftView = Left_V
        self.leftViewMode = .always
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     
        self.font = UIFont.systemFont(ofSize: 16.0)
        self.layer.cornerRadius = 4.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = hexStringToUIColor(hex: "#CFCCD9").cgColor
        
        self.textColor = hexStringToUIColor(hex: "#100043")
        self.backgroundColor = UIColor.white
        
        let Left_V = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: self.frame.size.height))
        self.leftView = Left_V
        self.leftViewMode = .always
    }
}
