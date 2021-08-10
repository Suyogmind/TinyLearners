//
//  businessLogicLayer.swift
//  barberApp
//
//  Created by MindCrewTech on 05/12/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
@objc protocol businessLogicLayerDelegate {
    
    //MARK:- Protocol methods
    
    // schoolLocation
    @objc optional func schoolLocationAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func schoolLocationAPICallMessage(_ message: String)
    @objc optional func schoolLocationAPICallError(_ error: Error)
    
    // signUp
    @objc optional func signUpAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func signUpAPICallMessage(_ message: String)
    @objc optional func signUpAPICallError(_ error: Error)
    
    // login
    @objc optional func loginAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func loginAPICallMessage(_ message: String)
    @objc optional func loginAPICallError(_ error: Error)
    
    // getAnnouncement
    @objc optional func getAnnouncementAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func getAnnouncementAPICallMessage(_ message: String)
    @objc optional func getAnnouncementAPICallError(_ error: Error)
    
    // getAttendance
    @objc optional func getAttendanceAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func getAttendanceAPICallMessage(_ message: String)
    @objc optional func getAttendanceAPICallError(_ error: Error)
    
    // getActivities
    @objc optional func getActivitiesAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func getActivitiesAPICallMessage(_ message: String)
    @objc optional func getActivitiesAPICallError(_ error: Error)
    
    // getFeedbackList
    @objc optional func getFeedbackListAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func getFeedbackListAPICallMessage(_ message: String)
    @objc optional func getFeedbackListAPICallError(_ error: Error)
    
    // getContactList
    @objc optional func getContactListAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func getContactListAPICallMessage(_ message: String)
    @objc optional func getContactListAPICallError(_ error: Error)
    
    // msgSendByParent
    @objc optional func msgSendByParentAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func msgSendByParentAPICallMessage(_ message: String)
    @objc optional func msgSendByParentAPICallError(_ error: Error)
    
    // replyFromParents
    @objc optional func replyFromParentsAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func replyFromParentsAPICallMessage(_ message: String)
    @objc optional func replyFromParentsAPICallError(_ error: Error)
    
    // getThreadList
    @objc optional func getThreadListAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func getThreadListAPICallMessage(_ message: String)
    @objc optional func getThreadListAPICallError(_ error: Error)
    
    // dashboard
    @objc optional func dashboardAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func dashboardAPICallMessage(_ message: String)
    @objc optional func dashboardAPICallError(_ error: Error)
    
    // getNotification
    @objc optional func getNotificationAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func getNotificationAPICallMessage(_ message: String)
    @objc optional func getNotificationAPICallError(_ error: Error)
    
    // forgetPassword
    @objc optional func forgetPasswordAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func forgetPasswordAPICallMessage(_ message: String)
    @objc optional func forgetPasswordAPICallError(_ error: Error)
    
    // changePassword
    @objc optional func changePasswordAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func changePasswordAPICallMessage(_ message: String)
    @objc optional func changePasswordAPICallError(_ error: Error)
    
    // parent/upcomingActivities
    @objc optional func upcomingActivitiesAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func upcomingActivitiesAPICallMessage(_ message: String)
    @objc optional func upcomingActivitiesAPICallError(_ error: Error)
    
    // parent/completedActivities
    @objc optional func completedActivitiesAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func completedActivitiesAPICallMessage(_ message: String)
    @objc optional func completedActivitiesAPICallError(_ error: Error)
    
    // users/getGallery
    @objc optional func getGalleryAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func getGalleryAPICallMessage(_ message: String)
    @objc optional func getGalleryAPICallError(_ error: Error)
    
    // parent/getEvents
    @objc optional func getEventsAPICallFinished(_ dictUserData: NSDictionary)
    @objc optional func getEventsAPICallMessage(_ message: String)
    @objc optional func getEventsAPICallError(_ error: Error)
}

class businessLogicLayer: NSObject {
    
//    "device_type": "1" iOS
    
    //MARK:- Start of Class
    
    // **API base URL (production):**
//    let strBaseURL:String = "https://api.stepjockey.com/"
    
    // **API base URL (development):**
    let strBaseURL:String = APPDELEGATE.Base_URL
    
    var delegate: businessLogicLayerDelegate?
    
    //-----------------schoolLocation
    
    func schoolLocationAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/schoolLocation"
        
