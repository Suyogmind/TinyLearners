//
//  Announcements_VC.swift
//  Rising Leaders
//
//  Created by apple on 2/19/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class Announcements_VC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, businessLogicLayerDelegate {

    @IBOutlet weak var RecentAnnouncements_CV : UICollectionView!
    @IBOutlet weak var PastAnnouncement_TV : UITableView!
    
    @IBOutlet weak var AnnouncementDetails_V : UIView!
    @IBOutlet weak var Details_SV : UIScrollView!
    @IBOutlet weak var DetailsAnnouncementName_LB : UILabel!
    @IBOutlet weak var DetailsAnnouncementDate_LB : UILabel!
    @IBOutlet weak var DetailsAnnouncementInfo_LB : UILabel!
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    var pastJsonArray: NSMutableArray = NSMutableArray()
    var recentJsonArray: NSMutableArray = NSMutableArray()
    
    var page: Int = 1
    var isLoadMore: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        AnnouncementDetails_V.frame = CGRect(x: 0.0, y: 0.0, width: CurrentDevice.ScreenWidth, height: CurrentDevice.ScreenHeight)
        
        Details_SV.contentSize = CGSize(width: Details_SV.frame.size.width, height: (DetailsAnnouncementInfo_LB.frame.origin.y+DetailsAnnouncementInfo_LB.frame.size.height+20.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = ScreenBGColor
        
        HalperBL.delegate = self
        
        RecentAnnouncements_CV.tag = 102;
        RecentAnnouncements_CV.delegate = self
        RecentAnnouncements_CV.dataSource = self
        RecentAnnouncements_CV.register(UINib(nibName: "Announcements_CVCell", bundle: nil), forCellWithReuseIdentifier: "Announcements_CVCell")
        RecentAnnouncements_CV.reloadData()
        
        PastAnnouncement_TV.delegate = self
        PastAnnouncement_TV.dataSource = self
        PastAnnouncement_TV.separatorStyle = .none
        PastAnnouncement_TV.register(UINib(nibName: "Announcements_TVCell", bundle: nil), forCellReuseIdentifier: "Announcements_TVCell")
        PastAnnouncement_TV.reloadData()
        
        //----------Announcements Details View
        AnnouncementDetails_V.frame = CGRect(x: 0.0, y: 0.0, width: CurrentDevice.ScreenWidth, height: CurrentDevice.ScreenHeight)
        self.navigationController?.view.addSubview(AnnouncementDetails_V)
        AnnouncementDetails_V.isHidden = true
        
        Details_SV.layer.cornerRadius = 20.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pastJsonArray = NSMutableArray()
        recentJsonArray = NSMutableArray()
        
        RecentAnnouncements_CV.reloadData()
        PastAnnouncement_TV.reloadData()
        
        getAnnouncement_InvokeAPI()
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- getAnnouncement
    /**************************************************************************/
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let visibleCells = PastAnnouncement_TV.visibleCells
        
        if let firstCell = visibleCells.last {
            
            if let indexPath = PastAnnouncement_TV.indexPath(for: firstCell) {
                // use indexPath to delete the cell
                
                print("indexPath row : \(indexPath.row)")
                
                if (indexPath.row == pastJsonArray.count - 1) && isLoadMore { // last cell
                    
                    isLoadMore = false
                    
                    page = page + 1
                    
                    getAnnouncement_InvokeAPI()
                }
            }
        }
    }
    
    func getAnnouncement_InvokeAPI() {
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available.", controller: self)
        } else {
            
            let user_id: String = UserDefaults.standard.string(forKey: "user_id") ?? ""
            
            let localParameter = [
            "kid_id": user_id,
            "type": "class",
            "page" : page,
            "limit" : 20,
            "user_type": 1,
            "device_type" : "ios",
            ] as [String : Any]
            
            let Parameter = ["data": localParameter]
            
            showActivityIndicator(uiView: self.view)
            HalperBL.getAnnouncementAPICall(Parameter)
            
            return
        }
    }
    
    func getAnnouncementAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: self.view)
        
        if (dict.value(forKey: "earlier") as! [Any]).count > 0 {
            
            isLoadMore = true
            
            pastJsonArray.addObjects(from: (dict.value(forKey: "earlier") as! [Any]))
        } else {
            isLoadMore = false
        }
        
        recentJsonArray = NSMutableArray(array: (dict.value(forKey: "recent") as! NSArray))
        
        RecentAnnouncements_CV.reloadData()
        PastAnnouncement_TV.reloadData()
    }
    
    func getAnnouncementAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: self.view)
        
        isLoadMore = false
        PastAnnouncement_TV.reloadData()
        
        if page == 1 {
            Toast.show(message: massge, controller: self)
        }
    }
    
    func getAnnouncementAPICallError(_ error: Error) {
        hideActivityIndicator(uiView: self.view)
        
        isLoadMore = false
        PastAnnouncement_TV.reloadData()
        
        Toast.show(message: "Something went wrong. Please try again!", controller: self)
    }
    
    @IBAction func Back_BTN_Clicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func Close_ActivitieDetails(_ sender: UIButton) {
        
        AnnouncementDetails_V.isHidden = true
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
extension Announcements_VC {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 310.0, height: 175.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return recentJsonArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Announcements_CVCell", for: indexPath) as? Announcements_CVCell else { return UICollectionViewCell() }
        
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        
        if indexPath.row%2 == 0 {
            cell.IMG_IV.image = UIImage(named: "Card_BG")
        } else {
            cell.IMG_IV.image = UIImage(named: "Blue_Card_BG")
        }
        
        cell.Title_LB.adjustsFontSizeToFitWidth = true
        
        let dict :NSDictionary = recentJsonArray.object(at: indexPath.row) as! NSDictionary
        
        cell.Title_LB.text = (dict.GotValue(key: "title") as String)
        cell.Day_LB.text = dict.GotValue(key: "day") as String
        cell.Date_LB.text = (dict.GotValue(key: "created_at") as String)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var dict :NSDictionary = NSDictionary()
        
        dict = recentJsonArray.object(at: indexPath.row) as! NSDictionary
        
        DetailsAnnouncementName_LB.text = (dict.GotValue(key: "title") as String)
        DetailsAnnouncementDate_LB.text = (dict.GotValue(key: "created_at") as String) + " " + (dict.GotValue(key: "day") as String)
        DetailsAnnouncementInfo_LB.text = (dict.GotValue(key: "message") as String)
        
        AnnouncementDetails_V.isHidden = false
        
        self.perform(#selector(viewDidLayoutSubviews), with: nil, afterDelay: 0.5)
    }
}

// Table View
extension Announcements_VC {

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pastJsonArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Announcements_TVCell", for: indexPath) as? Announcements_TVCell else { return UITableViewCell() }
        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        cell.Title_LB.textColor = hexStringToUIColor(hex: "#403E76")
        cell.DateTime_LB.textColor = hexStringToUIColor(hex: "#8780A1")
        
        let dict :NSDictionary = pastJsonArray.object(at: indexPath.row) as! NSDictionary

        cell.Title_LB.text = dict.GotValue(key: "title") as String + ": " + (dict.GotValue(key: "message") as String)
        cell.DateTime_LB.text = dict.GotValue(key: "timeAgo") as String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var dict :NSDictionary = NSDictionary()
        
        dict = pastJsonArray.object(at: indexPath.row) as! NSDictionary
        
        DetailsAnnouncementName_LB.text = (dict.GotValue(key: "title") as String)
        DetailsAnnouncementDate_LB.text = (dict.GotValue(key: "created_at") as String) + " " + (dict.GotValue(key: "day") as String)
        DetailsAnnouncementInfo_LB.text = (dict.GotValue(key: "message") as String)
        
        AnnouncementDetails_V.isHidden = false
        
        self.perform(#selector(viewDidLayoutSubviews), with: nil, afterDelay: 0.5)
    }
}
