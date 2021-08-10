//
//  Utility.swift
//  Noyo
//
//  Created by Retina on 06/08/18.
//  Copyright © 2018 Pavan. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate

// Color
let TopMenuBGColor = UIColor.clear
//let TopMenuBGColor = UIColor(red: 253.0/255.0, green: 83.0/255.0, blue: 101.0/255.0, alpha: 1.0)
let BtnBGColor = UIColor(red: 253.0/255.0, green: 83.0/255.0, blue: 101.0/255.0, alpha: 1.0)
let PinkColor = UIColor(red: 253.0/255.0, green: 83.0/255.0, blue: 101.0/255.0, alpha: 1.0)
let appGreenColor = UIColor(red: 106.0/255.0, green: 123.0/255.0, blue: 64.0/255.0, alpha: 1.0)
let ScreenBGColor = UIColor(red: 247.0/255.0, green: 248.0/255.0, blue: 250.0/255.0, alpha: 1)
let BTNRedColor = UIColor(red: 243.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)

let Placeholder_Color = UIColor(red: 175.0/255.0, green: 175.0/255.0, blue: 194.0/255.0, alpha: 1.0) // afafc2

let LightWhite_Color = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)

let ColorGreen = UIColor(red: 72.0/255.0, green: 189.0/255.0, blue: 156.0/255.0, alpha: 1.0)

let ColorTextDarker = UIColor(red: 90.0/255.0, green: 85.0/255.0, blue: 78.0/255.0, alpha: 1.0)
let ColorScreenBG = UIColor(red: 242.0/255.0, green: 244.0/255.0, blue: 248.0/255.0, alpha: 1.0)

let CC_SHA256_DIGEST_LENGTH = 32
let kSJMagicLinkSecret = "7f4098da-2fa9-48b3-a6d8-2f7956ed6536"

let FontNameGotham = "Gotham-Book"
let FontNameGothamRounded = "GothamRounded-Book"
let FontNameGothamRoundedMedium = "GothamRounded-Medium"
let FontNameGothamRoundedLight = "GothamRounded-Light"
let FontNameGothamRoundedBold = "GothamRnd-Bold"
let FontNameGothamBold = "Gotham-Bold"

//let apiKey = "KhOSpc4cf67AkbRpq1hkq5O3LPlwU9IAtILaL27EPMlYr27zipbNCsQaeXkSeK3R"

let ImgPath = "https://app.stepjockey.com/app-assets/challenges/"


struct CurrentDevice {
    
    // iDevice detection code
    static let IS_IPAD               = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE             = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA             = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH          = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT         = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH     = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH     = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_6_OR_HIGHER = IS_IPHONE && SCREEN_MAX_LENGTH  > 568
    static let IS_IPHONE_6           = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P          = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X           = IS_IPHONE && SCREEN_MAX_LENGTH == 812
    static let IS_IPHONE_X_OR_HIGHER = IS_IPHONE && SCREEN_MAX_LENGTH  > 812
    static let IS_IPHONE_X_OR_LOWER  = IS_IPHONE && SCREEN_MAX_LENGTH  < 812
    
    static let IS_IPHONE_4_OR_LESS   = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5_OR_LESS   = IS_IPHONE && SCREEN_MAX_LENGTH <= 568
    
    // MARK: - Singletons
    static var ScreenWidth: CGFloat {
        struct Singleton {
            static let width = UIScreen.main.bounds.size.width
        }
        return Singleton.width
    }
    
    static var ScreenHeight: CGFloat {
        struct Singleton {
            static let height = UIScreen.main.bounds.size.height
        }
        return Singleton.height
    }
}

func showAlertViewWithOK(vc : UIViewController, titleString : String , messageString: String) ->()
{
    let alertView = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
    
    let alertAction = UIAlertAction(title: "OK", style: .cancel) { (alert) in
        vc.dismiss(animated: true, completion: nil)
    }
    
    alertView.addAction(alertAction)
    vc.present(alertView, animated: true, completion: nil)
}

func UTC_DF() -> DateFormatter {
    let dateFormatter = DateFormatter()
    if let time = NSTimeZone(name: "UTC") {
        dateFormatter.timeZone = time as TimeZone
    }
    dateFormatter.locale = NSLocale.system
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"

    return dateFormatter
}

