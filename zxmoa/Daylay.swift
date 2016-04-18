//
//  Daylay.swift
//  zxmoa
//
//  Created by mingxing on 16/3/7.
//  Copyright © 2016年 ruanxr. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Daylay: UIViewController{
    
    /**客户走访*/
    @IBOutlet weak var btn2: UIButton!
    
    /**工作周报*/
    @IBOutlet weak var btn4: UIButton!
    
    /**请假上报*/
    @IBOutlet weak var btn1: UIButton!
    
    /**代办查看*/
    @IBOutlet weak var btn3: UIButton!
    var data = ""
    var ttle = ""
    var RUN_ID = ""
    var flag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        btn1.frame = CGRectMake(0,0,30,30)
//        btn1.center = CGPointMake(view.frame.size.width/2, 280)
//        btn1.titleLabel?.font = UIFont.boldSystemFontOfSize(17) //文字大小
        btn1.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal) //文字颜色
        btn1.set(image: UIImage(named: "gongao.png"), title: "请假上报", titlePosition: .Bottom,
            additionalSpacing: 10.0, state: .Normal)

        btn4.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal) //文字颜色
        btn4.set(image: UIImage(named: "liucheng.png"), title: "工作周报", titlePosition: .Bottom,
            additionalSpacing: 10.0, state: .Normal)
        
        btn2.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal) //文字颜色
        btn2.set(image: UIImage(named: "kehu.png"), title: "客户走访", titlePosition: .Bottom,
            additionalSpacing: 10.0, state: .Normal)
        
        btn3.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal) //文字颜色
        btn3.set(image: UIImage(named: "wendang.png"), title: "代办查询", titlePosition: .Bottom,
            additionalSpacing: 10.0, state: .Normal)

    }
    
    
    /** 周报上报*/
    @IBAction func btn4(sender: UIButton) {
        data = "workflow/new/do.php?f=create&FLOW_ID=3004&FLOW_TYPE=1&FUNC_ID=2"
        ttle = "工作周报上报"
        flag = 1
        btn4.userInteractionEnabled = false
        self.ursll()
//         self.trunaround()
    }
    
    @IBAction func btn3(sender: UIButton) {
        let alert: UIAlertView = UIAlertView(title: "", message: "功能开发中", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    /** 请假上报*/
    @IBAction func btn1(sender: UIButton) {
        data = "workflow/new/do.php?FLOW_ID=2001&f=create&FLOW_TYPE=1&FUNC_ID=2"
        ttle = "请假申请"
        flag = 2
        btn1.userInteractionEnabled = false
        ursll()
    }
    
    /** 客户走访*/
    @IBAction func btn2(sender: UIButton) {
        data = "workflow/new/do.php?FLOW_ID=3002&f=create&FLOW_TYPE=1&FUNC_ID=2"
        ttle = "客户走访信息上报"
        flag = 3
        btn2.userInteractionEnabled = false
//        trunaround()
        ursll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ursll(){
        var url1 = "http://www.zxmoa.com:83/general/"
        let header = ["Cookie":"PHPSESSID=\(cookpsw)"]
        url1 = url1 + data
        showNoticeWait()
        Alamofire.request(.GET,url1,headers: header ).response { request, response, data, error in
            let res = String(response?.URL!)
            let charset=NSCharacterSet(charactersInString:"&=")
            let resArray=res.componentsSeparatedByCharactersInSet(charset)
            self.RUN_ID = resArray[1]
            
//            print(self.RUN_ID,1)
            self.clearAllNotice()
            self.trunaround()
        }
    }
    
    func trunaround(){
        let vc = FormController()
        vc.RUN_ID1 = RUN_ID
        vc.flag = flag
        vc.titlename = ttle
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        btn4.userInteractionEnabled = true
        btn2.userInteractionEnabled = true
        btn1.userInteractionEnabled = true
    }

}
