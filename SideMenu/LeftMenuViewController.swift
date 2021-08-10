//
//  LeftMenuViewController.swift
//  Demo_sidemenu
//
//  Created by Er. Deepak  on 21/10/19.
//  Copyright © 2019 mac book. All rights reserved.
//

import UIKit
import SDWebImage

class LeftMenuViewController:UIViewController {

    @IBOutlet weak var Profile_IV: UIImageView!
    @IBOutlet weak var Name_LB: UILabel!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ScreenBGColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Profile_IV.layer.cornerRadius = 42.0
        Profile_IV.clipsToBounds = true
        
        if let dict: NSDictionary = UserDefaults.standard.value(forKey: "kidDetails") as? NSDictionary {
            
            Name_LB.text = dict.GotValue(key: "kid_name") as String
            Name_LB.adjustsFontSizeToFitWidth = true
            
            Profile_IV.backgroundColor = hexStringToUIColor(hex: "#2D31AC")
            Profile_IV.sd_setShowActivityIndicatorView(true)
            Profile_IV.sd_setIndicatorStyle(.gray)
            Profile_IV?.sd_setImage(with: NSURL(string:((dict.GotValue(key: "profile_pic") as String)))! as URL) { (image, error, cache, urls) in
                if (error != nil) {
                    self.Profile_IV.image = UIImage(named: "SideMenuProfile")
                } else {
                    self.Profile_IV.image = image
                }
            }
        }
    }
    
    @IBAction func Close_btn_action(_ sender: Any) {
        
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func Dashboard_Open(_ sender: Any) {
        
        NotificationCenter.default.post(name: .Select_Dashboard, object: nil)
        
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func Profile_Open(_ sender: Any) {
        
        NotificationCenter.default.post(name: .Select_Profile, object: nil)
        
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func Announcements_VC_Open(_ sender: Any) {

        let screen = self.storyboard!.instantiateViewController(withIdentifier: "Announcements_VC") as! Announcements_VC
        APPDELEGATE.HomeNavi?.pushViewController(screen, animated: true);
        
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func ChangePassword_VC_Open(_ sender: Any) {
     
        let screen = self.storyboard!.instantiateViewController(withIdentifier: "ChangePassword_VC") as! ChangePassword_VC
        APPDELEGATE.HomeNavi?.pushViewController(screen, animated: true);
        
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func Events_VC_Open(_ sender: Any) {
        
        let screen = self.storyboard!.instantiateViewController(withIdentifier: "Events_VC") as! Events_VC
        APPDELEGATE.HomeNavi?.pushViewController(screen, animated: true);

        self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func Attendance_VC_Open(_ sender: Any) {
        
        let screen = self.storyboard!.instantiateViewController(withIdentifier: "Attendance_VC") as! Attendance_VC
        APPDELEGATE.HomeNavi?.pushViewController(screen, animated: true);
        
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    @IBAction func LogOut(_ sender: Any) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("Are you sure you want to logout?", comment: ""), message: "", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: .cancel) { action -> Void in
            //Do your task
        }
        actionSheetController.addAction(cancelAction)
        
        let nextAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: .default) { action -> Void in
            
            UserDefaults.standard.set(nil, forKey: "kidDetails")
            UserDefaults.standard.set("", forKey: "user_id")
            UserDefaults.standard.synchronize()
            
            if #available(iOS 13.0, *) {

                let rootNavi = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "root") as! UINavigationController
                rootNavi.isNavigationBarHidden = true
                let window = UIApplication.shared.windows.first;
                window?.rootViewController = rootNavi;
                
            } else {

                let rootNavi = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "root") as! UINavigationController
                rootNavi.isNavigationBarHidden = true
                APPDELEGATE.window?.rootViewController = rootNavi
            }
            
        }
        actionSheetController.addAction(nextAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func ContactUs_Open(_ sender: Any) {
    
        let screen = self.storyboard!.instantiateViewController(withIdentifier: "Web_VC") as! Web_VC
        screen.ScreenTitle_STR = "Contact Us"
        screen.URL_STR = "http://18.222.48.241/career.html"
        APPDELEGATE.HomeNavi?.pushViewController(screen, animated: true);
        
        self.sideMenuViewController!.hideMenuViewController()
    }
    
    // MARK: - <UITableViewDelegate>
    // MARK: - Tableview protocol
    /*
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return 54
     }
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
         return 1
     }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrayofMenu.count;
     }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LeftmenuTableViewCell
    
        cell.name_lbl?.text = arrayofMenu[indexPath.row]
        cell.backgroundColor = .clear
        cell.name_lbl?.textColor = .white
        cell.name_lbl?.highlightedTextColor = .lightGray
        if indexPath.row == 1{
            cell.lblchatcount.layer.cornerRadius = cell.lblchatcount.frame.size.width / 2
            cell.lblchatcount.clipsToBounds = true
            cell.lblchatcount.isHidden = true
            cell.logout_image.isHidden = true
        }else if indexPath.row == 8{
            cell.logout_image.isHidden = false
            cell.lblchatcount.isHidden = true
            
        }else {
            cell.logout_image.isHidden = true
            cell.lblchatcount.isHidden = true
        }
      
        
        
        return cell
     }

     public func tableView(tableView: UITableViewDelegate, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        

     }
     // MARK: - UITableView delegates
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       switch(indexPath.row)
         {
         
         case 0:

            self.sideMenuViewController!.hideMenuViewController()
         
           
             break
         case 1:
            
             break
         case 2:
            
             break
         case 3:
            
             break
         case 4:
            
             break
        
         case 5:
             
             
             break
         case 6:
             
             break
         case 7:
             
             break
         case 8:
            self.view.isUserInteractionEnabled = true
            let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("Are you sure you want to logout?", comment: ""), message: "", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("NO", comment: ""), style: .cancel) { action -> Void in
                //Do your task
            }
            actionSheetController.addAction(cancelAction)
            
            let nextAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("YES", comment: ""), style: .default) { action -> Void in
                UserDefaults.standard.removeObject(forKey:"LOGIN")
                UserDefaults.standard.removeObject(forKey:"email")
                UserDefaults.standard.removeObject(forKey:"userImage")
                UserDefaults.standard.removeObject(forKey:"address")
                UserDefaults.standard.removeObject(forKey:"phone")
                UserDefaults.standard.removeObject(forKey:"fullname")
                UserDefaults.standard.removeObject(forKey:"userid")
                UserDefaults.standard.removeObject(forKey:"reffralcode")
                if #available(iOS 13.0, *) {
                    let testController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "logout") as! UINavigationController
                    testController.isNavigationBarHidden = true
                    let window = UIApplication.shared.windows.first;
                    window?.rootViewController = testController;
                }else {
                    let testController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "logout") as! UINavigationController
                    testController.isNavigationBarHidden = true
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = testController
                }
                      
              
  
              
            }
            actionSheetController.addAction(nextAction)
            self.present(actionSheetController, animated: true, completion: nil)
          break
         default:
             break
         }
    }*/

//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        switch indexPath.row {
//        case 0:
//            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "HomePage_VC")), animated: true)
//            self.sideMenuViewController!.hideMenuViewController()
//
//        case 1:
////            self.sideMenuViewController!.setContentViewController(UINavigationController(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "secondViewController")), animated: true)
////            self.sideMenuViewController!.hideMenuViewController()
//
//            let viewController = SecondViewController()
//            viewController.title = "Pushed Controller"
//            viewController.view.backgroundColor = .white
//            self.navigationController?.pushViewController(viewController, animated: true)
//
////            let next_VC = self.storyboard?.instantiateViewController(withIdentifier: "secondViewController") as! secondViewController
////            self.navigationController?.pushViewController(next_VC, animated: true)
//        default:
//            break
//        }
//    }
//
//    // MARK: - <UITableViewDataSource>
//
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 54
//    }
//
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
//        return 6
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellIdentifier: String = "Cell"
//
//        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
//
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
//            cell!.backgroundColor = .clear
//            cell!.textLabel?.font = UIFont(name: "HelveticaNeue", size: 21)
//            cell!.textLabel?.textColor = .white
//            cell!.textLabel?.highlightedTextColor = .lightGray
//            cell!.selectedBackgroundView = UIView()
//
//        }
//
//        var titles = ["Home", "Inbox", "Favorites", "Profile", "More", "Settings"]
//        var images = ["IconHome", "IconCalendar", "IconProfile", "IconProfile", "IconProfile","IconProfile"]
//        cell!.textLabel?.text = titles[indexPath.row]
//        cell!.imageView?.image = UIImage(named: images[indexPath.row])
//
//        return cell!
//    }
}
