//
//  webView.swift
//  zxmoa
//
//  Created by mingxing on 16/3/22.
//  Copyright © 2016年 ruanxr. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class webView: UIViewController,UIWebViewDelegate {
    var webbit:UIWebView?
    var data:String?
    var titles:String?
//    http://www.zxmoa.com:83/general/notify/show/read_notify.php?NOTIFY_ID=20
    var url = "http://www.zxmoa.com:83/general/"
    var header = ["Cookie":"PHPSESSID=\(cookpsw)"]
    override func viewDidLoad() {
        super.viewDidLoad()
        webbit = UIWebView(frame: self.view.frame )
        webbit!.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255,
            blue: 0xf0/255, alpha: 1)
        self.webbit?.delegate = self
        self.navigationItem.title = titles!
        self.view.addSubview(webbit!)
        
        //设置是否缩放到适合屏幕大小
        self.webbit?.scalesPageToFit = true
        ursll()
        // Do any additional setup after loading the view.
    }

    func ursll(){
        url = url+data!
        showNoticeWait()
        Alamofire.request(.GET,url,headers: header ).responseString{ response in
            if let j = response.result.value {
                let html = j
                self.webbit!.loadHTMLString(html,baseURL:nil)
                self.clearAllNotice()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
