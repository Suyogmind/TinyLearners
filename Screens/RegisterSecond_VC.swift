//
//  RegisterSecond_VC.swift
//  Rising Leaders
//
//  Created by apple on 2/18/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class RegisterSecond_VC: UIViewController, UITextFieldDelegate, businessLogicLayerDelegate {
    
    @IBOutlet weak var SV_Scroll : UIScrollView!
    
    @IBOutlet weak var TF_KidName  : UITextField!
    @IBOutlet weak var TF_ParentName : UITextField!
    @IBOutlet weak var TF_DOB : UITextField!
    @IBOutlet weak var TF_Email : UITextField!
    @IBOutlet weak var TF_ContactNumber1 : UITextField!
    @IBOutlet weak var TF_ContactNumber2 : UITextField!
    @IBOutlet weak var TF_Password : UITextField!
    @IBOutlet weak var TF_ConfirmPassword : UITextField!
    
    @IBOutlet weak var Register_BTN : UIButton!
    
    let HalperBL: businessLogicLayer = businessLogicLayer()

    let NAME_ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "

    let NO_ACCEPTABLE_CHARACTERS = "1234567890"
    
    var School_ID: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        SV_Scroll.contentSize = CGSize(width: CurrentDevice.ScreenWidth, height: (Register_BTN.frame.origin.y+100.0))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = ScreenBGColor
        
        HalperBL.delegate = self
        
        TF_KidName.delegate = self
        TF_KidName.addPlaceHolder(str_placeholder: "Enter Kid's Name")
        
        TF_ParentName.delegate = self
        TF_ParentName.addPlaceHolder(str_placeholder: "Enter Parent's Name")
        
        TF_DOB.delegate = self
        TF_DOB.addPlaceHolder(str_placeholder: "Select Date of Birth")
        
        let DOB_RVM = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        DOB_RVM.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        DOB_RVM.setImage(UIImage(named: "tf_cal"), for: .normal)
        TF_DOB.rightView = DOB_RVM
        TF_DOB.rightViewMode = .always
        
        TF_Email.delegate = self
        TF_Email.addPlaceHolder(str_placeholder: "Enter Email Address")
        
        TF_ContactNumber1.delegate = self
        TF_ContactNumber1.addPlaceHolder(str_placeholder: "Enter Contact Number 1")
        
        let TF_ContactNumber1_LVM = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 40.0))
        TF_ContactNumber1_LVM.setTitle("+1", for: .normal)
        TF_ContactNumber1_LVM.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        TF_ContactNumber1_LVM.setTitleColor(hexStringToUIColor(hex: "#100043"), for: .normal)
        TF_ContactNumber1.leftView = TF_ContactNumber1_LVM
        TF_ContactNumber1.leftViewMode = .always
        
        TF_ContactNumber2.delegate = self
        TF_ContactNumber2.addPlaceHolder(str_placeholder: "Enter Contact Number 2")
        
        let TF_ContactNumber2_LVM = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 40.0))
        TF_ContactNumber2_LVM.setTitle("+1", for: .normal)
        TF_ContactNumber2_LVM.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        TF_ContactNumber2_LVM.setTitleColor(hexStringToUIColor(hex: "#100043"), for: .normal)
        TF_ContactNumber2.leftView = TF_ContactNumber2_LVM
        TF_ContactNumber2.leftViewMode = .always
        
        TF_Password.delegate = self
        TF_Password.addPlaceHolder(str_placeholder: "****************")
        
        TF_ConfirmPassword.delegate = self
        TF_ConfirmPassword.addPlaceHolder(str_placeholder: "****************")
        
        addDoneButtonOnKeyboard()
    }
    
    @IBAction func Validation(_ sender: UIButton) {
        
        CloseKeyBoard()
        
        if TF_KidName.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Enter Kid's Name", controller: self)
            
        } else if TF_ParentName.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Enter Parent's Name", controller: self)
            
        } else if TF_DOB.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Select Date of Birth", controller: self)
            
        } else if TF_Email.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Enter Email Address", controller: self)
            
        } else if !isValidEmail(TF_Email.text!) {
            
            Toast.show(message: "Please Enter Valid Email", controller: self)
            
        } else if TF_ContactNumber1.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Enter Contact Number 1", controller: self)
            
        } else if TF_Password.text?.isEmpty ?? false {
            
            Toast.show(message: "Please enter Password", controller: self)
            
        } else if TF_ConfirmPassword.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Enter Confirm Password", controller: self)
            
        } else if TF_ConfirmPassword.text != TF_Password.text {
                        
            Toast.show(message: "Password and Confirm Password not matching", controller: self)
            
        } else {
            
            signUp_InvokeAPI()
            
        }
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- signUp
    /**************************************************************************/
    
    func signUp_InvokeAPI() {
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available.", controller: self)
        } else {
            
            let now = Date()
            let birthday: Date = Show_DF().date(from: self.TF_DOB.text!)!
            let calendar = Calendar.current
            
            let ageComponents = calendar.dateComponents([.month], from: birthday, to: now)
            let age = ageComponents.month!
            
            var device_token: String = ""
            if let deviceToken = UserDefaults.standard.value(forKey: "deviceToken") as? NSString {

                device_token = deviceToken as String
            }
            
            let localParameter = [
                "user_type": 1,
                "kid_name": TF_KidName.text ?? "",
                "gardian_name": TF_ParentName.text ?? "",
                "email": TF_Email.text ?? "",
                "password": TF_Password.text ?? "",
                "phone": TF_ContactNumber1.text ?? "",
                "other_phone": TF_ContactNumber2.text ?? "",
                "dob": (API_DF().string(from: (Show_DF().date(from: self.TF_DOB.text!)!))),
                "age": "\(age)",
                "school_id": School_ID,
                "device_token": device_token,
                "device_type" : "ios",
                ] as [String : Any]
            
            let Parameter = ["data": localParameter]
            
            showActivityIndicator(uiView: self.view)
            HalperBL.signUpAPICall(Parameter)
            
            return
        }
    }
    
    func signUpAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: self.view)
        
        let dict:NSDictionary = dict.value(forKey: "data") as! NSDictionary
        
        UserDefaults.standard.set(dict, forKey: "kidDetails")
        UserDefaults.standard.set(dict.GotValue(key: "kid_id"), forKey: "user_id")
        UserDefaults.standard.synchronize()
        
        let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let Root_VC:Root_VC = (story.instantiateViewController(withIdentifier: "Root_VC") as? Root_VC)!
        self.navigationController?.pushViewController(Root_VC, animated: false)
    }
    
    func signUpAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: massge, controller: self)
    }
    
    func signUpAPICallError(_ error: Error) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: "Something went wrong. Please try again!", controller: self)
    }
    
    @IBAction func Back_BTN_Clicked(_ sender: UIButton) {
        
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
        
        TF_KidName.inputAccessoryView = doneToolbar
        TF_ParentName.inputAccessoryView = doneToolbar
        TF_DOB.inputAccessoryView = doneToolbar
        TF_Email.inputAccessoryView = doneToolbar
        TF_ContactNumber1.inputAccessoryView = doneToolbar
        TF_ContactNumber2.inputAccessoryView = doneToolbar
        TF_Password.inputAccessoryView = doneToolbar
        TF_ConfirmPassword.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        TF_KidName.resignFirstResponder();
        TF_ParentName.resignFirstResponder();
        TF_DOB.resignFirstResponder();
        TF_Email.resignFirstResponder();
        TF_ContactNumber1.resignFirstResponder();
        TF_ContactNumber2.resignFirstResponder();
        TF_Password.resignFirstResponder();
        TF_ConfirmPassword.resignFirstResponder();
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == TF_DOB {
            
            let vc = SambagDatePickerViewController()
            vc.theme = .light
            vc.delegate = self
            present(vc, animated: true, completion: nil)
            
            return false
        }
     
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == TF_KidName {
            
            TF_KidName.resignFirstResponder()
            TF_ParentName.becomeFirstResponder()
            
        } else if textField == TF_ParentName {
            
            TF_ParentName.resignFirstResponder()
            TF_Email.becomeFirstResponder()
            
        } else if textField == TF_Email {
            
            TF_Email.resignFirstResponder()
            TF_ContactNumber1.becomeFirstResponder()
            
        } else if textField == TF_ContactNumber1 {
            
            TF_ContactNumber1.resignFirstResponder()
            TF_ContactNumber2.becomeFirstResponder()
            
        } else if textField == TF_ContactNumber2 {
            
            TF_ContactNumber2.resignFirstResponder()
            TF_Password.becomeFirstResponder()
            
        } else if textField == TF_Password {
            
            TF_Password.resignFirstResponder()
            TF_ConfirmPassword.becomeFirstResponder()
            
        } else if textField == TF_ConfirmPassword {
            
            TF_ConfirmPassword.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == TF_KidName || textField == TF_ParentName {
            
            let cs = NSCharacterSet(charactersIn: NAME_ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")

            return (string == filtered)
            
        } else if textField == TF_ContactNumber1 || textField == TF_ContactNumber2 {
            
            let cs = NSCharacterSet(charactersIn: NO_ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")

            return (string == filtered)
            
        } else {
            
            return true
        }
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

extension RegisterSecond_VC: SambagDatePickerViewControllerDelegate {

    func sambagDatePickerDidSet(_ viewController: SambagDatePickerViewController, result: SambagDatePickerResult) {
        
        if DatePicker_DF().date(from: "\(result)")! > Calendar.current.date(byAdding: .month, value: -3, to: NSDate() as Date)! {
                    
        //        if DatePicker_DF().date(from: "\(result)")! > Date() {
                    
            Toast.show(message: "Kid's minimum age should be 3 months.", controller: self)
            
            return
        }
        
        self.TF_DOB.text = (Show_DF().string(from: DatePicker_DF().date(from: "\(result)")!))
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sambagDatePickerDidCancel(_ viewController: SambagDatePickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
