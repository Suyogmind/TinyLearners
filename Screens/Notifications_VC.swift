//
//  Notifications_VC.swift
//  Rising Leaders
//
//  Created by apple on 2/19/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class Notifications_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, businessLogicLayerDelegate {

    @IBOutlet weak var Info_TV : UITableView!
    
    var jsonArray : NSMutableArray = NSMutableArray()
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    var page: Int = 1
    var isLoadMore: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = ScreenBGColor
        
        HalperBL.delegate = self
        
        jsonArray = NSMutableArray()
        
        Info_TV.delegate = self
        Info_TV.dataSource = self
        Info_TV.separatorStyle = .none
        Info_TV.backgroundColor = .clear

        Info_TV.register(UINib(nibName: "Notifications_TVCell", bundle: nil), forCellReuseIdentifier: "Notifications_TVCell")
        
        Info_TV.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        jsonArray = NSMutableArray()
        Info_TV.reloadData()
        
        getNotification_InvokeAPI()
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- getNotification
    /**************************************************************************/
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let visibleCells = Info_TV.visibleCells
        
        if let firstCell = visibleCells.last {
            
            if let indexPath = Info_TV.indexPath(for: firstCell) {
                // use indexPath to delete the cell
                
                print("indexPath row : \(indexPath.row)")
                
                if (indexPath.row == jsonArray.count - 1) && isLoadMore { // last cell
                    
                    isLoadMore = false
                    
                    page = page + 1
                    
                    getNotification_InvokeAPI()
                }
            }
        }
    }
    
    func getNotification_InvokeAPI() {
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
            
            showActivityIndicator(uiView: self.view)
            HalperBL.getNotificationAPICall(Parameter)
            
            return
        }
    }
    
    func getNotificationAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: self.view)
        
        isLoadMore = true
        
        jsonArray.addObjects(from: (dict.value(forKey: "data") as! [Any]))
        
        Info_TV.reloadData()
    }
    
    func getNotificationAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: self.view)
        
        isLoadMore = false
        Info_TV.reloadData()
        
        if page == 1 {
            Toast.show(message: massge, controller: self)
        }
    }
    
    func getNotificationAPICallError(_ error: Error) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: "Something went wrong. Please try again!", controller: self)
        
        isLoadMore = false
        Info_TV.reloadData()
    }
    
    @IBAction func Back_BTN_Clicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
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
extension Notifications_VC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jsonArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 110;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Notifications_TVCell", for: indexPath) as? Notifications_TVCell else { return UITableViewCell() }
        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        cell.IMG_IV.layer.cornerRadius = 27.0
        
        cell.Time_LB.textColor = hexStringToUIColor(hex: "#403E76")
        cell.Title_LB.textColor = hexStringToUIColor(hex: "#8780A1")
        
        let dict: NSDictionary = jsonArray.object(at: indexPath.row) as! NSDictionary
        
        cell.Title_LB.text = (dict.GotValue(key: "title") as String) + ": " + (dict.GotValue(key: "body") as String)
        cell.Time_LB.text = (dict.GotValue(key: "timeAgo") as String)
        
        cell.IMG_IV.sd_setShowActivityIndicatorView(true)
        cell.IMG_IV.sd_setIndicatorStyle(.gray)
        cell.IMG_IV?.sd_setImage(with: NSURL(string:((dict.GotValue(key: "profile_pic") as String)))! as URL) { (image, error, cache, urls) in
            if (error != nil) {
            } else {
                cell.IMG_IV.image = image
            }
        }
        
        return cell
    }
}
