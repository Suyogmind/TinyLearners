//
//  Attendance_VC.swift
//  Rising Leaders
//
//  Created by apple on 2/19/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class Attendance_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, businessLogicLayerDelegate {
    
    @IBOutlet weak var Info_TV : UITableView!
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    var jsonArray: NSMutableArray = NSMutableArray()
    
    var selectedDate: String = ""
    
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
        Info_TV.register(UINib(nibName: "Attendance_TVCell", bundle: nil), forCellReuseIdentifier: "Attendance_TVCell")
        Info_TV.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        jsonArray = NSMutableArray()
        Info_TV.reloadData()
        
        getAttendance_InvokeAPI()
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- getAttendance
    /**************************************************************************/
    
    func getAttendance_InvokeAPI() {
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available.", controller: self)
        } else {
            
            let user_id: String = UserDefaults.standard.string(forKey: "user_id") ?? ""
            
            let localParameter = [
            "kid_id": user_id,
            "selectedDate": selectedDate,
            "user_type": 1,
            "device_type" : "ios",
            ] as [String : Any]
            
            let Parameter = ["data": localParameter]
            
            showActivityIndicator(uiView: self.view)
            HalperBL.getAttendanceAPICall(Parameter)
            
            return
        }
    }
    
    func getAttendanceAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: self.view)
        
        jsonArray = NSMutableArray(array: (dict.value(forKey: "data") as! NSArray))

        Info_TV.reloadData()
    }
    
    func getAttendanceAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: massge, controller: self)
        
        jsonArray = NSMutableArray()
        Info_TV.reloadData()
    }
    
    func getAttendanceAPICallError(_ error: Error) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: "Something went wrong. Please try again!", controller: self)
        
        jsonArray = NSMutableArray()
        Info_TV.reloadData()
    }
    
    @IBAction func Back_BTN_Clicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OpenDatePicker(_ sender: UIButton) {
        
        let vc = SambagDatePickerViewController()
        vc.theme = .light
        vc.delegate = self
        present(vc, animated: true, completion: nil)
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
extension Attendance_VC {

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jsonArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Attendance_TVCell", for: indexPath) as? Attendance_TVCell else { return UITableViewCell() }
        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        let dict :NSDictionary = jsonArray.object(at: indexPath.row) as! NSDictionary
        
        cell.check_in_LB.text = dict.GotValue(key: "check_in") as String
        cell.check_out_LB.text = dict.GotValue(key: "check_out") as String
        cell.day_LB.text = dict.GotValue(key: "day") as String
        cell.date_LB.text = dict.GotValue(key: "date") as String
        
        return cell
    }
}

extension Attendance_VC: SambagDatePickerViewControllerDelegate {

    func sambagDatePickerDidSet(_ viewController: SambagDatePickerViewController, result: SambagDatePickerResult) {
        
        if DatePicker_DF().date(from: "\(result)")! > Date() {
            
            Toast.show(message: "Date should be less than today.", controller: self)
            
            return
        }
        
        selectedDate = (API_DF().string(from: DatePicker_DF().date(from: "\(result)")!))
        
        viewController.dismiss(animated: true, completion: nil)
        
        getAttendance_InvokeAPI()
    }
    
    func sambagDatePickerDidCancel(_ viewController: SambagDatePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
