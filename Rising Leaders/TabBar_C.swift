//
//  TabBar_C.swift
//  Rising Leaders
//
//  Created by apple on 2/19/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

extension Notification.Name{
    static let Select_Dashboard = Notification.Name("Select_Dashboard")
}

extension Notification.Name{
    static let Select_Profile = Notification.Name("Select_Profile")
}

class TabBar_C: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.selectedIndex = 2
        
        NotificationCenter.default.addObserver(self, selector: #selector(SelectDashboard), name: .Select_Dashboard, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SelectProfile), name: .Select_Profile, object: nil)
    }
    
    @objc func SelectDashboard() {
        
        self.selectedIndex = 2
    }
    
    @objc func SelectProfile() {
        
        self.selectedIndex = 4
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
