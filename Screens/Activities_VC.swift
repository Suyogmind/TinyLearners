//
//  Activities_VC.swift
//  Rising Leaders
//
//  Created by apple on 2/18/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class Activities_VC: UIViewController, CAPSPageMenuDelegate {
    
    @IBOutlet weak var Top_V : UIView!
    
    var pageMenu               : CAPSPageMenu?
    var controller1            : ActivitiesUpcoming_VC!
    var controller2            : ActivitiesCompleted_VC!
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APPDELEGATE.HomeNavi = self.navigationController
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = ScreenBGColor
        
        pageMenu?.delegate = self
        self.capsPaging()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func Notifications_VC_Open(_ sender: UIButton) {
        
        let screen = self.storyboard!.instantiateViewController(withIdentifier: "Notifications_VC") as! Notifications_VC
        self.navigationController?.pushViewController(screen, animated: true);
    }
    
    /**************************************************************************/
    //MARK:- CAPagination /////////////////////////////////
    /**************************************************************************/
    
    func capsPaging() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var controllerArray : [UIViewController] = []
        controller1 = (storyboard.instantiateViewController(withIdentifier: "ActivitiesUpcoming_VC") as! ActivitiesUpcoming_VC)
        controller1.navi = self.navigationController
        controller1.title = "Upcoming"
        
        controller2 = (storyboard.instantiateViewController(withIdentifier: "ActivitiesCompleted_VC") as! ActivitiesCompleted_VC)
        controller2.navi = self.navigationController
        controller2.title = "Completed"
        
        controllerArray.append(controller1)
        controllerArray.append(controller2)
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: (Top_V.frame.origin.y+Top_V.frame.size.height), width: CurrentDevice.ScreenWidth, height: (CurrentDevice.ScreenHeight-(Top_V.frame.origin.y+Top_V.frame.size.height+90.0))), pageMenuOptions: nil)
        pageMenu?.delegate = self
        pageMenu!.view.backgroundColor = hexStringToUIColor(hex: "F7F8FA")
        self.view.addSubview(pageMenu!.view)
        //pageMenu?.moveToPage(intIndex)
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