func UTCBig_DF() -> DateFormatter {
    let dateFormatter = DateFormatter()
    if let time = NSTimeZone(name: "UTC") {
        dateFormatter.timeZone = time as TimeZone
    }
    dateFormatter.locale = NSLocale.system
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return dateFormatter
}

func LocalDF() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.system
    if let time = NSTimeZone(name: "GMT") {
        dateFormatter.timeZone = time as TimeZone
    }
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    
    return dateFormatter
}

//func DF() -> DateFormatter {
//    let dateFormatter = DateFormatter()
//    dateFormatter.locale = NSLocale.system
//    dateFormatter.timeZone = NSTimeZone.local
//    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
//
//    return dateFormatter
//}

func OnlyDF() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.system
    dateFormatter.dateFormat = "dd/MM/yyyy"
    
    return dateFormatter
}

func getDateFormatter_DF() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
    
    return dateFormatter
}

func setDateFormatter_DF() -> DateFormatter {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "dd MMMM yyyy"
    
    return dateFormatter
}

func DatePicker_DF() -> DateFormatter {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "MMM d, yyyy"
    
    return dateFormatter
}

func Show_DF() -> DateFormatter {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
    
    return dateFormatter
}

func API_DF() -> DateFormatter {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return dateFormatter
}

func minutesToHoursMinutes (minutes : Int) -> String {
    
    return ("\(minutes / 60)h " + "\(minutes % 60)m")
}

extension NSDictionary {
    func GotValue(key : String)-> NSString {
        
        if self[key] != nil {
            
            if((self["\(key)"] as? NSObject) != nil && (key .isEmpty) == false) {
                
                let obj_value = self["\(key)"] as? NSObject
                
                let str = NSString(format:"%@", obj_value!)
                
                if str == "<null>" {
                    
                    return ""
                }
                
                return str
            }
        }
        
        return ""
    }
}

    

var container: UIView = UIView()
var loadingView: UIView = UIView()
var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

/*
 Show customized activity indicator,
 actually add activity indicator to passing view
 
 @param uiView - add activity indicator to this view
 */
func showActivityIndicator(uiView: UIView) {
    container.frame = uiView.frame
    container.center = uiView.center
    container.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
        
    loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
    loadingView.center = uiView.center
    loadingView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.6)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    
    activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
    activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
    activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    
    loadingView.addSubview(activityIndicator)
    container.addSubview(loadingView)
    uiView.addSubview(container)
    activityIndicator.startAnimating()
}

func showActivityIndicatorWithMSG(message: String, uiView: UIView) {
    container.frame = uiView.frame
    container.center = uiView.center
    container.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
    
    loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
    loadingView.center = uiView.center
    loadingView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.6)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    
    activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
    activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
    activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    
    let msg_LB = UILabel(frame: CGRect(x: 10.0, y: (activityIndicator.frame.origin.y+70.0), width: (CurrentDevice.ScreenWidth-20), height: 50.0))
    msg_LB.textColor = UIColor.white
    msg_LB.textAlignment = .center;
    msg_LB.font.withSize(10.0)
    msg_LB.text = message
    msg_LB.clipsToBounds  =  true
    msg_LB.numberOfLines = 0
    
    loadingView.addSubview(msg_LB)
    
    loadingView.addSubview(activityIndicator)
    container.addSubview(loadingView)
    uiView.addSubview(container)
    activityIndicator.startAnimating()
}

/*
 Hide activity indicator
 Actually remove activity indicator from its super view
 
 @param uiView - remove activity indicator from this view
 */
func hideActivityIndicator(uiView: UIView) {
    activityIndicator.stopAnimating()
    container.removeFromSuperview()
}

/*
 Define UIColor from hex value
 
 @param rgbValue - hex color value
 @param alpha - transparency level
 */

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
}

class Toast {
    static func show(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = #colorLiteral(red: 0.3534786999, green: 0.3337596655, blue: 0.3043811321, alpha: 1)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(10.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -95)
        controller.view.addConstraints([c1, c2, c3])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}

func isValidEmail(_ email:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}

extension String {
    
