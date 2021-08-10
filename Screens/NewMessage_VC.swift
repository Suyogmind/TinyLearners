//
//  NewMessage_VC.swift
//  Rising Leaders
//
//  Created by apple on 2/20/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class NewMessage_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, businessLogicLayerDelegate {
    
    @IBOutlet weak var Info_TV : UITableView!
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    var jsonArray: NSMutableArray = NSMutableArray()
    
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
        
        Info_TV.delegate = self
        Info_TV.dataSource = self
        Info_TV.separatorStyle = .none
        Info_TV.backgroundColor = .clear
        Info_TV.register(UINib(nibName: "Contact_TVCell", bundle: nil), forCellReuseIdentifier: "Contact_TVCell")
        Info_TV.reloadData()
        
        jsonArray = NSMutableArray()
        Info_TV.reloadData()
        
        getContactList_InvokeAPI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- getContactList
    /**************************************************************************/
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let visibleCells = Info_TV.visibleCells
        
        if let firstCell = visibleCells.last {
            
            if let indexPath = Info_TV.indexPath(for: firstCell) {
                // use indexPath to delete the cell
                
                if (indexPath.row == jsonArray.count - 1) && isLoadMore { // last cell
                    
                    isLoadMore = false
                    
                    page = page + 1
                    
                    getContactList_InvokeAPI()
                }
            }
        }
    }
    
    func getContactList_InvokeAPI() {
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available.", controller: self)
        } else {
            
            let user_id: String = UserDefaults.standard.string(forKey: "user_id") ?? ""
            
            let localParameter = [
            "kid_id": user_id,
            "page" : page,
            "limit" : 20,
            "user_type": 1,
            "device_type" : "ios",
            ] as [String : Any]
            
            let Parameter = ["data": localParameter]
            
            showActivityIndicator(uiView: self.view)
            HalperBL.getContactListAPICall(Parameter)
            
            return
        }
    }
    
    func getContactListAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: self.view)
        
        isLoadMore = true
        
        jsonArray.addObjects(from: (dict.value(forKey: "data") as! [Any]))
        
        Info_TV.reloadData()
    }
    
    func getContactListAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: self.view)
        
        isLoadMore = false
        Info_TV.reloadData()
        
        if page == 1 {
            Toast.show(message: massge, controller: self)
        }
    }
    
    func getContactListAPICallError(_ error: Error) {
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

// Table View
extension NewMessage_VC {

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jsonArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 94;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Contact_TVCell", for: indexPath) as? Contact_TVCell else { return UITableViewCell() }
        
        cell.backgroundColor = UIColor.white
        cell.contentView.backgroundColor = UIColor.white
        
        cell.IMG_IV.layer.cornerRadius = 27.0

        cell.Name_LB.textColor = hexStringToUIColor(hex: "#6C667D")
        cell.Info_LB.textColor = hexStringToUIColor(hex: "#403E76")

        let dict :NSDictionary = jsonArray.object(at: indexPath.row) as! NSDictionary
        
        cell.Name_LB.text = dict.GotValue(key: "fullname") as String
        cell.Info_LB.text = dict.GotValue(key: "post") as String
        
        cell.IMG_IV.sd_setShowActivityIndicatorView(true)
        cell.IMG_IV.sd_setIndicatorStyle(.gray)
        cell.IMG_IV?.sd_setImage(with: NSURL(string:((dict.GotValue(key: "sender_pic") as String)))! as URL) { (image, error, cache, urls) in
            if (error != nil) {
            } else {
                cell.IMG_IV.image = image
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict :NSDictionary = jsonArray.object(at: indexPath.row) as! NSDictionary
        
        let screen = self.storyboard!.instantiateViewController(withIdentifier: "WriteMessage_VC") as! WriteMessage_VC
        screen.receiver_id = (dict.GotValue(key: "id") as String)
        screen.IMG_URL = (dict.GotValue(key: "sender_pic") as String)
        screen.Name_STR = (dict.GotValue(key: "fullname") as String)
        self.navigationController?.pushViewController(screen, animated: true);
    }
}
