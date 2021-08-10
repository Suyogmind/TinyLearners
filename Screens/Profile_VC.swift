//
//  Profile_VC.swift
//  Rising Leaders
//
//  Created by apple on 2/19/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit
import Alamofire
import RSKImageCropper

class Profile_VC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UIPopoverControllerDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource, businessLogicLayerDelegate {
    
    @IBOutlet weak var Profile_IV : UIImageView!
    @IBOutlet weak var LB_Name : UILabel!
    
    @IBOutlet weak var SV_Scroll : UIScrollView!
    
    @IBOutlet weak var TF_ParentName : UITextField!
    @IBOutlet weak var TF_Email : UITextField!
    @IBOutlet weak var TF_School : UITextField!
    @IBOutlet weak var TF_ContactNumber1 : UITextField!
    @IBOutlet weak var TF_ContactNumber2 : UITextField!
    @IBOutlet weak var TF_KidName : UITextField!
    @IBOutlet weak var TF_DOB : UITextField!
    @IBOutlet weak var TF_Height : UITextField!
    @IBOutlet weak var TF_Weight : UITextField!
    @IBOutlet weak var TV_Info : UITextView!
    
    @IBOutlet weak var Update_BTN : UIButton!
    
    let NAME_ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "

    let NO_ACCEPTABLE_CHARACTERS = "1234567890"
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890 "
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    var Height_Array = ["2 foot 0 inches",
                        "2 foot 1 inches",
                        "2 foot 2 inches",
                        "2 foot 3 inches",
                        "2 foot 4 inches",
                        "2 foot 5 inches",
                        "2 foot 6 inches",
                        "2 foot 7 inches",
                        "2 foot 8 inches",
                        "2 foot 9 inches",
                        "2 foot 10 inches",
                        "2 foot 11 inches",
                        "3 foot 0 inches",
                        "3 foot 1 inches",
                        "3 foot 2 inches",
                        "3 foot 3 inches",
                        "3 foot 4 inches",
                        "3 foot 5 inches",
                        "3 foot 6 inches",
                        "3 foot 7 inches",
                        "3 foot 8 inches",
                        "3 foot 9 inches",
                        "3 foot 10 inches",
                        "3 foot 11 inches",
                        "4 foot 0 inches"]
    
    var Weight_Array = ["21 lbs",
                        "22 lbs",
                        "23 lbs",
                        "24 lbs",
                        "25 lbs",
                        "26 lbs",
                        "27 lbs",
                        "28 lbs",
                        "29 lbs",
                        "30 lbs",
                        "31 lbs",
                        "32 lbs",
                        "33 lbs",
                        "34 lbs",
                        "35 lbs",
                        "36 lbs",
                        "37 lbs",
                        "38 lbs",
                        "39 lbs",
                        "40 lbs",
                        "41 lbs",
                        "42 lbs",
                        "43 lbs",
                        "44 lbs",
                        "45 lbs",
                        "46 lbs",
                        "47 lbs",
                        "48 lbs",
                        "49 lbs",
                        "50 lbs",]
    
    let datePickerView    : UIDatePicker = UIDatePicker()
    var popover   : UIPopoverController? = nil
    var isImageUpdate        : Bool = false
    var chosenImage          : UIImage!
    
