//
//  ChangePassword_VC.swift
//  Rising Leaders
//
//  Created by apple on 3/23/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class ChangePassword_VC: UIViewController, UITextFieldDelegate, businessLogicLayerDelegate {

    @IBOutlet weak var SV_Scroll : UIScrollView!
    
    @IBOutlet weak var TF_OldPassword : UITextField!
    @IBOutlet weak var TF_NewPassword : UITextField!
    @IBOutlet weak var TF_ConfirmPassword : UITextField!
    
    @IBOutlet weak var Update_BTN : UIButton!
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        SV_Scroll.contentSize = CGSize(width: CurrentDevice.ScreenWidth, height: (Update_BTN.frame.origin.y+100.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        HalperBL.delegate = self
        
        TF_OldPassword.delegate = self
        TF_OldPassword.addPlaceHolder(str_placeholder: "****************")
        
        TF_NewPassword.delegate = self
        TF_NewPassword.addPlaceHolder(str_placeholder: "****************")
        
        TF_ConfirmPassword.delegate = self
        TF_ConfirmPassword.addPlaceHolder(str_placeholder: "****************")
        
        addDoneButtonOnKeyboard()
    }
    
    @IBAction func Validation(_ sender: UIButton) {
        
        CloseKeyBoard()
        
        if TF_OldPassword.text?.isEmpty ?? false {
            
            Toast.show(message: "Please enter Old Password", controller: self)
            
        } else if TF_NewPassword.text?.isEmpty ?? false {
            
            Toast.show(message: "Please enter New Password", controller: self)
            
        } else if TF_ConfirmPassword.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Enter Confirm Password", controller: self)
            
        } else if TF_ConfirmPassword.text != TF_NewPassword.text {
                        
            Toast.show(message: "Password and Confirm Password not matching", controller: self)
            
        } else {
    
            changePassword_InvokeAPI()
            
        }
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- changePassword
    /**************************************************************************/
    
    func changePassword_InvokeAPI() {
        
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available.", controller: self)
        } else {
            
            let user_id: String = UserDefaults.standard.string(forKey: "user_id") ?? ""
            
            let localParameter = [
                "kid_id": user_id,
                "old_password": TF_OldPassword.text ?? "",
                "new_password": TF_ConfirmPassword.text ?? "",
                "user_type": 1,
                "device_type" : "ios",
                ] as [String : Any]
            
            let Parameter = ["data": localParameter]
            
            showActivityIndicator(uiView: self.view)
            HalperBL.changePasswordAPICall(Parameter)
            
            return
        }
    }
    
    func changePasswordAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: self.view)
        
        let actionSheetController: UIAlertController = UIAlertController(title: (dict.GotValue(key: "message") as String), message: "", preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
            //Do your task
            
            self.navigationController?.popViewController(animated: true)
        }
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func changePasswordAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: massge, controller: self)
    }
    
    func changePasswordAPICallError(_ error: Error) {
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
        
        TF_OldPassword.inputAccessoryView = doneToolbar
        TF_NewPassword.inputAccessoryView = doneToolbar
        TF_ConfirmPassword.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        TF_OldPassword.resignFirstResponder();
        TF_NewPassword.resignFirstResponder();
        TF_ConfirmPassword.resignFirstResponder();
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == TF_OldPassword {
            
            TF_OldPassword.resignFirstResponder()
            TF_NewPassword.becomeFirstResponder()
            
        } else if textField == TF_NewPassword {
            
            TF_NewPassword.resignFirstResponder()
            TF_ConfirmPassword.becomeFirstResponder()
            
        } else if textField == TF_ConfirmPassword {
            
            TF_ConfirmPassword.resignFirstResponder()
        }
        
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
