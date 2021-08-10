//
//  Root_VC.swift
//  Demo_sidemenu
//
//  Created by Er. Deepak  on 21/10/19.
//  Copyright © 2019 mac book. All rights reserved.
//

import UIKit
import AKSideMenu

class Root_VC: AKSideMenu, AKSideMenuDelegate {
    
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        // Do any additional setup after loading the view.
    //    }
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.menuPreferredStatusBarStyle = .lightContent
        self.contentViewShadowColor = .black
        self.contentViewShadowOffset = CGSize(width: 0, height: 0)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        
        self.backgroundImage = UIImage(named: "Stars")
        self.delegate = self
        self.sideMenuViewController?.panGestureEnabled = true
        
        
        if let storyboard = self.storyboard {
            
            self.contentViewController = storyboard.instantiateViewController(withIdentifier: "contentViewController")
            self.leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "leftMenuViewController")
            //self.rightMenuViewController = storyboard.instantiateViewController(withIdentifier: "rightMenuViewController")
        }
    }
}

// MARK: - <AKSideMenuDelegate>

public func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
    print("willShowMenuViewController")
}

public func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
    print("didShowMenuViewController")
}

public func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
    print("willHideMenuViewController")
}

public func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
    print("didHideMenuViewController")
}