    let listPicker = PickerDialog (
        textColor: UIColor(red: 61/255, green: 187/255, blue: 234/255, alpha: 1),
        buttonColor: hexStringToUIColor(hex: "#2D31AC"),
        font: UIFont(name: "AvenirNext-Medium", size: 20) ?? UIFont.boldSystemFont(ofSize: 17),
        showCancelButton: true
    )
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APPDELEGATE.HomeNavi = self.navigationController
    }
    
    func GetAndShowContent() {
        
        if let dict: NSDictionary = UserDefaults.standard.value(forKey: "kidDetails") as? NSDictionary {
            
            LB_Name.text = dict.GotValue(key: "kid_name") as String
            
            TF_ParentName.text = dict.GotValue(key: "gardian_name") as String
            TF_Email.text = dict.GotValue(key: "email") as String
            TF_School.text = dict.GotValue(key: "school_name") as String
            TF_ContactNumber1.text = dict.GotValue(key: "phone") as String
            TF_ContactNumber2.text = dict.GotValue(key: "other_phone") as String
            TF_KidName.text = dict.GotValue(key: "kid_name") as String
            TF_DOB.text = dict.GotValue(key: "dob") as String
            TF_Height.text = dict.GotValue(key: "height") as String
            TF_Weight.text = dict.GotValue(key: "weight") as String
            TV_Info.text = dict.GotValue(key: "kid_info") as String
            
            if (dict.GotValue(key: "dob") as String).count > 0 {
            
                TF_DOB.text = Show_DF().string(from: (API_DF().date(from: (dict.GotValue(key: "dob") as String))!))
            }
            
            Profile_IV.backgroundColor = hexStringToUIColor(hex: "#2D31AC")
            Profile_IV.sd_setShowActivityIndicatorView(true)
            Profile_IV.sd_setIndicatorStyle(.gray)
            Profile_IV?.sd_setImage(with: NSURL(string:((dict.GotValue(key: "profile_pic") as String)))! as URL) { (image, error, cache, urls) in
                if (error != nil) {
                    self.Profile_IV.image = UIImage(named: "SideMenuProfile")
                } else {
                    self.Profile_IV.image = image
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        SV_Scroll.contentSize = CGSize(width: CurrentDevice.ScreenWidth, height: (Update_BTN.frame.origin.y+100.0))
    }
    
    @objc func SetScrollContentSize() {
        
        SV_Scroll.contentSize = CGSize(width: CurrentDevice.ScreenWidth, height: (Update_BTN.frame.origin.y+100.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = ScreenBGColor
        
        HalperBL.delegate = self
        
        Profile_IV.layer.cornerRadius = 42.0
        Profile_IV.clipsToBounds = true
        
        TF_ParentName.textColor = hexStringToUIColor(hex: "#8780A1")
        TF_Email.textColor = hexStringToUIColor(hex: "#8780A1")
        TF_School.textColor = hexStringToUIColor(hex: "#8780A1")
        
        LB_Name.font = UIFont.systemFont(ofSize: 16.0)
        LB_Name.textColor = hexStringToUIColor(hex: "#100043")
        
        TF_ParentName.backgroundColor = hexStringToUIColor(hex: "#EDEBF3")
        TF_Email.backgroundColor = hexStringToUIColor(hex: "#EDEBF3")
        TF_School.backgroundColor = hexStringToUIColor(hex: "#EDEBF3")
        
        LB_Name.underline()
        
        TF_ParentName.delegate = self
        TF_Email.delegate = self
        TF_School.delegate = self
        TF_ContactNumber1.delegate = self
        TF_ContactNumber2.delegate = self
        TF_KidName.delegate = self
        TF_DOB.delegate = self
        TF_Height.delegate = self
        TF_Weight.delegate = self
        TV_Info.delegate = self
        
        TF_ParentName.isUserInteractionEnabled = false
        TF_Email.isUserInteractionEnabled = false
        TF_School.isUserInteractionEnabled = false
        
        TF_ContactNumber1.addPlaceHolder(str_placeholder: "Enter Contact Number 1")
        TF_ContactNumber2.addPlaceHolder(str_placeholder: "Enter Contact Number 2")
        TF_KidName.addPlaceHolder(str_placeholder: "Enter Kid's Name")
        TF_DOB.addPlaceHolder(str_placeholder: "Select Date of Birth")
        TF_Height.addPlaceHolder(str_placeholder: "Select Kid's Height")
        TF_Weight.addPlaceHolder(str_placeholder: "Select Kid's Weight")
//        TV_Info.addPlaceHolder(str_placeholder: "")
        
        let DOB_RVM = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        DOB_RVM.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        DOB_RVM.setImage(UIImage(named: "tf_cal"), for: .normal)
        TF_DOB.rightView = DOB_RVM
        TF_DOB.rightViewMode = .always
        
        let TF_ContactNumber1_LVM = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 40.0))
        TF_ContactNumber1_LVM.setTitle("+1", for: .normal)
        TF_ContactNumber1_LVM.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        TF_ContactNumber1_LVM.setTitleColor(hexStringToUIColor(hex: "#100043"), for: .normal)
        TF_ContactNumber1.leftView = TF_ContactNumber1_LVM
        TF_ContactNumber1.leftViewMode = .always
        
        let TF_ContactNumber2_LVM = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 60.0, height: 40.0))
        TF_ContactNumber2_LVM.setTitle("+1", for: .normal)
        TF_ContactNumber2_LVM.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        TF_ContactNumber2_LVM.setTitleColor(hexStringToUIColor(hex: "#100043"), for: .normal)
        TF_ContactNumber2.leftView = TF_ContactNumber2_LVM
        TF_ContactNumber2.leftViewMode = .always
        
        let Height_RVM = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        Height_RVM.contentEdgeInsets = UIEdgeInsets(top: 15.5, left: 13.0, bottom: 15.5, right: 13.0)
        Height_RVM.setImage(UIImage(named: "dropDown"), for: .normal)
        TF_Height.rightView = Height_RVM
        TF_Height.rightViewMode = .always
        
        let Weight_RVM = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        Weight_RVM.contentEdgeInsets = UIEdgeInsets(top: 15.5, left: 13.0, bottom: 15.5, right: 13.0)
        Weight_RVM.setImage(UIImage(named: "dropDown"), for: .normal)
        TF_Weight.rightView = Weight_RVM
        TF_Weight.rightViewMode = .always
        
        addDoneButtonOnKeyboard()
        
        SV_Scroll.contentSize = CGSize(width: CurrentDevice.ScreenWidth, height: (Update_BTN.frame.origin.y+100.0))
        
        GetAndShowContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.perform(#selector(SetScrollContentSize), with: nil, afterDelay: 0.5)
    }
    
    @IBAction func Validation(_ sender: UIButton) {
        
        if TF_ContactNumber1.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Enter Contact Number 1", controller: self)
            
        } else if TF_KidName.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Enter Kid's Name", controller: self)
            
        } else if TF_DOB.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Select Date of Birth", controller: self)
            
        } else if TF_Height.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Select Height", controller: self)
            
        } else if TF_Weight.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Select Weight", controller: self)
            
        } else if TV_Info.text?.isEmpty ?? false {
            
            Toast.show(message: "Please Enter Info", controller: self)
            
        } else {
            
            UpdateProfile_InvokeAPI()
            
        }
    }
    
    func UpdateProfile_InvokeAPI() {
        
        showActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
        
        let url = (APPDELEGATE.Base_URL + "updateKidInfo")
        
        let user_id : String = UserDefaults.standard.value(forKey: "user_id") as! String
        
        var update_image = "0"
        
        if self.isImageUpdate {
            
            update_image = "1"
        }
        
        let now = Date()
        let birthday: Date = Show_DF().date(from: self.TF_DOB.text!)!
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.month], from: birthday, to: now)
        let age = ageComponents.month!
        
        let data_ = ["kid_name" : TF_KidName.text ?? "",
                     "updateImageFlag" : update_image,
                     "phone" : TF_ContactNumber1.text ?? "",
                     "other_phone" : TF_ContactNumber2.text ?? "",
                     "dob" : (API_DF().string(from: (Show_DF().date(from: self.TF_DOB.text!)!))),
                     "age" : "\(age)",
                     "kid_info" : TV_Info.text ?? "",
                     "height" : TF_Height.text ?? "",
                     "weight" : TF_Weight.text ?? "",
                     "kid_id" : user_id,
                     "device_type" : "ios",
                     "user_type": "1"]
        
        print("Parm : \(data_)")
        
        Alamofire.upload (
            multipartFormData: { multipartFormData in
                
                if self.isImageUpdate {
                    
                    let imgData = self.chosenImage!.jpegData(compressionQuality: 0.5)!
                    
                    multipartFormData.append(imgData, withName: "profile_pic",fileName: "image.jpeg", mimeType: "image/jpeg")
                    
                    for (key, value) in data_ {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                } else {
                    
                    let imgData: Data = NSData() as Data
                    
                    multipartFormData.append(imgData, withName: "profile_pic",fileName: "image.jpeg", mimeType: "image/jpeg")
                    
                    for (key, value) in data_ {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
                
        },
            to: url,
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        debugPrint(response)
                    }
                        .uploadProgress { progress in // main queue by default
                            
                            //                            print("Upload Progress: \(progress.fractionCompleted)")
                    }
                    upload.responseJSON { response in
                        
                        hideActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
                        
                        if let dic = response.result.value as? NSDictionary {
                            
                            if (dic.GotValue(key: "status").isEqual(to: "true")) {
                                
                                let LocalDict:NSDictionary = dic.value(forKey: "data") as! NSDictionary

                                UserDefaults.standard.set(LocalDict, forKey: "kidDetails")
                                UserDefaults.standard.synchronize()
                                
                                self.GetAndShowContent()
                            }
                            
                            Toast.show(message: (dic.GotValue(key: "message") as String), controller: self)
                        }
                    }
                    return
                case .failure(let encodingError):
                    
                    hideActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
                    
                    debugPrint(encodingError)
                }
        })
    }
    
    @IBAction func Notifications_VC_Open(_ sender: UIButton) {
        
        let screen = self.storyboard!.instantiateViewController(withIdentifier: "Notifications_VC") as! Notifications_VC
        self.navigationController?.pushViewController(screen, animated: true);
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
        
        
        TF_ParentName.inputAccessoryView = doneToolbar
        TF_Email.inputAccessoryView = doneToolbar
        TF_School.inputAccessoryView = doneToolbar
        TF_ContactNumber1.inputAccessoryView = doneToolbar
        TF_ContactNumber2.inputAccessoryView = doneToolbar
        TF_KidName.inputAccessoryView = doneToolbar
        TF_DOB.inputAccessoryView = doneToolbar
        TF_Height.inputAccessoryView = doneToolbar
        TF_Weight.inputAccessoryView = doneToolbar
        TV_Info.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        TF_ParentName.resignFirstResponder();
        TF_Email.resignFirstResponder();
        TF_School.resignFirstResponder();
        TF_ContactNumber1.resignFirstResponder();
        TF_ContactNumber2.resignFirstResponder();
        TF_KidName.resignFirstResponder();
        TF_DOB.resignFirstResponder();
        TF_Height.resignFirstResponder();
        TF_Weight.resignFirstResponder();
        TV_Info.resignFirstResponder();
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == TF_DOB {
            
            let vc = SambagDatePickerViewController()
            vc.theme = .light
            vc.delegate = self
            present(vc, animated: true, completion: nil)
            
            return false
        } else if textField == TF_School {
            
            return false
        } else if textField == TF_Height {
            
            listPicker.showPicker("Please select", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", PickerArrayValue: Height_Array, parentView: (self.tabBarController?.view ?? self.view)) { (val) in

                if val != -1 {
                
                    self.TF_Height.text = self.Height_Array[val]
                }
                
                print(val)
            }
            
            return false
        } else if textField == TF_Weight {
            
            listPicker.showPicker("Please select", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", PickerArrayValue: Weight_Array, parentView: (self.tabBarController?.view ?? self.view)) { (val) in

                if val != -1 {
                    self.TF_Weight.text = self.Weight_Array[val]
                }
                
                print(val)
            }
            
            return false
        }
     
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == TF_ContactNumber1 {
            
            TF_ContactNumber1.resignFirstResponder()
            TF_ContactNumber2.becomeFirstResponder()
            
        } else if textField == TF_ContactNumber2 {
            
            TF_ContactNumber2.resignFirstResponder()
            TF_KidName.becomeFirstResponder()
            
        } else if textField == TF_KidName {
            
            TF_KidName.resignFirstResponder()
            TF_Height.becomeFirstResponder()
            
        } else if textField == TF_Height {
            
            TF_Height.resignFirstResponder()
            TF_Weight.becomeFirstResponder()
            
        } else if textField == TF_Weight {
            
            TF_Weight.resignFirstResponder()
            TV_Info.becomeFirstResponder()
            
        } else if textField == TV_Info {
            
            TV_Info.resignFirstResponder()
            
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
    
    // Use this if you have a UITextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = text.components(separatedBy: cs).joined(separator: "")

        return (text == filtered)
    }
    
    func CloseKeyBoard() {
        
        self.view.endEditing(true)
    }
    
    /************************************************************************/
    //MARK:- Open Device camera and gallery
    /************************************************************************/
    
    @IBAction func ActionForOpenCameraAndgallery(_ sender: Any) {
        
        let alert:UIAlertController=UIAlertController(title: NSLocalizedString("Choose Option", comment: ""), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallery  = UIAlertAction(title: NSLocalizedString("Gallery", comment: ""), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.galleryOpen()
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            popover = UIPopoverController(contentViewController: alert)
            popover!.present(from: Profile_IV.frame, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        }
    }
    
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func galleryOpen()
    {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = false
        imagePickerVC.sourceType = .savedPhotosAlbum
        
        self.present(imagePickerVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if (!(picker.sourceType == UIImagePickerController.SourceType.photoLibrary)) {
            
            picker.dismiss(animated: false, completion: nil)
            self.afterImagePickerSelection(true, pickedProfile: (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!)
            
        } else {
            
            let assetPath = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
            if (assetPath.absoluteString?.hasSuffix("GIF"))! {
                picker.dismiss(animated: true, completion: nil)
                
                picker.dismiss(animated: false, completion: nil)
                Toast.show(message: "GIF image not supported.", controller: self)
                
            } else {
                
                picker.dismiss(animated: false, completion: nil)
                
                self.afterImagePickerSelection(true, pickedProfile: (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!)
            }
        }
    }
    
    //MARK:- IMAGE CROPPER
    func afterImagePickerSelection(_ flag: Bool, pickedProfile: UIImage) {
        
        let imageCropVC = RSKImageCropViewController(image: pickedProfile, cropMode: .circle)
        imageCropVC.delegate = self
        imageCropVC.dataSource = self
        
        self.present(imageCropVC, animated: false, completion: nil)
    }
    
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        
        //        return CGRect(x: 0.0, y: 0.0 , width: CurrentDevice.ScreenWidth, height: CurrentDevice.ScreenHeight)
        return CGRect(x: 0, y: self.view.frame.size.height/2 - self.view.frame.size.height/5 , width: self.view.frame.size.width, height: self.view.frame.size.height/2 - 35)
    }
    
    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        
        return UIBezierPath(rect: controller.maskRect)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        
        // ...
    }
    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        let rect = controller.maskRect
        return rect
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        
        self.dismiss(animated: true, completion: nil)
        
        let img = resizeImage(image: croppedImage, targetSize: CGSize(width: 200.0, height: 200.0))
        
        self.isImageUpdate = true
        
        Profile_IV.image = img
        
        chosenImage = img
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

extension Profile_VC: SambagDatePickerViewControllerDelegate {

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

extension UILabel {
    
    func underline() {
        
        if let textString = self.text {
            
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .semibold)
                , range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
