//
//  Feedback_VC.swift
//  Rising Leaders
//
//  Created by apple on 2/19/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class Feedback_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, businessLogicLayerDelegate {
    
    @IBOutlet weak var Info_TV : UITableView!
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    var JsonArray: NSMutableArray = NSMutableArray()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APPDELEGATE.HomeNavi = self.navigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = ScreenBGColor
        
        HalperBL.delegate = self
        
        JsonArray = NSMutableArray()
        
        Info_TV.tag = 101
        Info_TV.delegate = self
        Info_TV.dataSource = self
        Info_TV.separatorStyle = .none
        Info_TV.backgroundColor = ScreenBGColor
        Info_TV.register(UINib(nibName: "Inbox_TVCell", bundle: nil), forCellReuseIdentifier: "Inbox_TVCell")
        Info_TV.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        JsonArray = NSMutableArray()
        
        Info_TV.reloadData()
        
        getFeedbackList_InvokeAPI()
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- getFeedbackList
    /**************************************************************************/
    
    func getFeedbackList_InvokeAPI() {
        
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
            HalperBL.getFeedbackListAPICall(Parameter)
            
            return
        }
    }
    
    func getFeedbackListAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
        
        JsonArray = NSMutableArray(array: (dict.value(forKey: "data") as! NSArray))
        
        Info_TV.reloadData()
    }
    
    func getFeedbackListAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
        
        Toast.show(message: massge, controller: self)
    }
    
    func getFeedbackListAPICallError(_ error: Error) {
        hideActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
        
        Toast.show(message: "Something went wrong. Please try again!", controller: self)
    }
    
    @IBAction func NewMessage_VC_Open(_ sender: UIButton) {
        
        let screen = self.storyboard!.instantiateViewController(withIdentifier: "NewMessage_VC") as! NewMessage_VC
        self.navigationController?.pushViewController(screen, animated: true);
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

// Table view
extension Feedback_VC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return JsonArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Inbox_TVCell", for: indexPath) as? Inbox_TVCell else { return UITableViewCell() }
        
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        
        cell.IMG_IV.layer.cornerRadius = 27.0
        
        cell.Name_LB.textColor = hexStringToUIColor(hex: "#6C667D")
        cell.Title_LB.textColor = hexStringToUIColor(hex: "#403E76")
        cell.Description_LB.textColor = hexStringToUIColor(hex: "#8780A1")
        cell.DateTime_LB.textColor = hexStringToUIColor(hex: "#8780A1")
        
        let dict :NSDictionary = JsonArray.object(at: indexPath.row) as! NSDictionary
        
        cell.DateTime_LB.numberOfLines = 2
        cell.DateTime_LB.adjustsFontSizeToFitWidth = true
        
        cell.Name_LB.text = dict.GotValue(key: "fullname") as String
        cell.Title_LB.text = dict.GotValue(key: "subject") as String
        cell.Description_LB.text = dict.GotValue(key: "text_message") as String
        cell.DateTime_LB.text = dict.GotValue(key: "msgTime") as String
        
        cell.IMG_IV.sd_setShowActivityIndicatorView(true)
        cell.IMG_IV.sd_setIndicatorStyle(.gray)
        cell.IMG_IV?.sd_setImage(with: NSURL(string:((dict.GotValue(key: "kid_profile_pic") as String)))! as URL) { (image, error, cache, urls) in
            if (error != nil) {
            } else {
                cell.IMG_IV.image = image
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict :NSDictionary = JsonArray.object(at: indexPath.row) as! NSDictionary

        let screen = self.storyboard!.instantiateViewController(withIdentifier: "Message_VC") as! Message_VC
        screen.receiver_id = (dict.GotValue(key: "reciever_id") as String)
        screen.thread_id = (dict.GotValue(key: "thread_id") as String)
        screen.Name_STR = (dict.GotValue(key: "fullname") as String)
        screen.IMG_URL = (dict.GotValue(key: "kid_profile_pic") as String)
        self.navigationController?.pushViewController(screen, animated: true);
        
    }
}
