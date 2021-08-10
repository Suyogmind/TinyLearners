//
//  Events_VC.swift
//  Rising Leaders
//
//  Created by apple on 2/19/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class Events_VC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, businessLogicLayerDelegate {
    
    @IBOutlet weak var UpcomingEvents_CV : UICollectionView!
    @IBOutlet weak var PastEvents_TV : UITableView!
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    var pastJsonArray: NSMutableArray = NSMutableArray()
    var recentJsonArray: NSMutableArray = NSMutableArray()

    var page: Int = 1
    var isLoadMore: Bool = false
    
    var SelectedDate_STR : String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = ScreenBGColor
        
        HalperBL.delegate = self
        
        UpcomingEvents_CV.delegate = self
        UpcomingEvents_CV.dataSource = self
        UpcomingEvents_CV.register(UINib(nibName: "Events_CVCell", bundle: nil), forCellWithReuseIdentifier: "Events_CVCell")
        UpcomingEvents_CV.reloadData()
        
        PastEvents_TV.delegate = self
        PastEvents_TV.dataSource = self
        PastEvents_TV.separatorStyle = .none
        PastEvents_TV.register(UINib(nibName: "Events_TVCell", bundle: nil), forCellReuseIdentifier: "Events_TVCell")
        PastEvents_TV.reloadData()
        
        SelectedDate_STR = (Show_DF().string(from: Date()))
        
        page = 1
        isLoadMore = true
        pastJsonArray = NSMutableArray()
        
        getEvents_InvokeAPI()
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- users/getEvents
    /**************************************************************************/
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let visibleCells = PastEvents_TV.visibleCells
        
        if let firstCell = visibleCells.last {
            
            if let indexPath = PastEvents_TV.indexPath(for: firstCell) {
                // use indexPath to delete the cell
                
                if (indexPath.row == pastJsonArray.count - 1) && isLoadMore { // last cell
                    
                    isLoadMore = false
                    
                    page = page + 1
                    
                    getEvents_InvokeAPI()
                }
            }
        }
    }
    
    @objc func getEvents_InvokeAPI() {
        
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available.", controller: self)
        } else {
            
            let user_id: String = UserDefaults.standard.string(forKey: "user_id") ?? ""
            
            let localParameter = [
            "choosenDate": API_DF().string(from: (Show_DF().date(from: SelectedDate_STR)!)),
            "page" : page,
            "limit" : 20,
            "kid_id" : user_id,
            "device_type": "1"
            ] as [String : Any]
            
            let Parameter = ["data": localParameter]
            
            showActivityIndicator(uiView: self.view)
            HalperBL.getEventsAPICall(Parameter)

            return
        }
    }
    
    func getEventsAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: self.view)

        let LocalDict = (dict.value(forKey: "data") as! NSDictionary)
        recentJsonArray = NSMutableArray(array: (LocalDict.value(forKey: "upcoming") as! NSArray))

        let Json_Array : NSMutableArray = NSMutableArray(array: (LocalDict.value(forKey: "past") as! NSArray))

        if Json_Array.count > 0 {
            
            isLoadMore = true
            pastJsonArray.addObjects(from: (Json_Array as! [Any]))
            
        } else {
            
            isLoadMore = false
        }
        
        if pastJsonArray.count > 0 {
            PastEvents_TV.isHidden = false
        } else {
            PastEvents_TV.isHidden = true
        }
        
        if recentJsonArray.count > 0 {
            UpcomingEvents_CV.isHidden = false
        } else {
            UpcomingEvents_CV.isHidden = true
        }
        
        UpcomingEvents_CV.reloadData()
        PastEvents_TV.reloadData()
    }
    
    func getEventsAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: self.view)
        
        pastJsonArray = NSMutableArray()
        recentJsonArray = NSMutableArray()
        
        UpcomingEvents_CV.isHidden = true
        PastEvents_TV.isHidden = true
        
        isLoadMore = false
        
        if page == 1 {
            Toast.show(message: massge, controller: self)
        }
    }
    
    func getEventsAPICallError(_ error: Error) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: "Something went wrong. Please try again!", controller: self)
        
        pastJsonArray = NSMutableArray()
        recentJsonArray = NSMutableArray()
        
        UpcomingEvents_CV.isHidden = true
        PastEvents_TV.isHidden = true
        
        isLoadMore = false
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

// Collection View
extension Events_VC {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 330.0, height: 230.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return recentJsonArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Events_CVCell", for: indexPath) as? Events_CVCell else { return UICollectionViewCell() }
        
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        
        cell.IMG_IV.layer.cornerRadius = 30.0
        if indexPath.row%2 == 0 {
            cell.IMG_IV.image = UIImage(named: "EventsCardBG")
        } else {
            cell.IMG_IV.image = UIImage(named: "EventsCard_BG")
        }
                
        cell.Title_LB.adjustsFontSizeToFitWidth = true
                
        let dict :NSDictionary = recentJsonArray.object(at: indexPath.row) as! NSDictionary
        
        cell.Title_LB.text = (dict.GotValue(key: "tittle") as String)
        cell.Info1_LB.text = (dict.GotValue(key: "description") as String)
        cell.Info2_LB.text = (dict.GotValue(key: "location") as String)
        cell.Date_LB.text = (dict.GotValue(key: "event_time") as String) + " - " + (dict.GotValue(key: "display_date") as String)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// Table View
extension Events_VC {

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pastJsonArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Events_TVCell", for: indexPath) as? Events_TVCell else { return UITableViewCell() }
        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
                
        let dict :NSDictionary = pastJsonArray.object(at: indexPath.row) as! NSDictionary
        
        cell.Date_V.layer.cornerRadius = 10.0
        
        cell.Title_LB.text = (dict.GotValue(key: "tittle") as String)
        cell.Info_LB.text = (dict.GotValue(key: "description") as String)
        
        let date: String = (dict.GotValue(key: "display_date") as String)
        
        cell.Date_LB.text = "\(date.components(separatedBy: " ")[0])"
        cell.Month_LB.text = "\(date.components(separatedBy: " ")[1])".replacingOccurrences(of: ",", with: "")
        cell.Year_LB.text = "\(date.components(separatedBy: " ")[2])"
        
        return cell
    }
}

extension Events_VC: SambagDatePickerViewControllerDelegate {

    func sambagDatePickerDidSet(_ viewController: SambagDatePickerViewController, result: SambagDatePickerResult) {
        
        if DatePicker_DF().date(from: "\(result)")! > Date() {
            
            Toast.show(message: "Date should be less than today.", controller: self)
            
            return
        }
        
        page = 1
        isLoadMore = true
        pastJsonArray = NSMutableArray()
        
        SelectedDate_STR = (Show_DF().string(from: DatePicker_DF().date(from: "\(result)")!))
        self.perform(#selector(getEvents_InvokeAPI), with: nil, afterDelay: 0.5)
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagDatePickerDidCancel(_ viewController: SambagDatePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
