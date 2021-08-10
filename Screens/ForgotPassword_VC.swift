//
//  ForgotPassword_VC.swift
//  Rising Leaders
//
//  Created by apple on 3/23/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class ForgotPassword_VC: UIViewController, UITextFieldDelegate, businessLogicLayerDelegate {

    @IBOutlet weak var SV_Scroll : UIScrollView!
    @IBOutlet weak var TF_UserName : UITextField!
    
    @IBOutlet weak var Send_BTN : UIButton!
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        SV_Scroll.contentSize = CGSize(width: CurrentDevice.ScreenWidth, height: (Send_BTN.frame.origin.y+100.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = ScreenBGColor
        
        HalperBL.delegate = self
        
        TF_UserName.delegate = self
        TF_UserName.addPlaceHolder(str_placeholder: "Enter Email")
        
        addDoneButtonOnKeyboard()
    }
    
    @IBAction func Validation(_ sender: UIButton) {
        
        CloseKeyBoard()
        
        if TF_UserName.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Enter Email", controller: self)
            
        } else if !isValidEmail(TF_UserName.text!) {
            
            Toast.show(message: "Please Enter Valid Email", controller: self)
            
        } else {
            
            forgetPassword_InvokeAPI()
        }
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- forgetPassword
    /**************************************************************************/
    
    func forgetPassword_InvokeAPI() {
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available.", controller: self)
        } else {
            
            let localParameter = [
                "email": TF_UserName.text ?? "",
                "user_type": 1,
                "device_type" : "ios",
                ] as [String : Any]
            
            let Parameter = ["data": localParameter]
            
            showActivityIndicator(uiView: self.view)
            HalperBL.forgetPasswordAPICall(Parameter)
            
            return
        }
    }
    
    func forgetPasswordAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: (dict.GotValue(key: "message") as String), controller: self)
    }
    
    func forgetPasswordAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: massge, controller: self)
    }
    
    func forgetPasswordAPICallError(_ error: Error) {
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
        
        TF_UserName.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        TF_UserName.resignFirstResponder();
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == TF_UserName {
            
            TF_UserName.resignFirstResponder()
            
        } else {
            
            CloseKeyBoard()
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
