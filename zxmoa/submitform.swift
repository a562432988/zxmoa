//
//  submitform.swift
//  zxmoa
//
//  Created by mingxing on 16/4/1.
//  Copyright © 2016年 ruanxr. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class submitform: FormViewController {

    var RUN_ID:String?
    var senders:[[String]] = []
    var senders1:[[String]] = []
    var se:[Int]=[]
    var se1:[Int]=[]
    var qb:[[String]] = []
    var date1:[String:AnyObject]?
    var flag = 0
    var ten:Int!
    struct Static {
        static let submit = "opUserListStr"
        static let sub = "userListStr"
    }
    
    func segmentDidchange(segmented:UISegmentedControl){
        
        switch( segmented.selectedSegmentIndex ) {
        case 0:
            self.form.removeSectionAll()
            loadForm(se1,ss: senders1)
            self.tableView.reloadData()
            qb = senders1
            if ten == 1 || ten == 3{
            flag = 1
            }else if ten == 2{
                flag = 2
            }
            break
        case 1:
            self.form.removeSectionAll()
            loadForm(se,ss: senders)
            self.tableView.reloadData()
            qb = senders
            flag = 0
            break
        default : break
        }
  //        print(segmented.titleForSegmentAtIndex(segmented.selectedSegmentIndex))
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var items:[String]!
        if ten == 1 || ten == 2{
            items = ["办公室","中层领导"] as [String]
        }else{
            items = ["上报"] as [String]
        }
        let segmented=UISegmentedControl(items:items)
            segmented.center=self.view.center
            segmented.selectedSegmentIndex = 0 //默认选中第一项
            segmented.addTarget(self, action: "segmentDidchange:",
                forControlEvents: UIControlEvents.ValueChanged)  //添加值改变监听
            segmented.tintColor = UIColor.redColor()

        self.view.addSubview(segmented)
    
        self.navigationItem.title = "流转节点"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交  ", style: .Plain, target: self, action: "submit:")
        loadForm(se1,ss: senders1)
        segmentDidchange(segmented)
        // Do any additional setup after loading the view.
    }

    func submit(_: UIBarButtonItem!) {

        date1 = self.form.formValues()
        let d7:String? = date1!["opUserListStr"] as? String
        let d8:String? = date1!["userListStr"] as? String
        if d7 == ""{
            let alert: UIAlertView = UIAlertView(title: "警告", message: "没有指定主办人", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }else{
            
            let opuser = qb[opstringToInt(d7!)][0]
            
            date1!["opUserListStr"] = opuser
            date1!["PRCS_OP_USER"] = qb[opstringToInt(d7!)][1]
            date1!["PRCS_OP_USER_NAME_TMP"] = opuser
            date1!["f"] = "turnnext"
            date1!["flow_node"] = "on"
            date1!["MOBILE_SMS_REMIND"] = "0"
            date1!["EMAIL_REMIND"] = "0"
            date1!["SMS_REMIND"] = "0"
            date1!["muc"] = "0"
            date1!["is_concourse"] = "0"
            date1!["OP_FLAG"] = "1"
            date1!["FLOW_PRCS_UP"] = "1"
            date1!["PRCS_ID"] = "1"
            date1!["RUN_ID"] = RUN_ID
            
            if ten == 1{
                date1!["FLOW_ID"] = "3004"
                date1!.updateValue("\(flag)", forKey: "PRCS_TO_CHOOSE")
                date1!["FLOW_PRCS"] = "\(flag+2)"
                let user = stringToInt(d8!)
                var prcs = ""
                var prcsid = ""
                for var i = 0;i < user.count;i++ {
                    let s = user[i]
                    prcs = prcs + qb[s][0] + ","
                    prcsid = prcsid + qb[s][1] + ","
                }
                date1!["userListStr"] = prcs
                date1!["PRCS_USER"] = prcsid
                date1!["PRCS_USER_NAME_TMP"] = prcs
            }else if ten == 2{
                date1!["FLOW_ID"] = "2001"
                date1!.updateValue("\(flag)", forKey: "PRCS_TO_CHOOSE")
                date1!["FLOW_PRCS"] = "\(flag+2)"
                let user = stringToInt(d8!)
                var prcs = ""
                var prcsid = ""
                for var i = 0;i < user.count;i++ {
                    let s = user[i]
                    prcs = prcs + qb[s][0] + ","
                    prcsid = prcsid + qb[s][1] + ","
                }
                date1!["userListStr"] = prcs
                date1!["PRCS_USER"] = prcsid
                date1!["PRCS_USER_NAME_TMP"] = prcs
            }else{
                date1!["FLOW_ID"] = "3002"
                date1!["PRCS_TO_CHOOSE"] = "0"
                date1!["FLOW_PRCS"] = "2"
                let user = stringToInt(d8!)
                var prcs = ""
                var prcsid = ""
                for var i = 0;i < user.count;i++ {
                    let s = user[i]
                    prcs = prcs + senders[s][0] + ","
                    prcsid = prcsid + senders[s][1] + ","
                }
                date1!["userListStr"] = prcs
                date1!["PRCS_USER"] = prcsid
                date1!["PRCS_USER_NAME_TMP"] = prcs
            }
            print(date1)
            urll()
        }
    }
    
    func urll(){
    //        showNoticeWait()
        let url = "http://www.zxmoa.com:83/general/workflow/new/do.php"
        let header = ["Cookie":"PHPSESSID=\(cookpsw)"]
        Alamofire.request(.POST,url,headers: header,parameters: date1).responseString{ response in
            if let j = response.result.value{
            print(j)
            print("---------")
            let range = j.rangeOfString("流程提交完成")
                if range != nil{
                    self.showNoticeSuc("流程提交完成", time: 1.5, autoClear: true)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }else{
                self.showNoticeErr("流程提交失败",time: 1.5, autoClear: true)
                self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
        }
    }

    func stringToInt(res:String)-> [Int]{
        let qcharset=NSCharacterSet(charactersInString:"()")
        let str4 = res.stringByTrimmingCharactersInSet(qcharset)
        
        let charset=NSCharacterSet(charactersInString:",")
        let resArray=str4.componentsSeparatedByCharactersInSet(charset)
        let re = NSCharacterSet(charactersInString:" \n ")
        var trname:[Int]=[]
        for var i = 0;i < resArray.count;i++ {
            let str5 = resArray[i].stringByTrimmingCharactersInSet(re)
            trname.append(Int(str5)!)
        }
        return trname
    }
    
    func opstringToInt(res:String)-> Int{
        let qcharset=NSCharacterSet(charactersInString:"()")
        let str4 = res.stringByTrimmingCharactersInSet(qcharset)
    
        let charset=NSCharacterSet(charactersInString:",")
        let resArray=str4 .componentsSeparatedByCharactersInSet(charset)
        
        let re = NSCharacterSet(charactersInString:"\n ")
        let str5 = resArray[0].stringByTrimmingCharactersInSet(re)
        let trname = Int(str5)
        return trname!
    }

    private func loadForm(s:[Int],ss:[[String]]) {
        let form = FormDescriptor(title: "流转节点")

        let section1 = FormSectionDescriptor(headerTitle: "指定主办人", footerTitle: nil)
        
        var row = FormRowDescriptor(tag: Static.submit, rowType: .MultipleSelector, title: "指定主办人")
        row.configuration[FormRowDescriptor.Configuration.Options] = s
        row.configuration[FormRowDescriptor.Configuration.AllowsMultipleSelection] = false
        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in return ss[value as! Int][0]
            } as TitleFormatterClosure
        if s.count == 1{
            row.value = 0
        }
        section1.addRow(row)
        
        
        let section2 = FormSectionDescriptor(headerTitle: "所有主办人", footerTitle: nil)
        
        row = FormRowDescriptor(tag: Static.sub, rowType: .MultipleSelector, title: "所有主办人")
        row.configuration[FormRowDescriptor.Configuration.Options] = s
        row.configuration[FormRowDescriptor.Configuration.AllowsMultipleSelection] = true
        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in return ss[value as! Int][0]
            } as TitleFormatterClosure
        
        if s.count == 1{
            row.value = 0
        }
        section2.addRow(row)

        form.sections = [section1,section2]
        self.form = form
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
