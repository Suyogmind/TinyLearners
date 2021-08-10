//
//  Gallery_VC.swift
//  Rising Leaders
//
//  Created by apple on 2/19/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class Gallery_VC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, businessLogicLayerDelegate {
    
    @IBOutlet weak var Info_CV : UICollectionView!
    
    // Pop up
    @IBOutlet weak var IMGPopUp_V : UIView!
    @IBOutlet weak var Img_IV : UIImageView!
    
    var Gallery_JsonArray: NSMutableArray = NSMutableArray()
    
    let HalperBL: businessLogicLayer = businessLogicLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APPDELEGATE.HomeNavi = self.navigationController
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        IMGPopUp_V.frame = CGRect(x: 0.0, y: 0.0, width: CurrentDevice.ScreenWidth, height: CurrentDevice.ScreenHeight)
        
        Img_IV.frame = CGRect(x: ((CurrentDevice.ScreenWidth-(CurrentDevice.ScreenWidth-20.0))/2), y: ((CurrentDevice.ScreenHeight-(CurrentDevice.ScreenWidth-20.0))/2), width: (CurrentDevice.ScreenWidth-20.0), height: (CurrentDevice.ScreenWidth-20.0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        HalperBL.delegate = self
        
        self.view.backgroundColor = ScreenBGColor
        
        Info_CV.delegate = self
        Info_CV.dataSource = self
        Info_CV.register(UINib(nibName: "PhotosGallery_CVCell", bundle: nil), forCellWithReuseIdentifier: "PhotosGallery_CVCell")
        Info_CV.register(UINib(nibName: "AddPhotoVideo_CVCell", bundle: nil), forCellWithReuseIdentifier: "AddPhotoVideo_CVCell")
        Info_CV.reloadData()
        Info_CV.backgroundColor = UIColor.clear
        
        //-------------------------- Image Pop Up
        Img_IV.frame = CGRect(x: ((CurrentDevice.ScreenWidth-(CurrentDevice.ScreenWidth-20.0))/2), y: ((CurrentDevice.ScreenHeight-(CurrentDevice.ScreenWidth-20.0))/2), width: (CurrentDevice.ScreenWidth-20.0), height: (CurrentDevice.ScreenWidth-20.0))
        
        IMGPopUp_V.frame = CGRect(x: 0.0, y: 0.0, width: CurrentDevice.ScreenWidth, height: CurrentDevice.ScreenHeight)
        self.view.addSubview(IMGPopUp_V)
        IMGPopUp_V.isHidden = true
        
        Img_IV.layer.cornerRadius = 30
        Img_IV.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getGallery_InvokeAPI()
    }
    
    /**************************************************************************/
    //MARK:-  Api Call :- users/getGallery
    /**************************************************************************/
    
    func getGallery_InvokeAPI() {
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available.", controller: self)
            
        } else {
            
            let user_id: String = UserDefaults.standard.string(forKey: "user_id") ?? ""
            
            let localParameter = [
                "kid_id": user_id,
                "device_type": "1"
                ] as [String : Any]
            
            let Parameter = ["data": localParameter]
            
            showActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
            HalperBL.getGalleryAPICall(Parameter)

            return
        }
    }
    
    func getGalleryAPICallFinished(_ dict : NSDictionary) {
        hideActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
        
        Gallery_JsonArray = NSMutableArray(array: dict.value(forKey: "data") as! NSArray)
        
        Info_CV.reloadData()
    }
    
    func getGalleryAPICallMessage(_ massge : String) {
        hideActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
        
        Gallery_JsonArray = NSMutableArray()
        Info_CV.reloadData()
        
        Toast.show(message: massge, controller: self)
    }
    
    func getGalleryAPICallError(_ error: Error) {
        hideActivityIndicator(uiView: (self.navigationController?.view ?? self.view))
        
        Gallery_JsonArray = NSMutableArray()
        Info_CV.reloadData()
        
        Toast.show(message: "Something went wrong. Please try again!", controller: self)
    }
    
    @IBAction func Notifications_VC_Open(_ sender: UIButton) {
        
        let screen = self.storyboard!.instantiateViewController(withIdentifier: "Notifications_VC") as! Notifications_VC
        self.navigationController?.pushViewController(screen, animated: true);
    }
    
    /**************************************************************************/
    //MARK:- Big Image /////////////////////////////////
    /**************************************************************************/
    
    @IBAction func Close_IMGPopUp(_ sender: Any) {
        
        IMGPopUp_V.isHidden = true
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
extension Gallery_VC {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: ((CurrentDevice.ScreenWidth-2)/3), height: ((CurrentDevice.ScreenWidth-2)/3))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Gallery_JsonArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosGallery_CVCell", for: indexPath) as? PhotosGallery_CVCell else { return UICollectionViewCell() }
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        
        cell.IMG_IV.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        
        cell.Date_LB.adjustsFontSizeToFitWidth = true
        cell.Date_LB.textColor = hexStringToUIColor(hex: "#403E76")
        
        let dict :NSDictionary = Gallery_JsonArray.object(at: indexPath.row) as! NSDictionary
        
        cell.Date_LB.text = (dict.GotValue(key: "date") as String)
        
        cell.IMG_IV.sd_setShowActivityIndicatorView(true)
        cell.IMG_IV.sd_setIndicatorStyle(.gray)
        cell.IMG_IV?.sd_setImage(with: NSURL(string:((dict.GotValue(key: "url") as String)))! as URL) { (image, error, cache, urls) in
            if (error != nil) {
                //                    cell.imgeForYum.image = UIImage(named: "ipad2")
            } else {
                cell.IMG_IV.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dict :NSDictionary = Gallery_JsonArray.object(at: indexPath.row) as! NSDictionary
        
        IMGPopUp_V.isHidden = false
        
        Img_IV.sd_setShowActivityIndicatorView(true)
        Img_IV.sd_setIndicatorStyle(.gray)
        Img_IV?.sd_setImage(with: NSURL(string:((dict.GotValue(key: "url") as String)))! as URL) { (image, error, cache, urls) in
            if (error != nil) {
                //                    cell.imgeForYum.image = UIImage(named: "ipad2")
            } else {
                self.Img_IV.image = image
            }
        }
    }
}
