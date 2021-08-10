//
//  Web_VC.swift
//  Rising Leaders
//
//  Created by apple on 3/12/20.
//  Copyright © 2020 MindCrew. All rights reserved.
//

import UIKit

class Web_VC: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var LB_ScreenTitle : UILabel!
    @IBOutlet weak var WV_WebView : UIWebView!
    
    var URL_STR: String = ""
    var ScreenTitle_STR: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        LB_ScreenTitle.text = ScreenTitle_STR
        
        WV_WebView.delegate = self
        let url = URL (string: URL_STR)
        let requestObj = URLRequest(url: url!)
        WV_WebView.loadRequest(requestObj)
    }
    
    @IBAction func Back_BTN_Clicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        showActivityIndicator(uiView: self.view)
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        hideActivityIndicator(uiView: self.view)
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
