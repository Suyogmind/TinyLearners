//
//  AppDelegate.swift
//  Rising Leaders
//
//  Created by apple on 2/18/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    var HomeNavi : UINavigationController?
    
    var appTab : UITabBarController?
    
    // **API base URL (development):**
//    let Base_URL:String = "http://18.222.48.241:4000/api/parent/" // Client
    
//    let Base_URL:String = "http://13.232.162.88:4001/api/" // MCT mehul.nahar@mindcrewtech.com
    
    let Base_URL:String = "http://34.221.190.186:4000/api/" // MCT nahar321@gmail.com
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /*
         FirebaseApp.configure()
         
         UNUserNotificationCenter.current().delegate = self
         
         let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
         UNUserNotificationCenter.current().requestAuthorization(
         options: authOptions,
         completionHandler: {_, _ in })
         
         application.registerForRemoteNotifications()
         
         Messaging.messaging().delegate = self
         */
        
        return true
    }
    
    /*
     func userNotificationCenter(_ center: UNUserNotificationCenter,
     willPresent notification: UNNotification,
     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
     let userInfo = notification.request.content.userInfo
     
     //        if let messageID = userInfo[gcmMessageIDKey] {
     //            print("Message ID: \(messageID)")
     //        }
     
     // Print full message.
     print(userInfo)
     let aps = userInfo["aps" as NSString] as? [String:AnyObject]
     //        str_reqestIdFromPN = (userInfo["requestId" as NSString] as? String) ?? ""
     //        let str_type = userInfo["type" as NSString] as? String
     
     guard let strAlert = aps?["alert"] as? String else {
     return
     }
     
     let notiData = HDNotificationData(
     iconImage:  UIImage(named: "pnicon"),
     appTitle: "Rising Leaders",
     title: "",
     message: strAlert,
     time: "now")
     
     HDNotificationView.show(data: notiData, onTap: {
     //                        self.isRIderRequestCome = true
     
     }, onDidDismiss: nil)
     
     //        if str_type == "sagerequest"{
     //            goAcceptRequestScreen()
     //        }
     
     // Change this to your preferred presentation option
     completionHandler([])
     }
     
     func userNotificationCenter(_ center: UNUserNotificationCenter,
     didReceive response: UNNotificationResponse,
     withCompletionHandler completionHandler: @escaping () -> Void) {
     let userInfo = response.notification.request.content.userInfo
     // Print message ID.
     //        if let messageID = userInfo[gcmMessageIDKey] {
     //            print("Message ID: \(messageID)")
     //        }
     print(userInfo)
     let aps = userInfo["aps" as NSString] as? [String:AnyObject]
     //        str_reqestIdFromPN = (userInfo["requestId" as NSString] as? String) ?? ""
     //        let str_type = userInfo["type" as NSString] as? String
     
     guard let strAlert = aps?["alert"] as? String else {
     return
     }
     
     let notiData = HDNotificationData(
     iconImage:  UIImage(named: "pnicon"),
     appTitle: "Rising Leaders",
     title: "",
     message: strAlert,
     time: "now")
     
     HDNotificationView.show(data: notiData, onTap: {
     //                        self.isRIderRequestCome = true
     
     }, onDidDismiss: nil)
     
     //        if str_type == "sagerequest"{
     ////            goAcceptRequestScreen()
     //        }
     
     
     completionHandler()
     }
     
     func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
     print("Received data message: \(remoteMessage.appData)")
     }
     
     func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
     // Request Authorization
     if #available(iOS 10.0, *) {
     UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
     if error != nil {
     //print("Request Authorization Failed (\(error), \(error.localizedDescription))")
     }
     completionHandler(success)
     }
     } else {
     // Fallback on earlier versions
     }
     }
     
     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
     if Auth.auth().canHandle(url) {
     return true
     }
     
     return true
     }
     
     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
     // If you are receiving a notification message while your app is in the background,
     // this callback will not be fired till the user taps on the notification launching the application.
     // TODO: Handle data of notification
     // With swizzling disabled you must let Messaging know about the message, for Analytics
     // Messaging.messaging().appDidReceiveMessage(userInfo)
     // Print message ID.
     //        if let messageID = userInfo[gcmMessageIDKey] {
     //            print("Message ID: \(messageID)")
     //        }
     
     // Print full message.
     print(userInfo)
     }
     
     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void){
     
     Messaging.messaging().appDidReceiveMessage(userInfo)
     // print(userInfo)
     if Auth.auth().canHandleNotification(userInfo) {
     completionHandler(UIBackgroundFetchResult.newData)
     return
     }
     //        if let messageID = userInfo[gcmMessageIDKey] {
     //            print("Message ID: \(messageID)")
     //        }
     //        let aps = userInfo["aps" as NSString] as? [String:AnyObject]
     
     completionHandler(UIBackgroundFetchResult.newData)
     }
     
     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
     print("Unable to register for remote notifications: \(error.localizedDescription)")
     }
     
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
     Auth.auth().setAPNSToken(deviceToken, type: .unknown)
     
     // print(deviceToken)
     var token: String = ""
     for i in 0..<deviceToken.count {
     token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
     }
     
     print("token = ", token)
     
     UserDefaults.standard.set(token, forKey: "deviceToken")
     Messaging.messaging().apnsToken = deviceToken
     // self.window?.rootViewController?.present(alert, animated: true, completion: nil)
     }
     
     func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
     
     InstanceID.instanceID().instanceID { (result, error) in
     if let error = error {
     print("Error fetching remote instance ID: \(error)")
     } else if let result = result {
     print("Remote instance ID token: \(result.token)")
     // self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
     }
     }
     let dataDict:[String: String] = ["token": fcmToken]
     NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
     }
     */
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

