//
//  Message_VC.swift
//  Rising Leaders
//
//  Created by apple on 2/20/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class Message_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, businessLogicLayerDelegate {

    @IBOutlet weak var Info_TV : UITableView!
    @IBOutlet weak var Send_BTN : App_BTN!
    @IBOutlet weak var MSG_TV : UITextView!
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    var JsonArray: NSMutableArray = NSMutableArray()
    
    var user_id: String = ""
    var receiver_id : String = ""
    var thread_id : String = ""
    var IMG_URL : String = ""
    var Name_STR : String = ""
    
    var kid_name : String = ""
    var kid_profile_pic : String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        user_id = (UserDefaults.standard.string(forKey: "user_id") ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        HalperBL.delegate = self
        
        JsonArray = NSMutableArray()
        
        Send_BTN.layer.cornerRadius = 0.0
        
        Info_TV.tag = 102
        Info_TV.delegate = self
        Info_TV.dataSource = self
        Info_TV.separatorStyle = .none
        Info_TV.register(UINib(nibName: "MessageTitle_TVCell", bundle: nil), forCellReuseIdentifier: "MessageTitle_TVCell")
        Info_TV.register(UINib(nibName: "Text_TVCell", bundle: nil), forCellReuseIdentifier: "Text_TVCell")
        Info_TV.reloadData()
        
        MSG_TV.delegate = self
        MSG_TV.placeholder = "Start Typing to reply..."
        MSG_TV.isScrollEnabled = false
        MSG_TV.textContainerInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        addDoneButtonOnKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let dict: NSDictionary = UserDefaults.standard.value(forKey: "kidDetails") as? NSDictionary {
        
            kid_name = dict.GotValue(key: "kid_name") as String
            kid_profile_pic = dict.GotValue(key: "profile_pic") as String
        }
        
        JsonArray = NSMutableArray()
        
        Info_TV.reloadData()
        
        getThreadList_InvokeAPI()
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- getThreadList
    /**************************************************************************/
    
    func getThreadList_InvokeAPI() {
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available.", controller: self)
        } else {
            
            let localParameter = [
                "thread_id" : thread_id,
                "kid_id": user_id,
                "user_id" : receiver_id,
                "user_type": 1,
                "device_type" : "ios",
                ] as [String : Any]
            
            let Parameter = ["data": localParameter]
            
            showActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
            HalperBL.getThreadListAPICall(Parameter)
            
            return
        }
    }
    
    func getThreadListAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
        
        JsonArray = NSMutableArray(array: (dict.value(forKey: "data") as! NSArray))
        
        Info_TV.reloadData()
        if JsonArray.count > 0 {
            
            Info_TV.scrollToBottom()
        }
    }
    
    func getThreadListAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
        
        Toast.show(message: massge, controller: self)
    }
    
    func getThreadListAPICallError(_ error: Error) {
        hideActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
        
        Toast.show(message: "Something went wrong. Please try again!", controller: self)
    }
    
    /**************************************************************************/
    //MARK:- Go Back Screen /////////////////////////////////
    /**************************************************************************/
    
    @IBAction func GoBackScreen(_ sender: Any) {
     
        self.navigationController?.popViewController(animated: true)
    }
    
    /**************************************************************************/
    //MARK:- Keyboard /////////////////////////////////
    /**************************************************************************/
    
    // Mark :- Done text file method
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        MSG_TV.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        MSG_TV.resignFirstResponder();
    }
    
    private func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        return true
    }
    
    func CloseKeyBoard() {
        
        self.view.endEditing(true)
    }
    
    /**************************************************************************/
    //MARK:- Send Message /////////////////////////////////
    /**************************************************************************/
    
    @IBAction func SendMessage_BTN_Clicked(_ sender: Any) {
     
        CloseKeyBoard()
            
        if MSG_TV.text?.isEmpty ?? false {
            
            Toast.show(message: "Please write your Message", controller: self)
            
        } else {
        
            replyFromParents_InvokeAPI()
            
        }
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- replyFromParents
    /**************************************************************************/
    
    func replyFromParents_InvokeAPI() {
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available.", controller: self)
        } else {
            
            let localParameter = [
                "subject" : "",
                "textMessage": MSG_TV.text ?? "",
                "sender_id": user_id,
                "receiver_id": receiver_id,
                "thread_id" : thread_id,
                "user_type": 1,
                "device_type" : "ios",
                ] as [String : Any]
            
            let Parameter = ["data": localParameter]
            
            showActivityIndicator(uiView: self.view)
            HalperBL.replyFromParentsAPICall(Parameter)

            return
        }
    }
    
    func replyFromParentsAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: (dict.GotValue(key: "message") as String), controller: self)
        
        MSG_TV.text = ""
        
        JsonArray = NSMutableArray()
        
        Info_TV.reloadData()
        
        getThreadList_InvokeAPI()
    }
    
    func replyFromParentsAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: massge, controller: self)
    }
    
    func replyFromParentsAPICallError(_ error: Error) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: "Something went wrong. Please try again!", controller: self)
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
extension Message_VC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return JsonArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let Footer_V = UIView(frame: CGRect(x: 0.0, y: 0.0, width: CurrentDevice.ScreenWidth, height: 1.0))
        Footer_V.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 0.2)
        
        return Footer_V
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 114.0
            
        } else {
            
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTitle_TVCell", for: indexPath) as? MessageTitle_TVCell else { return UITableViewCell() }
            
            cell.IMG_IV.layer.cornerRadius = 27.0
            
            cell.Name_LB.textColor = hexStringToUIColor(hex: "#6C667D")
            cell.Title_LB.textColor = hexStringToUIColor(hex: "#403E76")
            cell.DateTime_LB.textColor = hexStringToUIColor(hex: "#8780A1")
            
            let dict :NSDictionary = JsonArray.object(at: indexPath.section) as! NSDictionary
            
            if (dict.GotValue(key: "sender_id") as String) == user_id {
                cell.Name_LB.text = kid_name
            } else {
                cell.Name_LB.text = Name_STR
            }
            
            cell.Title_LB.text = dict.GotValue(key: "subject") as String
            cell.DateTime_LB.text = (dict.GotValue(key: "msgTime") as String)
            
            cell.IMG_IV.sd_setShowActivityIndicatorView(true)
            cell.IMG_IV.sd_setIndicatorStyle(.gray)
            if (dict.GotValue(key: "sender_id") as String) == user_id {
                cell.IMG_IV?.sd_setImage(with: NSURL(string:kid_profile_pic)! as URL) { (image, error, cache, urls) in
                    if (error != nil) {
                        cell.IMG_IV.image = UIImage(named: "SideMenuProfile")
                    } else {
                        cell.IMG_IV.image = image
                    }
                }
            } else {
                cell.IMG_IV?.sd_setImage(with: NSURL(string:IMG_URL)! as URL) { (image, error, cache, urls) in
                    if (error != nil) {
                    } else {
                        cell.IMG_IV.image = image
                    }
                }
            }
            
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Text_TVCell", for: indexPath) as? Text_TVCell else { return UITableViewCell() }
            
            let dict :NSDictionary = JsonArray.object(at: indexPath.section) as! NSDictionary
            
            cell.Info_LB.textColor = hexStringToUIColor(hex: "#8780A1")
            
//            if (dict.GotValue(key: "sender_id") as String) == user_id {
//                cell.Info_LB.textAlignment = .right
//            } else {
//                cell.Info_LB.textAlignment = .left
//            }
            
            cell.Info_LB.text = (dict.GotValue(key: "text_message") as String)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
