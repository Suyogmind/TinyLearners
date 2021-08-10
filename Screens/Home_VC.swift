//
//  Home_VC.swift
//  Rising Leaders
//
//  Created by apple on 2/18/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class Home_VC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, businessLogicLayerDelegate {

    @IBOutlet weak var Scroll_SV : UIScrollView!
    
    @IBOutlet weak var Card_V : UIView!
    @IBOutlet weak var CardBG_IV : UIImageView!
    
    @IBOutlet weak var PerformanceResultBG_V : UIView!
    @IBOutlet weak var PerformanceResult_V : UIView!
    @IBOutlet weak var PerformanceResult_LB : UILabel!
    @IBOutlet weak var PerformanceResult_IV : UIImageView!
    
    @IBOutlet weak var WeeklyAttendance_CV : UICollectionView!
    @IBOutlet weak var Announcements_CV : UICollectionView!
    
    @IBOutlet weak var Announcements_BG_V : UIView!
    
    @IBOutlet weak var CompleteActivities_LB : UILabel!
    @IBOutlet weak var PendingActivities_LB : UILabel!
    
    @IBOutlet weak var AnnouncementsTitle_LB: UILabel!
    
    var WeeklyAttendance_JsonArray : NSMutableArray = NSMutableArray()
    var Announcements_JsonArray : NSMutableArray = NSMutableArray()
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APPDELEGATE.HomeNavi = self.navigationController
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Scroll_SV.contentSize = CGSize(width: CurrentDevice.ScreenWidth, height: (Announcements_BG_V.frame.origin.y+Announcements_BG_V.frame.size.height+20))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("--CurrentDevice.ScreenWidth--\(CurrentDevice.ScreenWidth)")
        
        HalperBL.delegate = self
        
        Card_V.clipsToBounds = true
        
        self.view.backgroundColor = ScreenBGColor
        
        WeeklyAttendance_CV.tag = 101;
        WeeklyAttendance_CV.delegate = self
        WeeklyAttendance_CV.dataSource = self
        WeeklyAttendance_CV.register(UINib(nibName: "WeeklyAttendance_CVCell", bundle: nil), forCellWithReuseIdentifier: "WeeklyAttendance_CVCell")
        WeeklyAttendance_CV.reloadData()
        
        Announcements_CV.tag = 102;
        Announcements_CV.delegate = self
        Announcements_CV.dataSource = self
        Announcements_CV.register(UINib(nibName: "Announcements_CVCell", bundle: nil), forCellWithReuseIdentifier: "Announcements_CVCell")
        Announcements_CV.reloadData()
        
        ShowPerformanceResult()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        CompleteActivities_LB.text = ""
        PendingActivities_LB.text = ""
        
        WeeklyAttendance_JsonArray = NSMutableArray()
        Announcements_JsonArray = NSMutableArray()
        
        WeeklyAttendance_CV.reloadData()
        
        AnnouncementsTitle_LB.isHidden = true
        
        dashboard_InvokeAPI()
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- dashboard
    /**************************************************************************/
    
    func dashboard_InvokeAPI() {
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available.", controller: self)
        } else {
            
            let user_id: String = UserDefaults.standard.string(forKey: "user_id") ?? ""
            
            let localParameter = [
            "kid_id": user_id,
            "user_type": 1,
            "device_type" : "ios",
            ] as [String : Any]
            
            let Parameter = ["data": localParameter]
            
            showActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
            HalperBL.dashboardAPICall(Parameter)
            
            return
        }
    }
    
    func dashboardAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
        
        let JsonDict: NSDictionary = NSDictionary(dictionary: (dict.value(forKey: "data") as! NSDictionary))
        
        WeeklyAttendance_JsonArray = NSMutableArray(array: (JsonDict.value(forKey: "attendance") as! NSArray))
        Announcements_JsonArray = NSMutableArray(array: (JsonDict.value(forKey: "announcement") as! NSArray))
        
        if Announcements_JsonArray.count > 0 {
            AnnouncementsTitle_LB.isHidden = false
        }
        
        let activitiesDict: NSDictionary = NSDictionary(dictionary: (JsonDict.value(forKey: "activities") as! NSDictionary))
        
        CompleteActivities_LB.text = (activitiesDict.GotValue(key: "complete") as String)
        PendingActivities_LB.text = (activitiesDict.GotValue(key: "pending") as String)
        
        WeeklyAttendance_CV.reloadData()
        Announcements_CV.reloadData()
    }
    
    func dashboardAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
        
        Toast.show(message: massge, controller: self)
        
        WeeklyAttendance_JsonArray = NSMutableArray()
        WeeklyAttendance_CV.reloadData()
        
        Announcements_JsonArray = NSMutableArray()
        Announcements_CV.reloadData()
    }
    
    func dashboardAPICallError(_ error: Error) {
        hideActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
        
        Toast.show(message: "Something went wrong. Please try again!", controller: self)
        
        WeeklyAttendance_JsonArray = NSMutableArray()
        WeeklyAttendance_CV.reloadData()
        
        Announcements_JsonArray = NSMutableArray()
        Announcements_CV.reloadData()
    }
    
    func ShowPerformanceResult() {
        
        PerformanceResultBG_V.isHidden = true
        
        PerformanceResultBG_V.backgroundColor = .clear
        PerformanceResult_V.backgroundColor = .clear
        
        //------------- Excellent
        
        PerformanceResult_LB.text = "Excellent"
        PerformanceResult_IV.image = UIImage(named: "ExcellentIcon")
        
        let gradient = CAGradientLayer()
        gradient.frame = PerformanceResult_V.bounds
        gradient.cornerRadius = 10.0
        gradient.colors = [hexStringToUIColor(hex: "#FF9870"), hexStringToUIColor(hex: "#F46767")].map { $0.cgColor}
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        PerformanceResult_V.layer.insertSublayer(gradient, at: 1)
        
        /*
        if (dict.GotValue(key: "performace_grade") as String) == "Excellent" {
        
            cell.PerformanceResultBG_V.isHidden = false
            
            //------------- Excellent
            
            cell.PerformanceResult_LB.text = "Excellent"
            cell.PerformanceResult_IV.image = UIImage(named: "ExcellentIcon")
            
            let gradient = CAGradientLayer()
            gradient.frame = cell.PerformanceResult_V.bounds
            gradient.cornerRadius = 10.0
            gradient.colors = [hexStringToUIColor(hex: "#FF9870"), hexStringToUIColor(hex: "#F46767")].map { $0.cgColor}
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            cell.PerformanceResult_V.layer.insertSublayer(gradient, at: 1)
        } else if (dict.GotValue(key: "performace_grade") as String) == "GoodJob" {
            
            cell.PerformanceResultBG_V.isHidden = false
            
            //------------- Good Job
            
            cell.PerformanceResult_LB.text = "Good Job"
            cell.PerformanceResult_IV.image = UIImage(named: "GoodJob")
            
            cell.PerformanceResult_V.layer.cornerRadius = 10.0
            let gradient = CAGradientLayer()
            gradient.cornerRadius = 10.0
            gradient.frame = cell.PerformanceResult_V.bounds
            gradient.colors = [hexStringToUIColor(hex: "#5BAFE0"), hexStringToUIColor(hex: "#5BAFE0")].map { $0.cgColor}
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            cell.PerformanceResult_V.layer.insertSublayer(gradient, at: 1)
            
        } else if (dict.GotValue(key: "performace_grade") as String) == "GreatJob" {
            
            cell.PerformanceResultBG_V.isHidden = false
            
            //------------- Great Job
            
            cell.PerformanceResult_LB.text = "Great Job"
            cell.PerformanceResult_IV.image = UIImage(named: "GreatJob")
            
            cell.PerformanceResult_V.layer.cornerRadius = 10.0
            let gradient = CAGradientLayer()
            gradient.cornerRadius = 10.0
            gradient.frame = cell.PerformanceResult_V.bounds
            gradient.colors = [hexStringToUIColor(hex: "#5BAFE0"), hexStringToUIColor(hex: "#373AAF")].map { $0.cgColor}
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            cell.PerformanceResult_V.layer.insertSublayer(gradient, at: 1)
        } else if (dict.GotValue(key: "performace_grade") as String) == "HelpNeeded" {
            
            cell.PerformanceResultBG_V.isHidden = false
            
            //------------- Help Needed
            
            cell.PerformanceResult_LB.text = "Help Needed"
            cell.PerformanceResult_IV.image = UIImage(named: "GoodJob")
            
            cell.PerformanceResult_V.layer.cornerRadius = 10.0
            let gradient = CAGradientLayer()
            gradient.cornerRadius = 10.0
            gradient.frame = cell.PerformanceResult_V.bounds
            gradient.colors = [hexStringToUIColor(hex: "#5BAFE0"), hexStringToUIColor(hex: "#5BAFE0")].map { $0.cgColor}
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            cell.PerformanceResult_V.layer.insertSublayer(gradient, at: 1)
            
        } else {
            
            cell.PerformanceResult_LB.text = ""
                
            cell.PerformanceResultBG_V.isHidden = true
        }*/
    }

    @IBAction func Notifications_VC_Open(_ sender: UIButton) {
        
        let screen = self.storyboard!.instantiateViewController(withIdentifier: "Notifications_VC") as! Notifications_VC
        self.navigationController?.pushViewController(screen, animated: true);
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

// Collection View
extension Home_VC {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 101 {
            return CGSize(width: 100.0, height: 95.0)
        } else {
            return CGSize(width: 310.0, height: 175.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 101 {
            return WeeklyAttendance_JsonArray.count
        } else {
            return Announcements_JsonArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 101 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyAttendance_CVCell", for: indexPath) as? WeeklyAttendance_CVCell else { return UICollectionViewCell() }
                    
            let dict :NSDictionary = WeeklyAttendance_JsonArray.object(at: indexPath.row) as! NSDictionary
                    
            cell.DayTitle_LB.text = (dict.GotValue(key: "day") as String)
            cell.DayValue_LB.text = (dict.GotValue(key: "time") as String)
            
            if (dict.GotValue(key: "time") as String) == "Absent" {
                cell.DayValue_LB.textColor = hexStringToUIColor(hex: "#FF5959")
            } else {
                cell.DayValue_LB.textColor = hexStringToUIColor(hex: "#8780A1")
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Announcements_CVCell", for: indexPath) as? Announcements_CVCell else { return UICollectionViewCell() }
            
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor = .clear
            
            if indexPath.row%2 == 0 {
                cell.IMG_IV.image = UIImage(named: "Card_BG")
            } else {
                cell.IMG_IV.image = UIImage(named: "Blue_Card_BG")
            }
            
            cell.Title_LB.adjustsFontSizeToFitWidth = true
            
            let dict :NSDictionary = Announcements_JsonArray.object(at: indexPath.row) as! NSDictionary
            
            cell.Title_LB.text = (dict.GotValue(key: "title") as String)
            cell.Day_LB.text = dict.GotValue(key: "day") as String
            cell.Date_LB.text = dict.GotValue(key: "date") as String
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
