//
//  WriteMessage_VC.swift
//  Rising Leaders
//
//  Created by apple on 2/20/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class WriteMessage_VC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate, businessLogicLayerDelegate {

    @IBOutlet weak var Top_V : UIView!
    @IBOutlet weak var Name_LB : UILabel!
    @IBOutlet weak var IMG_IV : UIImageView!
    @IBOutlet weak var Send_BTN : App_BTN!
    @IBOutlet weak var Subject_TF : UITextField!
    @IBOutlet weak var MSG_TV : UITextView!
    @IBOutlet weak var Scroll_SV : UIScrollView!
    
    var receiver_id : String = ""
    var IMG_URL : String = ""
    var Name_STR : String = ""
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890 "
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = ScreenBGColor
        Top_V.backgroundColor = ScreenBGColor
        
        HalperBL.delegate = self
        
        Name_LB.textColor = hexStringToUIColor(hex: "#6C667D")
        IMG_IV.layer.cornerRadius = 27.0
        
        Name_LB.text = Name_STR
        
        IMG_IV.sd_setShowActivityIndicatorView(true)
        IMG_IV.sd_setIndicatorStyle(.gray)
        IMG_IV?.sd_setImage(with: NSURL(string:(IMG_URL))! as URL) { (image, error, cache, urls) in
            if (error != nil) {
            } else {
                self.IMG_IV.image = image
            }
        }
        
        Subject_TF.attributedPlaceholder = NSAttributedString(string: "Your Subject",
        attributes: [NSAttributedString.Key.foregroundColor: hexStringToUIColor(hex: "#403E76")])
        
        MSG_TV.placeholder = "Write your Message..."
        
        Subject_TF.delegate = self
        
        addDoneButtonOnKeyboard()
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
        
        Subject_TF.inputAccessoryView = doneToolbar
        MSG_TV.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        Subject_TF.resignFirstResponder();
        MSG_TV.resignFirstResponder();
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")

        return (string == filtered)
    }
    
    func CloseKeyBoard() {
        
        self.view.endEditing(true)
    }
    
    /**************************************************************************/
    //MARK:- Send Message /////////////////////////////////
    /**************************************************************************/
    
    @IBAction func SendMessage_BTN_Clicked(_ sender: Any) {
     
        CloseKeyBoard()
        
        let Subject_STR: String = Subject_TF.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        if (Subject_STR.isEmpty) {
            
            Toast.show(message: "Please write your Subject", controller: self)
            
        } else if MSG_TV.text?.isEmpty ?? false {
            
            Toast.show(message: "Please write your Message", controller: self)
            
        } else {
        
            msgSendByParent_InvokeAPI()
            
        }
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- msgSendByParent
    /**************************************************************************/
    
    func msgSendByParent_InvokeAPI() {
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available.", controller: self)
        } else {
            
            let user_id: String = UserDefaults.standard.string(forKey: "user_id") ?? ""
            
            let localParameter = [
                "subject" : Subject_TF.text ?? "",
                "textMessage": MSG_TV.text ?? "",
                "sender_id": user_id,
                "receiver_id": receiver_id,
                "user_type": 1,
                "device_type" : "ios",
                ] as [String : Any]
            
            let Parameter = ["data": localParameter]
            
            showActivityIndicator(uiView: self.view)
            HalperBL.msgSendByParentAPICall(Parameter)

            return
        }
    }
    
    func msgSendByParentAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: (dict.GotValue(key: "message") as String), controller: self)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func msgSendByParentAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: massge, controller: self)
    }
    
    func msgSendByParentAPICallError(_ error: Error) {
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