        print("API URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        
                        self.delegate?.schoolLocationAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.schoolLocationAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.schoolLocationAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.schoolLocationAPICallError!(error!)
            })
        })
    }
    
    //-----------------signUp
    
    func signUpAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/signUp"
        
        print("API URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        
                        self.delegate?.signUpAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.signUpAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.signUpAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.signUpAPICallError!(error!)
            })
        })
    }
    
    //-----------------login
    
    func loginAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/login"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.loginAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.loginAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.loginAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.loginAPICallError!(error!)
            })
        })
    }
    
    //-----------------getAnnouncement
    
    func getAnnouncementAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/getAnnouncement"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.getAnnouncementAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.getAnnouncementAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.getAnnouncementAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.getAnnouncementAPICallError!(error!)
            })
        })
    }
    
    //-----------------getAttendance
    
    func getAttendanceAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/getAttendance"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.getAttendanceAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.getAttendanceAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.getAttendanceAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.getAttendanceAPICallError!(error!)
            })
        })
    }
    
    //-----------------getActivities
    
    func getActivitiesAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/getActivities"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.getActivitiesAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.getActivitiesAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.getActivitiesAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.getActivitiesAPICallError!(error!)
            })
        })
    }
    
    //-----------------getFeedbackList
    
    func getFeedbackListAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/getFeedbackList"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.getFeedbackListAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.getFeedbackListAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.getFeedbackListAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.getFeedbackListAPICallError!(error!)
            })
        })
    }
    
    //-----------------getContactList
    
    func getContactListAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/getContactList"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.getContactListAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.getContactListAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.getContactListAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.getContactListAPICallError!(error!)
            })
        })
    }
    
    //-----------------msgSendByParent
    
    func msgSendByParentAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/msgSendByParent"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.msgSendByParentAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.msgSendByParentAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.msgSendByParentAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.msgSendByParentAPICallError!(error!)
            })
        })
    }
    
    //-----------------replyFromParents
    
    func replyFromParentsAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/replyFromParents"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.replyFromParentsAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.replyFromParentsAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.replyFromParentsAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.replyFromParentsAPICallError!(error!)
            })
        })
    }
    
    //-----------------getThreadList
    
    func getThreadListAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/getThreadList"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.getThreadListAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.getThreadListAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.getThreadListAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.getThreadListAPICallError!(error!)
            })
        })
    }
    
    //-----------------dashboard
    
    func dashboardAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/dashboard"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.dashboardAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.dashboardAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.dashboardAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.dashboardAPICallError!(error!)
            })
        })
    }
    
    //-----------------getNotification
    
    func getNotificationAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/getNotification"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.getNotificationAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.getNotificationAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.getNotificationAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.getNotificationAPICallError!(error!)
            })
        })
    }
    
    //-----------------forgetPassword
    
    func forgetPasswordAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/forgetPassword"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.forgetPasswordAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.forgetPasswordAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.forgetPasswordAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.forgetPasswordAPICallError!(error!)
            })
        })
    }
    
    //-----------------changePassword
    
    func changePasswordAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/changePassword"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.changePasswordAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.changePasswordAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.changePasswordAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.changePasswordAPICallError!(error!)
            })
        })
    }
    
    //-----------------upcomingActivities
    
    func upcomingActivitiesAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/upcomingActivities"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.upcomingActivitiesAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.upcomingActivitiesAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.upcomingActivitiesAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.upcomingActivitiesAPICallError!(error!)
            })
        })
    }
    
    //-----------------completedActivities
    
    func completedActivitiesAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/completedActivities"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.completedActivitiesAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.completedActivitiesAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.completedActivitiesAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.completedActivitiesAPICallError!(error!)
            })
        })
    }
    
    //-----------------users/getGallery
    
    func getGalleryAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "users/getGallery"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.getGalleryAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.getGalleryAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.getGalleryAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.getGalleryAPICallError!(error!)
            })
        })
    }
    
    //-----------------parent/getEvents
    
    func getEventsAPICall(_ dictParameter:[String : Any])
    {
        let API_URL = self.strBaseURL + "parent/getEvents"
        
        print("URL : \(API_URL)")
        print("Parameter : \(dictParameter)")

        WebServiceHandler.shared.callWebService(withData: dictParameter, strURL:API_URL, success: {(_ json: [AnyHashable: Any]) -> Void in
            DispatchQueue.main.async(execute: {
                if (json as? NSDictionary) != nil{

                    print("Replay : \(json)")

                    let status = json["status"] as! NSString
                    if (status.isEqual(to: "true")) {
                        self.delegate?.getEventsAPICallFinished?(json as NSDictionary)
                        
                    } else {
                        
                        if let msg = json["message"] as? NSString {
                            self.delegate?.getEventsAPICallMessage!(msg as String)
                        } else {
                            self.delegate?.getEventsAPICallMessage!("Oops! something went wrong" as String)
                        }
                    }
                }
            })
        }, failure: {(_ error: Error?) -> Void in

            DispatchQueue.main.async(execute: {
                self.delegate?.getEventsAPICallError!(error!)
            })
        })
    }
}
