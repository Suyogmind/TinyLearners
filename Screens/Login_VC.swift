//
//  Login_VC.swift
//  Rising Leaders
//
//  Created by apple on 2/18/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class Login_VC: UIViewController, UITextFieldDelegate, businessLogicLayerDelegate {

    @IBOutlet weak var SV_Scroll : UIScrollView!
    @IBOutlet weak var TF_UserName : UITextField!
    @IBOutlet weak var TF_Password : UITextField!
    
    @IBOutlet weak var Register_BTN : UIButton!
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CheckLoginAndPushScreen()
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
        
        TF_UserName.delegate = self
        TF_UserName.addPlaceHolder(str_placeholder: "Enter Email")
        
        TF_Password.delegate = self
        TF_Password.addPlaceHolder(str_placeholder: "****************")
        
        addDoneButtonOnKeyboard()
    }
    
    @IBAction func LoginValidation(_ sender: UIButton) {
        
        CloseKeyBoard()
        
        if TF_UserName.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Enter Email", controller: self)
            
        } else if !isValidEmail(TF_UserName.text!) {
            
            Toast.show(message: "Please Enter Valid Email", controller: self)
            
        } else if TF_Password.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Enter Password", controller: self)
            
        } else {
            
            login_InvokeAPI()
            
        }
    }
    
    @IBAction func Register_BTN_Clicked(_ sender: UIButton) {
        
        let screen = self.storyboard!.instantiateViewController(withIdentifier: "RegisterFirst_VC") as! RegisterFirst_VC
        self.navigationController?.pushViewController(screen, animated: true);
    }
    
    @IBAction func Open_ForgotPasswordScreen(_ sender: UIButton) {
        
        let screen = self.storyboard!.instantiateViewController(withIdentifier: "ForgotPassword_VC") as! ForgotPassword_VC
        self.navigationController?.pushViewController(screen, animated: true);
    }
    
    func CheckLoginAndPushScreen() {
        
        CloseKeyBoard()
        
        let user_id: String = UserDefaults.standard.string(forKey: "user_id") ?? ""
        
        if user_id.count > 0 {

            let story:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let Root_VC:Root_VC = (story.instantiateViewController(withIdentifier: "Root_VC") as? Root_VC)!
            self.navigationController?.pushViewController(Root_VC, animated: false)
        }
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
        
        TF_UserName.inputAccessoryView = doneToolbar
        TF_Password.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        TF_UserName.resignFirstResponder();
        TF_Password.resignFirstResponder();
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == TF_UserName {
            
            TF_UserName.resignFirstResponder()
            TF_Password.becomeFirstResponder()
            
        } else {
            
            CloseKeyBoard()
        }
        
        return true
    }
    
    func CloseKeyBoard() {
        
        self.view.endEditing(true)
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- login
    /**************************************************************************/
    
    func login_InvokeAPI() {
        
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available.", controller: self)
        } else {
            
            var device_token: String = ""
            if let deviceToken = UserDefaults.standard.value(forKey: "deviceToken") as? NSString {

                device_token = deviceToken as String
            }
            
            let localParameter = [
                "emailOrId": TF_UserName.text ?? "",
                "password": TF_Password.text ?? "",
                "device_token": device_token,
                "user_type": 1,
                "device_type" : "ios",
                ] as [String : Any]
            
            let Parameter = ["data": localParameter]
            
            showActivityIndicator(uiView: self.view)
            HalperBL.loginAPICall(Parameter)
            
            return
        }
    }
    
    func loginAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: self.view)
        
        TF_UserName.text = ""
        TF_Password.text = ""
        
        let dict:NSDictionary = dict.value(forKey: "data") as! NSDictionary
        
        UserDefaults.standard.set(dict, forKey: "kidDetails")
        UserDefaults.standard.set(dict.GotValue(key: "kid_id"), forKey: "user_id")
        UserDefaults.standard.synchronize()
        
        CheckLoginAndPushScreen()
    }
    
    func loginAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: massge, controller: self)
    }
    
    func loginAPICallError(_ error: Error) {
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
