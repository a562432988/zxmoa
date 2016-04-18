//
//  FormController.swift
//  zxmoa
//
//  Created by mingxing on 16/3/30.
//  Copyright © 2016年 ruanxr. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FormController: FormViewController{
    var titlename:String = ""
    var data:String?
    var RUN_ID1:String?
    var date1:[String:AnyObject]=[:]
    var senders0:[[String]] = []
    var senders1:[[String]] = []
    var flag = 0
    /**创建表单结构体*/
    struct Static {
        static let title = "RUN_NAME"
        static let InstancyType = "InstancyType"
        static let DATA_1 = "DATA_1"
        static let DATA_2 = "DATA_2"
        static let DATA_3 = "DATA_3"
        static let DATA_4 = "DATA_4"
        static let DATA_5 = "DATA_5"
        static let DATA_6 = "DATA_6"
        static let DATA_7 = "DATA_7"
        static let DATA_8 = "DATA_8"
        static let DATA_9 = "DATA_9"
        static let DATA_10 = "DATA_10"
        static let DATA_11 = "DATA_11"
        static let DATA_12 = "DATA_12"
        static let DATA_13 = "DATA_13"
    }
    /**初始化加载表单*/
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.loadForm()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = titlename
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交    ", style: .Plain, target: self, action: "submit:")
        loadForm()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
    }
    
    /**按钮事件*/
    func submit(_: UIBarButtonItem!) {
        let message1 = self.form.formValues()
        self.view.endEditing(true)
        date1 = message1
        let cont = makeform()

        if cont == 1{
        
            let res = UIAlertController(title: "Form output", message: date1.description, preferredStyle: .Alert)

            let queren = UIAlertController(title: "确认提交", message: "是否提交\(titlename)", preferredStyle: .ActionSheet)
        
            let querenok = UIAlertAction(title: "提交", style: .Default, handler: {action in
                self.urll()
                self.urllss()
            })
        
        let querencancel = UIAlertAction(title: "取消", style: .Destructive, handler: nil)
        queren.addAction(querenok)
        queren.addAction(querencancel)
        
        let ok = UIAlertAction(title: "提交", style: .Default, handler: {action in self.presentViewController(queren, animated: true, completion: nil)})
        let cancelAction = UIAlertAction(title: "取消", style: .Destructive, handler: nil)
        res.addAction(ok)
        res.addAction(cancelAction)

        self.presentViewController(res, animated: true, completion: nil)
        }
    }
    
    func makeform()->Int{
        var qm = 1
        date1["RUN_ID"]    = RUN_ID1
        date1["doc_id"]    = ""
        date1["OP_FLAG"]   = "1"
        date1["f"]         = "autosave"
        date1["FLOW_PRCS"] = "1"
        date1["PRCS_ID"]   = "1"
        
        if flag == 1{
            date1["FIELD_COUNTER"] = "4"
            date1["ITEM_ID_MAX"]   = "4"
            date1["FLOW_ID"]       = "3004"
            
            let d7:String?         = date1["DATA_7"] as? String
            let d8:String?         = date1["DATA_8"] as? String
            if d7 == "" || d8 == ""{
                qm = 0
                let alert: UIAlertView = UIAlertView(title: "警告", message: "本周工作内容 或者 下周工作计划没有填写", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        }else if flag == 2{
            date1["FIELD_COUNTER"]  = "13"
            date1["ITEM_ID_MAX"]    = "13"
            date1["FLOW_ID"]        = "2001"
            let d7:String?          = date1["DATA_5"] as? String
            let d8:String?          = date1["DATA_7"] as? String
            if d7 == "" || d8 == ""{
                qm = 0
                let alert: UIAlertView = UIAlertView(title: "警告", message: "请假开始时间 或者 请假结束时间没有填写", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }else{
                let timeFo   = NSDateFormatter()
                timeFo.dateFormat = "yyy-MM-dd HH:mm"
                let q5:NSDate = timeFo.dateFromString(d7!)!
                let q6:NSDate = timeFo.dateFromString(d8!)!
                let second = q6.timeIntervalSinceDate(q5)
                if second <= 0{
                    let alert: UIAlertView = UIAlertView(title: "警告", message: "请假开始时间晚于或等于请假结束时间\n请重新填写", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                    qm = 0
                }else{
                    let second2 = String(format: "%.2f", second/60.0/60.0/24.0)
                    date1["DATA_10"] = second2
                    timeFo.dateFormat = "yyy-MM-dd"
                    date1["DATA_5"] = timeFo.stringFromDate(q5)
                    date1["DATA_7"] = timeFo.stringFromDate(q6)
                    timeFo.dateFormat = "HH:mm"
                    date1["DATA_6"] = timeFo.stringFromDate(q5)
                    date1["DATA_8"] = timeFo.stringFromDate(q6)
                }
            }

        }else if flag == 3{
            date1["FIELD_COUNTER"]  = "9"
            date1["ITEM_ID_MAX"]    = "9"
            date1["FLOW_ID"]        = "3002"
            let d6:String? = date1["DATA_3"] as? String
            let str3=d6!.substringToIndex(d6!.startIndex.advancedBy(10))
            print(str3)
            date1["DATA_3"] = str3
        }
        return qm
    }
    
    func trunaround(se:[Int],se1:[Int]){
        let vc = submitform()
        vc.RUN_ID = RUN_ID1
        vc.senders = senders0
        vc.senders1 = senders1
        vc.se = se
        vc.se1 = se1
        vc.ten = flag
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func urll(){
        showNoticeWait()
        let url = "http://www.zxmoa.com:83/general/workflow/new/do.php"
        let header = ["Cookie":"PHPSESSID=\(cookpsw)"]
        Alamofire.request(.POST,url,headers: header,parameters: date1).responseString{ response in
            print(response.result.value)
            print("---------")
        }
    }
    
    func urllss(){
        /**工作周报上报选择代办人*/
        let header = ["Cookie":"PHPSESSID=\(cookpsw)"]
        var seede:[String] = ["0","0","0"]
        if flag == 1{
            seede[0] = "1"
            seede[1] = "0"
            seede[2] = "3004"
        }else if flag == 2{
            seede[0] = "2"
            seede[1] = "0"
            seede[2] = "2001"
        }else if flag == 3{
            seede[0] = "0"
            seede[1] = "0"
            seede[2] = "3002"
            
        }
        var pamter:[String:String] = ["op":"getUserByDept","param[RUN_ID]":"\(RUN_ID1)","param[FLOW_ID]":"\(seede[2])","param[PRCS_ID]":"1","param[FLOW_PRCS]":"1","param[showLeaveOffice]":"false","param[getDataType]":"user_select_single_inflow_new","param[flow_type]":"1","param[PRCS_TO_CHOOSE]":"\(seede[0])"]
        let url = "http://www.zxmoa.com:83/newplugins/js/jquery-select-dialog/user/do.php"
        pamter["param[PRCS_TO_CHOOSE]"] = seede[0]
        var se:[Int] = [] , se1:[Int] = []
        Alamofire.request(.GET,url,parameters: pamter,headers: header).responseData{response in
            if let js = response.result.value{
                let jss = JSON(data: js)
                let a = jss["DATA"].count
//                print(a)
                self.senders1 = [[String]](count: a,repeatedValue: [String](count: 2, repeatedValue: " "))
                se1 = [Int](count: a, repeatedValue: 1)
                for var i = 0 ; i<a ; i++ {
                    self.senders1[i][1] = jss["DATA"][i]["USER_ID"].string!
                    se1[i] = i
                    self.senders1[i][0] = jss["DATA"][i]["USER_NAME"].string!
                }
            pamter["param[PRCS_TO_CHOOSE]"] = seede[1]
            Alamofire.request(.GET,url,parameters: pamter,headers: header).responseData{response in
                    if let js = response.result.value{
                        let jss = JSON(data: js)
                        let a = jss["DATA"].count
//                        print(a)
                        self.senders0 = [[String]](count: a,repeatedValue: [String](count: 2,repeatedValue: " "))
                        se = [Int](count: a, repeatedValue: 1)
                        for var i = 0 ; i<a ; i++ {
                            self.senders0[i][1] = jss["DATA"][i]["USER_ID"].string!
                            se[i] = i
                            self.senders0[i][0] = jss["DATA"][i]["USER_NAME"].string!
                        }
//                        print(self.senders0)
                        self.clearAllNotice()
                        self.trunaround(se,se1: se1)
//                        print(self.senders1)
                    }
                }
            }
        }
    }


    /**创建表单*/
    private func loadForm() {
        /**获取系统当前时间*/
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        var strNowTime = timeFormatter.stringFromDate(date) as String
        let title1 = titlename + "(\(strNowTime):\(Usernn))"
        let form = FormDescriptor(title: "\(titlename)")
        
        let section1 = FormSectionDescriptor(headerTitle: "流程标题", footerTitle: nil)
        /**流程标题*/
        var row = FormRowDescriptor(tag: Static.title , rowType: .Text, title: "")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Left.rawValue]
        row.value = title1
        section1.addRow(row)
        
        /**紧急选项*/
        row = FormRowDescriptor(tag: Static.InstancyType, rowType: .SegmentedControl, title: "")
        row.configuration[FormRowDescriptor.Configuration.Options] = ["0", "1", "2"]
        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in switch( value ) {
                case "0": return " 正常 "
                case "1": return " 重要 "
                case "2": return " 紧急 "
                default: return nil
                }
            } as TitleFormatterClosure
        row.value = "0"
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["segmentedControl.tintColor" : UIColor.redColor()]
        section1.addRow(row)
        
        let section2 = FormSectionDescriptor(headerTitle: "\(titlename)", footerTitle: nil)
        let section3 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        /**根据标志制作不同的表单*/
        if flag == 1{
        row = FormRowDescriptor(tag: Static.DATA_3, rowType: .Label , title: "上报人")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["valueLabel.text" : "\(Usernn)"]
        row.value = "\(Usernn)"
        section2.addRow(row)
        
        timeFormatter.dateFormat = "yyy-MM-dd"
        strNowTime = timeFormatter.stringFromDate(date) as String
        
        row = FormRowDescriptor(tag: Static.DATA_4, rowType: .Label , title: "日期")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["valueLabel.text" : "\(strNowTime)"]
        row.value = "\(strNowTime)"
        section2.addRow(row)
        
        
        row = FormRowDescriptor(tag: Static.DATA_7, rowType: .MultilineText, title: "本周\n工作\n内容")
        section3.addRow(row)
        
        row = FormRowDescriptor(tag: Static.DATA_8, rowType: .MultilineText, title: "下周\n工作\n计划")
        section3.addRow(row)
            
        }else if flag == 2{
            row = FormRowDescriptor(tag: Static.DATA_1, rowType: .Label, title: "登记人ID")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["valueLabel.text" : "\(USER_ID)"]
            row.value = "\(USER_ID)"
            section2.addRow(row)
            
            row = FormRowDescriptor(tag: Static.DATA_2, rowType: .Label, title: "登记时间")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["valueLabel.text" : "\(strNowTime)"]
            row.value = strNowTime
            section2.addRow(row)
            
            row = FormRowDescriptor(tag: Static.DATA_3, rowType: .Label, title: "登记人部门")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["valueLabel.text" : "\(DEPT_NAME)"]
            row.value = DEPT_NAME
            section2.addRow(row)
            
            row = FormRowDescriptor(tag: Static.DATA_4, rowType: .Label, title: "登记人角色")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["valueLabel.text" : "\(USER_PRIV)"]
            row.value = USER_PRIV
            section2.addRow(row)
            
            row = FormRowDescriptor(tag: Static.DATA_5, rowType: .DateAndTime, title: "请假开始时间")
            section3.addRow(row)
            row = FormRowDescriptor(tag: Static.DATA_7, rowType: .DateAndTime, title: "请假结束时间")
            section3.addRow(row)
            row = FormRowDescriptor(tag: Static.DATA_9, rowType: .Picker, title: "请假类型")
            row.configuration[FormRowDescriptor.Configuration.Options] = ["年假", "病假", "婚假","产假"]
            row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in
                switch( value ) {
                case "年假":
                    return "年假"
                case "病假":
                    return "病假"
                case "婚假":
                    return "婚假"
                default:
                    return "产假"
                }
                } as TitleFormatterClosure

            section3.addRow(row)
            
            row = FormRowDescriptor(tag: Static.DATA_10, rowType: .Label, title: "请假天数")
            section3.addRow(row)
            row = FormRowDescriptor(tag: Static.DATA_11, rowType: .Label, title: "登记人姓名")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["valueLabel.text" : "\(Usernn)"]
            row.value = Usernn
            section3.addRow(row)
            
            row = FormRowDescriptor(tag: Static.DATA_12, rowType: .Label, title: "审批人签字")
            section3.addRow(row)
            
            row = FormRowDescriptor(tag: Static.DATA_13, rowType: .MultilineText, title: "请假原因")
            section3.addRow(row)
            
        }else if flag == 3{
            row = FormRowDescriptor(tag: Static.DATA_3, rowType: .Date, title: "走访日期")
            section2.addRow(row)
            
            row = FormRowDescriptor(tag: Static.DATA_2, rowType: .Text , title: "客户名称")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
            section2.addRow(row)
            
            row = FormRowDescriptor(tag: Static.DATA_10, rowType: .Text , title: "所属行业")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
            section2.addRow(row)
            
            row = FormRowDescriptor(tag: Static.DATA_9, rowType: .Text , title: "用户规模")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
            section2.addRow(row)
            
            row = FormRowDescriptor(tag: Static.DATA_5, rowType: .Text , title: "联系人")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
            section2.addRow(row)
            
            row = FormRowDescriptor(tag: Static.DATA_1, rowType: .Text , title: "职务")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
            section2.addRow(row)
            
            row = FormRowDescriptor(tag: Static.DATA_7, rowType: .Text , title: "联系方式")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
            section2.addRow(row)
            
            row = FormRowDescriptor(tag: Static.DATA_8, rowType: .Text , title: "邮箱")
            row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
            section2.addRow(row)
            
            row = FormRowDescriptor(tag: Static.DATA_6, rowType: .MultilineText , title: "走访\n情况")
            section3.addRow(row)
        }
        
        form.sections = [section1,section2,section3]
        self.tableView!.contentInset.bottom = -30
        self.form = form
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            self.view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
