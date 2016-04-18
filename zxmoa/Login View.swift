//
//  ViewController.swift
//  zxmoa
//
//  Created by mingxing on 16/3/1.
//  Copyright © 2016年 ruanxr. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

var cookpsw:String = ""
var Usernn:String  = ""

class LoginView: UIViewController {
    
    @IBOutlet weak var remb: UISwitch!
    @IBOutlet weak var send: UIButton!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    var timer:NSTimer!
    var saveSuccessful: Bool!
    var saveSuccessful1: Bool!
    var saveSuccessful2: Bool = false
    @IBAction func sendup(sender: AnyObject) {
        /**按钮无法按下，防止多次请求*/
        send.userInteractionEnabled = false
        let usern : String! = Username.text
        let passw : String! = Password.text
        showNoticeWait()
        saveSuccessful = KeychainWrapper.setString(usern, forKey: "usern")
        saveSuccessful1 = KeychainWrapper.setString(passw, forKey: "passw")
        if remb.on {
            saveSuccessful2 = KeychainWrapper.setString("1", forKey: "butten")
        } else {
            saveSuccessful2 = KeychainWrapper.removeObjectForKey("butten")
        }
        Usernn = usern
    //发送http post请求
    Alamofire.request(.POST, "http://zxmoa.com:83/general/login/index.php?c=Login&a=loginCheck",parameters:["username":"\(usern)","password":"\(passw)","userLang":"cn"]).responseData{ response in
            if let j = response.result.value {
            let js = JSON(data:j)
            if js["flag"] == 1
            {
                let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
                let cookieArray = cookieStorage.cookies
                if cookieArray!.count > 0
                {
                    for cookie in cookieArray!
                    {
                        if cookie.name == "PHPSESSID"
                        {
                            cookpsw = cookie.value
//                          print("PHPSESSID : \(cookpsw)")
                        }
                    }
                }
//                self.clearAllNotice()
                /**请求完成重新开启按钮*/
                self.send.userInteractionEnabled = true
//                self.dismissViewControllerAnimated(true,completion: nil)//销毁当前视图
                self.performSegueWithIdentifier("Truerun", sender: self)
//               self.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
            }else{
                let alertController = UIAlertController(title: "提示",message: "用户名密码错误", preferredStyle: .Alert) //设置提示框
                self.presentViewController(alertController, animated: true, completion: nil)//显示提示框
                self.timer = NSTimer.scheduledTimerWithTimeInterval(2,target:self,selector:Selector("timers"),userInfo:alertController,repeats:false)
                        //设置单次执行 repeats是否重复执行 selector 执行的方法
                }
            }
        }
    }
    
    /**定时器*/
    func timers()
    {
        self.presentedViewController?.dismissViewControllerAnimated(false, completion: nil)//关闭提示框
        send.userInteractionEnabled = true
        self.timer.invalidate()//释放定时
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    func stateChanged(switchState: UISwitch) {
        if switchState.on {
            let usern : String! = Username.text
            let passw : String! = Password.text
            saveSuccessful = KeychainWrapper.setString(usern, forKey: "usern")
            saveSuccessful1 = KeychainWrapper.setString(passw, forKey: "passw")
        } else {

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        Password.secureTextEntry = true
        NSThread.sleepForTimeInterval(2.0)
//        send.layer.cornerRadius = 5  //设置button按钮圆角
        let flag:String? = KeychainWrapper.stringForKey("butten")
        if flag != nil{
            remb.setOn(true, animated: true)
        }else{
            remb.setOn(false, animated: true)
        }
        if remb.on {
            Username.text = KeychainWrapper.stringForKey("usern")
            Password.text = KeychainWrapper.stringForKey("passw")
        }else
        {
            
        }
        send.layer.cornerRadius = 5  //设置button按钮圆角
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.Username.resignFirstResponder()//释放username控件的第一焦点
        self.Password.resignFirstResponder()//释放password控件的第一焦点
    }
    
    @IBAction func log(segue: UIStoryboardSegue){
//        print("1")
    }
}

