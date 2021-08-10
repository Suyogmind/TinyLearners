//
//  WebServiceHandler.swift
//  SSUserApp
//
//  Created by MindCrew Technologies on 07/04/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class WebServiceHandler: NSObject {
    
    static let shared = WebServiceHandler() //lazy init, and it only runs once
//func callWebService(withData dictData: NSMutableDictionary, success: @escaping (_ responseDict: [AnyHashable: Any]) -> Void, failure: @escaping (_ error: Error?) -> Void) {
    
    func callWebService(withData dictData: [String : Any], strURL: String, success: @escaping (_ responseDict: [AnyHashable: Any]) -> Void, failure: @escaping (_ error: Error?) -> Void) {

        let reachability = Reachability()!
        if !reachability.isReachable
        {
            let Alert:UIAlertView = UIAlertView(title: "", message: "Server is not available" as String?, delegate: nil, cancelButtonTitle: "Ok")
            Alert.show()
        }
        else
        {
            //create the url with URL
            let url = URL(string:strURL as String)! //change the url
            
            //create the session object
            let session = URLSession.shared
            
            //now create the URLRequest object using the url object
            var request = URLRequest(url: url)
            request.httpMethod = "POST" //set http method as POST
            
            do {
                
                request.httpBody = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("\(UIDevice.current.systemName)", forHTTPHeaderField: "X-StepJockey-Platform")
            request.addValue("\(UIDevice.current.model)", forHTTPHeaderField: "X-StepJockey-Device")
            request.addValue("\(String(describing: Bundle.main.infoDictionary?["CFBundleVersion"]))", forHTTPHeaderField: "X-StepJockey-Version")
            request.addValue("\(UIDevice.current.systemVersion)", forHTTPHeaderField: "X-StepJockey-OSVersion")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            request.addValue("Bearer \(UserDefaults.standard.value(forKey: "access_token") ?? "")", forHTTPHeaderField: "Authorization")
            
            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else {
                    failure(error)
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                       
                        DispatchQueue.main.async(execute: {
                            if (json as? NSDictionary) != nil{
                                
                                success(json);
                            }
                            else if (json as? NSArray) != nil{
                                
                                success(json);
                            }
                        })
                    }
                    else
                    {
                        failure(error)
                    }
                }
                catch let error
                {
                    failure(error)
                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }

    func callWebServiceWithPostArray(withData dictData: [Any], strURL: String, success: @escaping (_ responseDict: [AnyHashable: Any]) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            let Alert:UIAlertView = UIAlertView(title: "", message: "Server is not available" as String?, delegate: nil, cancelButtonTitle: "Ok")
            Alert.show()
        }
        else
        {
            //            print(dictData)
            //create the url with URL
            let url = URL(string:strURL as String)! //change the url
            
            //create the session object
            let session = URLSession.shared
            
            //now create the URLRequest object using the url object
            var request = URLRequest(url: url)
            request.httpMethod = "POST" //set http method as POST
            
            do {
                
                request.httpBody = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
                
            } catch let error {
                //                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("\(UIDevice.current.systemName)", forHTTPHeaderField: "X-StepJockey-Platform")
            request.addValue("\(UIDevice.current.model)", forHTTPHeaderField: "X-StepJockey-Device")
            request.addValue("\(String(describing: Bundle.main.infoDictionary?["CFBundleVersion"]))", forHTTPHeaderField: "X-StepJockey-Version")
            request.addValue("\(UIDevice.current.systemVersion)", forHTTPHeaderField: "X-StepJockey-OSVersion")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            request.addValue("Bearer \(UserDefaults.standard.value(forKey: "access_token") ?? "")", forHTTPHeaderField: "Authorization")
            
            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else {
                    failure(error)
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        
                        DispatchQueue.main.async(execute: {
                            if (json as? NSDictionary) != nil{
                                
                                success(json);
                            }
                            else if (json as? NSArray) != nil{
                                
                                success(json);
                            }
                        })
                    }
                    else
                    {
                        failure(error)
                    }
                }
                catch let error
                {
                    failure(error)
                    //                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }
    
    func callWebServiceWithPut(withData dictData: [String : Any], strURL: String, success: @escaping (_ responseDict: [AnyHashable: Any]) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            let Alert:UIAlertView = UIAlertView(title: "", message: "Server is not available" as String?, delegate: nil, cancelButtonTitle: "Ok")
            Alert.show()
        }
        else
        {
            //            print(dictData)
            //create the url with URL
            let url = URL(string:strURL as String)! //change the url
            
            //create the session object
            let session = URLSession.shared
            
            //now create the URLRequest object using the url object
            var request = URLRequest(url: url)
            request.httpMethod = "PUT" //set http method as POST
            
            do {
                
                request.httpBody = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
                
            } catch let error {
                //                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("\(UIDevice.current.systemName)", forHTTPHeaderField: "X-StepJockey-Platform")
            request.addValue("\(UIDevice.current.model)", forHTTPHeaderField: "X-StepJockey-Device")
            request.addValue("\(String(describing: Bundle.main.infoDictionary?["CFBundleVersion"]))", forHTTPHeaderField: "X-StepJockey-Version")
            request.addValue("\(UIDevice.current.systemVersion)", forHTTPHeaderField: "X-StepJockey-OSVersion")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            request.addValue("Bearer \(UserDefaults.standard.value(forKey: "access_token") ?? "")", forHTTPHeaderField: "Authorization")
            
            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else {
                    failure(error)
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        
                        DispatchQueue.main.async(execute: {
                            if (json as? NSDictionary) != nil{
                                
                                success(json);
                            }
                            else if (json as? NSArray) != nil{
                                
                                success(json);
                            }
                        })
                    }
                    else
                    {
                        failure(error)
                    }
                }
                catch let error
                {
                    failure(error)
                    //                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }
    
    func callWebServiceWithSTRParm(withData strData: String, strURL: String, success: @escaping (_ responseDict: [AnyHashable: Any]) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            let Alert:UIAlertView = UIAlertView(title: "", message: "Server is not available" as String?, delegate: nil, cancelButtonTitle: "Ok")
            Alert.show()
        }
        else
        {
            //            print(dictData)
            //create the url with URL
            let url = URL(string:strURL as String)! //change the url
            
            //create the session object
            let session = URLSession.shared
            
            //now create the URLRequest object using the url object
            var request = URLRequest(url: url)
            request.httpMethod = "POST" //set http method as POST
            
            do {
                
                request.httpBody = ("\"" + strData + "\"").data(using: .utf8)
                
            } catch let error {
                //                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("\(UIDevice.current.systemName)", forHTTPHeaderField: "X-StepJockey-Platform")
            request.addValue("\(UIDevice.current.model)", forHTTPHeaderField: "X-StepJockey-Device")
            request.addValue("\(String(describing: Bundle.main.infoDictionary?["CFBundleVersion"]))", forHTTPHeaderField: "X-StepJockey-Version")
            request.addValue("\(UIDevice.current.systemVersion)", forHTTPHeaderField: "X-StepJockey-OSVersion")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            request.addValue("Bearer \(UserDefaults.standard.value(forKey: "access_token") ?? "")", forHTTPHeaderField: "Authorization")
            
            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else {
                    failure(error)
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        
                        DispatchQueue.main.async(execute: {
                            if (json as? NSDictionary) != nil{
                                
                                success(json);
                            }
                            else if (json as? NSArray) != nil{
                                
                                success(json);
                            }
                        })
                    }
                    else
                    {
                        failure(error)
                    }
                }
                catch let error
                {
                    failure(error)
                    //                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }
    
    func callWebServiceWithGET(withData dictData: NSMutableDictionary, strURL: String, success: @escaping (_ responseDict: [AnyHashable: Any]) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            let Alert:UIAlertView = UIAlertView(title: "", message: "Server is not available" as String?, delegate: nil, cancelButtonTitle: "Ok")
            Alert.show()
        }
        else
        {
            let urlNew:String = strURL.replacingOccurrences(of: " ", with: "%20")
            
            //            print(dictData)
            //create the url with URL
            let url = URL(string:urlNew as String)! //change the url
            
            //create the session object
            let session = URLSession.shared
            
            //now create the URLRequest object using the url object
            var request = URLRequest(url: url)
            request.httpMethod = "GET" //set http method as POST
            
//            do {
//                request.httpBody = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
//
//            } catch let error {
//                //                print(error.localizedDescription)
//            }
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("application/json", forHTTPHeaderField: "Accept")

            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("\(UIDevice.current.systemName)", forHTTPHeaderField: "X-StepJockey-Platform")
            request.addValue("\(UIDevice.current.model)", forHTTPHeaderField: "X-StepJockey-Device")
            request.addValue("\(String(describing: Bundle.main.infoDictionary?["CFBundleVersion"]))", forHTTPHeaderField: "X-StepJockey-Version")
            request.addValue("\(UIDevice.current.systemVersion)", forHTTPHeaderField: "X-StepJockey-OSVersion")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
//            print("Bearer \(UserDefaults.standard.value(forKey: "access_token") ?? "")")
            
            request.addValue("Bearer \(UserDefaults.standard.value(forKey: "access_token") ?? "")", forHTTPHeaderField: "Authorization")
            
            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else {
                    failure(error)
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        //                       print(json)
                        
                        DispatchQueue.main.async(execute: {
                            if (json as? NSDictionary) != nil{
                                
                                success(json);
                            }
                            else if (json as? NSArray) != nil{
                                
                                success(json);
                            }
                        })
                    }
                    else
                    {
                        failure(error)
                    }
                }
                catch let error
                {
                    failure(error)
                    //                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }
    
    func callWebServiceWithDelete(withData dictData: NSMutableDictionary, strURL: String, success: @escaping (_ responseDict: [AnyHashable: Any]) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            let Alert:UIAlertView = UIAlertView(title: "", message: "Server is not available" as String?, delegate: nil, cancelButtonTitle: "Ok")
            Alert.show()
        }
        else
        {
            let urlNew:String = strURL.replacingOccurrences(of: " ", with: "%20")
            
            //            print(dictData)
            //create the url with URL
            let url = URL(string:urlNew as String)! //change the url
            
            //create the session object
            let session = URLSession.shared
            
            //now create the URLRequest object using the url object
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE" //set http method as POST
            
            //            do {
            //                request.httpBody = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
            //
            //            } catch let error {
            //                //                print(error.localizedDescription)
            //            }
            //            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("\(UIDevice.current.systemName)", forHTTPHeaderField: "X-StepJockey-Platform")
            request.addValue("\(UIDevice.current.model)", forHTTPHeaderField: "X-StepJockey-Device")
            request.addValue("\(String(describing: Bundle.main.infoDictionary?["CFBundleVersion"]))", forHTTPHeaderField: "X-StepJockey-Version")
            request.addValue("\(UIDevice.current.systemVersion)", forHTTPHeaderField: "X-StepJockey-OSVersion")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //            print("Bearer \(UserDefaults.standard.value(forKey: "access_token") ?? "")")
            
            request.addValue("Bearer \(UserDefaults.standard.value(forKey: "access_token") ?? "")", forHTTPHeaderField: "Authorization")
            
            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else {
                    failure(error)
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        //                       print(json)
                        
                        DispatchQueue.main.async(execute: {
                            if (json as? NSDictionary) != nil{
                                
                                success(json);
                            }
                            else if (json as? NSArray) != nil{
                                
                                success(json);
                            }
                        })
                    }
                    else
                    {
                        failure(error)
                    }
                }
                catch let error
                {
                    failure(error)
                    //                    print(error.localizedDescription)
                }
            })
            task.resume()
        }
    }
    
    func callWebService(withURL strURL: String, success: @escaping (_ responseDict: [AnyHashable: Any]) -> Void, failure: @escaping (_ error: Error?) -> Void) {
        
        
        let url = URL(string: strURL)
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            if error != nil {
                failure(error)
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    success(parsedData);
//                    print("parsedData = ", parsedData)
                    
                } catch let error as NSError {
//                    print(error)
                    failure(error)
                }
            }
            
            }.resume()
    }

}
