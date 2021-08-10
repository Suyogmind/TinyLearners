//
//  ActivitiesCompleted_VC.swift
//  Rising Leaders
//
//  Created by apple on 4/9/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class ActivitiesCompleted_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, businessLogicLayerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var Info_TV : UITableView!
    
    @IBOutlet weak var ActivitieDetails_V : UIView!
    @IBOutlet weak var Details_SV : UIScrollView!
    @IBOutlet weak var DetailsActivitieName_LB : UILabel!
    @IBOutlet weak var DetailsActivitieDate_LB : UILabel!
    @IBOutlet weak var DetailsActivitieInfo_LB : UILabel!
    @IBOutlet weak var Details_CV : UICollectionView!
    
    var navi : UINavigationController?
    
    var JsonArray : NSMutableArray = NSMutableArray()
    var Images_jsonArray : NSMutableArray = NSMutableArray()
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    var page: Int = 1
    var isLoadMore: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APPDELEGATE.HomeNavi = self.navigationController
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        ActivitieDetails_V.frame = CGRect(x: 0.0, y: 0.0, width: CurrentDevice.ScreenWidth, height: CurrentDevice.ScreenHeight)
        
        Details_SV.contentSize = CGSize(width: Details_SV.frame.size.width, height: (Details_CV.frame.origin.y+Details_CV.frame.size.height+20.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = ScreenBGColor
        
        HalperBL.delegate = self
        
        Info_TV.tag = 101
        Info_TV.delegate = self
        Info_TV.dataSource = self
        Info_TV.separatorStyle = .none
        Info_TV.backgroundColor = UIColor.clear
        Info_TV.register(UINib(nibName: "Activities_TVCell", bundle: nil), forCellReuseIdentifier: "Activities_TVCell")
        Info_TV.reloadData()
        
        //----------Activitie Details View
//        YesterdayBottom_C.constant = 20.0
        
        ActivitieDetails_V.frame = CGRect(x: 0.0, y: 0.0, width: CurrentDevice.ScreenWidth, height: CurrentDevice.ScreenHeight)
        navi!.view.addSubview(ActivitieDetails_V)
        ActivitieDetails_V.isHidden = true
        
        Details_SV.layer.cornerRadius = 20.0
        
        Details_CV.delegate = self
        Details_CV.dataSource = self
        Details_CV.register(UINib(nibName: "IMG_CVCell", bundle: nil), forCellWithReuseIdentifier: "IMG_CVCell")
        Details_CV.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        JsonArray = NSMutableArray()
        page = 1
        completedActivities_InvokeAPI()
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- parent/completedActivities
    /**************************************************************************/
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let visibleCells = Info_TV.visibleCells
        
        if let firstCell = visibleCells.last {
            
            if let indexPath = Info_TV.indexPath(for: firstCell) {
                // use indexPath to delete the cell
                
                if (indexPath.row == JsonArray.count - 1) && isLoadMore { // last cell
                    
                    isLoadMore = false
                    
                    page = page + 1
                    
                    completedActivities_InvokeAPI()
                }
            }
        }
    }
    
    func completedActivities_InvokeAPI() {
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available.", controller: self)
        } else {
            
            let user_id: String = UserDefaults.standard.string(forKey: "user_id") ?? ""
            
            let localParameter = [
            "kid_id": user_id,
            "user_type": 1,
            "page" : page,
            "limit" : 20,
            "device_type" : "ios",
            ] as [String : Any]
            
            let Parameter = ["data": localParameter]
            
            showActivityIndicator(uiView: navi!.view)
            HalperBL.completedActivitiesAPICall(Parameter)
            
            return
        }
    }
    
    func completedActivitiesAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: navi!.view)
        
        isLoadMore = true
        
        let Json_Array : NSMutableArray = NSMutableArray(array: dict.value(forKey: "data") as! NSArray)
        
        JsonArray.addObjects(from: (Json_Array as! [Any]))
        
        Info_TV.reloadData()
    }
    
    func completedActivitiesAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: navi!.view)
        
        isLoadMore = false
        if page == 1 {
            Toast.show(message: massge, controller: self)
        }
        
        Info_TV.reloadData()
    }
    
    func completedActivitiesAPICallError(_ error: Error) {
        hideActivityIndicator(uiView: navi!.view)
        
        Toast.show(message: "Something went wrong. Please try again!", controller: self)
        
        isLoadMore = false
        
        Info_TV.reloadData()
    }
    
    @IBAction func Close_ActivitieDetails(_ sender: UIButton) {
        
        ActivitieDetails_V.isHidden = true
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

// Table view
extension ActivitiesCompleted_VC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return JsonArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 81.0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Activities_TVCell", for: indexPath) as? Activities_TVCell else { return UITableViewCell() }
        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        cell.Title_LB.textColor = hexStringToUIColor(hex: "#403E76")
        cell.Time_LB.textColor = hexStringToUIColor(hex: "#8780A1")
        
        cell.PerformanceResult_LB.adjustsFontSizeToFitWidth = true
        
        var dict :NSDictionary = JsonArray.object(at: indexPath.row) as! NSDictionary
        
        cell.Title_LB.text = (dict.GotValue(key: "activityType") as String) + ": " + (dict.GotValue(key: "description") as String)
        cell.Time_LB.text = (dict.GotValue(key: "time_difference") as String).firstCharacterUpperCase()
        
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
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var dict :NSDictionary = JsonArray.object(at: indexPath.row) as! NSDictionary
        
        DetailsActivitieName_LB.text = (dict.GotValue(key: "activityType") as String)
        DetailsActivitieDate_LB.text = (dict.GotValue(key: "time_difference") as String).firstCharacterUpperCase()
        DetailsActivitieInfo_LB.text = (dict.GotValue(key: "description") as String)
        
        Images_jsonArray = NSMutableArray()
        if (dict.GotValue(key: "attachments") as String).count > 0 {
            Images_jsonArray.add((dict.GotValue(key: "attachments") as String))
        }
        if (dict.GotValue(key: "performace_attachemnt") as String).count > 0 {
            Images_jsonArray.add((dict.GotValue(key: "performace_attachemnt") as String))
        }
        
        Details_CV.reloadData()
        
        ActivitieDetails_V.isHidden = false
    }
}

// Collection View
extension ActivitiesCompleted_VC {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120.0, height: 120.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Images_jsonArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IMG_CVCell", for: indexPath) as? IMG_CVCell else { return UICollectionViewCell() }
        
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        
        cell.IMG_IV.layer.cornerRadius = 10.0
        
        cell.IMG_IV.sd_setShowActivityIndicatorView(true)
        cell.IMG_IV.sd_setIndicatorStyle(.gray)
        cell.IMG_IV?.sd_setImage(with: NSURL(string:((Images_jsonArray.object(at: indexPath.row) as! String)))! as URL) { (image, error, cache, urls) in
            if (error != nil) {
            } else {
                cell.IMG_IV.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
