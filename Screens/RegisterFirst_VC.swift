//
//  RegisterFirst_VC.swift
//  Rising Leaders
//
//  Created by apple on 2/18/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class RegisterFirst_VC: UIViewController, UITextFieldDelegate, businessLogicLayerDelegate {

    @IBOutlet weak var SV_Scroll : UIScrollView!
    @IBOutlet weak var TF_SchoolLocation  : UITextField!
    
    @IBOutlet weak var Login_BTN : UIButton!
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    var SchoolLocation_JsonArray: [NSDictionary] = []
    var SchoolLocationArray: NSMutableArray = NSMutableArray()
    var SelectedSchoolLocationID: String = ""
    
    let listPicker = PickerDialog (
        textColor: UIColor(red: 61/255, green: 187/255, blue: 234/255, alpha: 1),
        buttonColor: hexStringToUIColor(hex: "#2D31AC"),
        font: UIFont(name: "AvenirNext-Medium", size: 20) ?? UIFont.boldSystemFont(ofSize: 17),
        showCancelButton: true
    )
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        SV_Scroll.contentSize = CGSize(width: CurrentDevice.ScreenWidth, height: (Login_BTN.frame.origin.y+100.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = ScreenBGColor
        
        HalperBL.delegate = self
        
        TF_SchoolLocation.delegate = self
        TF_SchoolLocation.addPlaceHolder(str_placeholder: "Select Location")
        
        let SchoolLocation_RVM = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        SchoolLocation_RVM.contentEdgeInsets = UIEdgeInsets(top: 15.5, left: 13.0, bottom: 15.5, right: 13.0)
        SchoolLocation_RVM.setImage(UIImage(named: "dropDown"), for: .normal)
        TF_SchoolLocation.rightView = SchoolLocation_RVM
        TF_SchoolLocation.rightViewMode = .always
        
        addDoneButtonOnKeyboard()
        
        schoolLocation_InvokeAPI()
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- schoolLocation
    /**************************************************************************/
    
    func schoolLocation_InvokeAPI() {
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available.", controller: self)
        } else {
            
            let localParameter = [
                "user_type": 1,
                "device_type" : "ios",
                ] as [String : Any]
            
            let Parameter = ["data": localParameter]
            
            showActivityIndicator(uiView: self.view)
            HalperBL.schoolLocationAPICall(Parameter)

            return
        }
    }
    
    func schoolLocationAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: self.view)
        
        SchoolLocation_JsonArray = (dict.value(forKey: "data") as! [NSDictionary])
        
        SchoolLocationArray = NSMutableArray()
        for LocalDict: NSDictionary in SchoolLocation_JsonArray {
            
            SchoolLocationArray.add(LocalDict.GotValue(key: "school_name") as String)
        }
    }
    
    func schoolLocationAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: massge, controller: self)
    }
    
    func schoolLocationAPICallError(_ error: Error) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: "Something went wrong. Please try again!", controller: self)
    }
    
    @IBAction func Validation(_ sender: UIButton) {
        
        CloseKeyBoard()
        
        if TF_SchoolLocation.text?.isEmpty ?? false {

            Toast.show(message: "Please Select Location", controller: self)

        } else {

            let screen = self.storyboard!.instantiateViewController(withIdentifier: "RegisterSecond_VC") as! RegisterSecond_VC
            screen.School_ID = SelectedSchoolLocationID
            self.navigationController?.pushViewController(screen, animated: true);

        }
    }
    
    @IBAction func Back_BTN_Clicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Login_BTN_Clicked(_ sender: UIButton) {
        
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
        
        TF_SchoolLocation.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        TF_SchoolLocation.resignFirstResponder();
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == TF_SchoolLocation {
            
            if SchoolLocationArray.count > 0 {
                
                listPicker.showPicker("Please select", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", PickerArrayValue: SchoolLocationArray as! [String], parentView: self.view) { (val) in
                    
                    if val != -1 {
                        
                        self.TF_SchoolLocation.text = ""
                        
                        let dict:NSDictionary = self.SchoolLocation_JsonArray[val]
                        
                        self.SelectedSchoolLocationID = (dict.GotValue(key: "school_id") as String)
                        
                        self.TF_SchoolLocation.text = (dict.GotValue(key: "school_name") as String)
                    }
                    
                    print(val)
                }
            } else {
                
                Toast.show(message: "School Location's list not found", controller: self)
                
                schoolLocation_InvokeAPI()
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == TF_SchoolLocation {
            
            TF_SchoolLocation.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func CloseKeyBoard() {
        
        self.view.endEditing(true)
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