    func firstCharacterUpperCase() -> String? {
        guard !isEmpty else { return nil }
        
        let lowerCasedString = self.lowercased()
        return lowerCasedString.replacingCharacters(in: lowerCasedString.startIndex...lowerCasedString.startIndex, with: String(lowerCasedString[lowerCasedString.startIndex]).uppercased())
    }
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: (size.width * heightRatio), height: (size.height * heightRatio))
    } else {
        newSize = CGSize(width: (size.width * widthRatio), height: (size.height * widthRatio))
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0.0, y: 0.0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
    
    let cgimage = image.cgImage!
    let contextImage: UIImage = UIImage(cgImage: cgimage)
    let contextSize: CGSize = contextImage.size
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    var cgwidth: CGFloat = CGFloat(width)
    var cgheight: CGFloat = CGFloat(height)
    
    // See what size is longer and create the center off of that
    if contextSize.width > contextSize.height {
        posX = ((contextSize.width - contextSize.height) / 2)
        posY = 0
        cgwidth = contextSize.height
        cgheight = contextSize.height
    } else {
        posX = 0
        posY = ((contextSize.height - contextSize.width) / 2)
        cgwidth = contextSize.width
        cgheight = contextSize.width
    }
    
    let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
    
    // Create bitmap image from context using the rect
    let imageRef: CGImage = cgimage.cropping(to: rect)!
    
    // Create a new image based on the imageRef and rotate back to the original orientation
    let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
    
    return image
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

func userId(fromJWTToken token: String?) -> String {
    // Access token is encoded according to the JWT standard (RFC 7519)
    // Getting the userId from the access token
    let accessToken = token
    let accessTokenParts = accessToken?.components(separatedBy: ".")
    var payloadEncodedString = accessTokenParts![1]
    
    // Adding padding characters to the encoded string - NSData is too "smart" and cannot work with unpadded strings
    let paddingCharacters: Int = payloadEncodedString.count % 4
    if paddingCharacters > 0 {
        var i: Int = 0
        for i in 0..<4 - paddingCharacters {
            payloadEncodedString = "\(payloadEncodedString)" + "="
        }
    }
    
    // print("--payloadEncodedString--\(payloadEncodedString)")
    
    let decodedPayloadData = Data(base64Encoded: payloadEncodedString, options: .ignoreUnknownCharacters)
    //                          DBG(@"decoded payload data: %@", decodedPayloadData);
    //                          NSString *decodedPayloadString = [[NSString alloc] initWithData:decodedPayloadData encoding:NSUTF8StringEncoding];
    //                          DBG(@"decoded raw data string: %@", decodedPayloadString);
    
//    print("--decodedPayloadData--\(decodedPayloadData)")
    
    var error: Error? = nil
    var payload: [AnyHashable : Any]? = nil
    do {
        if let decodedPayloadData = decodedPayloadData {
            payload = try JSONSerialization.jsonObject(with: decodedPayloadData, options: []) as? [AnyHashable : Any]
        }
    } catch {
    }
    #if DEBUG
    if error != nil {
        print("Error while deserializing auth token payload:")
        print(error?.localizedDescription)
        print(error)
    }
    #endif
    
    print("--payload--\(payload)")
    
    let userId = payload?["sub"] as? String ?? ""
    
    return userId
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String {
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02.2hhX", UInt8(byte))
        }
        
        return hexString
    }
}

extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension Date {
    var dateAtMidnight: Date {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        let dateAtMidnight = calendar.startOfDay(for: Date())
        
        return dateAtMidnight
    }
    
    var dateAtEnd: Date {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        let dateAtMidnight = calendar.startOfDay(for: Date())
        
        //For End Date
        var components = DateComponents()
        components.day = 1
        components.second = -1
        
        let dateAtEnd = calendar.date(byAdding: components, to: dateAtMidnight)
        
        return dateAtEnd!
    }
}

extension Int {
    
    var ordinal: String {
        var suffix: String
        let ones: Int = self % 10
        let tens: Int = (self/10) % 10
        if tens == 1 || tens == -1 {
            suffix = "th"
        } else if ones == 1 || ones == -1 {
            suffix = "st"
        } else if ones == 2 || ones == -2 {
            suffix = "nd"
        } else if ones == 3 || ones == -3 {
            suffix = "rd"
        } else {
            suffix = "th"
        }
//        return "\(self)\(suffix)"
        
        return "\(suffix)"
    }
}

/******************************************************/
//MARK:- EXTension
/******************************************************/

extension UITextField {
    
    func addPlaceHolder(str_placeholder : String) {
        
        self.attributedPlaceholder = NSAttributedString(string: str_placeholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor: hexStringToUIColor(hex: "#8780A1")])
        
        self.font =  UIFont.systemFont(ofSize: 18.0)
    }
}

extension UIImageView {
    
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
 

extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}
