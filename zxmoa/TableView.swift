//
//  TableView.swift
//  zxmoa
//
//  Created by mingxing on 16/3/8.
//  Copyright © 2016年 ruanxr. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableView: UIViewController, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    var name:[String]=[],names:[String]=[],namep:[String]=[]
    var sex:[String]=[],sexs:[String]=[],sexp:[String]=[]
    var phone:[String]=[],phones:[String]=[],phonep:[String]=[]
    var zhiW:[String]=[],zhiWs:[String]=[],zhiWp:[String]=[]
    var BuMen:[String]=[],BuMens:[String]=[],BuMenp:[String]=[]
    var a=0,b=0,c=0,d=0,e=0
    @IBOutlet weak var cover: UILabel!
    func urlrp(){
        Alamofire.request(.POST, "http://www.zxmoa.com:83/general/address/pubcenter/addpublic_do.php",parameters:["op":"getAddressList","ADDRESS_TYPE":"1","GROUP_ID": "30","f":"view","sortField":"A13","sortType":"ASC","currentPage":"0","itemsPerPage":"20"],headers:["Cookie":"PHPSESSID=\(cookpsw)"]).responseData { response in
            if let j = response.result.value {//ID30 zongjingl
                let js = JSON(data:j)
                self.name.append(js["list"][0]["A1"].string!)
                self.names.append(js["list"][0]["A25"].string!)
                self.namep.append(js["list"][0]["A5"].string!)
            }
//            dispatch_async(dispatch_get_main_queue(), {
                self.tableView?.reloadData()
                self.a=1
                if self.a==1 && self.b==1 && self.c==1 && self.d==1 && self.e==1{
                    self.cover.hidden=true
                    self.clearAllNotice()
                }
//                return
//            })
        }
        
        Alamofire.request(.POST, "http://www.zxmoa.com:83/general/address/pubcenter/addpublic_do.php",parameters:["op":"getAddressList","ADDRESS_TYPE":"1","GROUP_ID": "32","f":"view","sortField":"A13","sortType":"ASC","currentPage":"0","itemsPerPage":"20"],headers:["Cookie":"PHPSESSID=\(cookpsw)"]).responseData { response in
            if let j = response.result.value {
                let js = JSON(data:j)
                self.sex.append(js["list"][0]["A1"].string!)
                self.sex.append(js["list"][1]["A1"].string!)
                self.sexs.append(js["list"][0]["A25"].string!)
                self.sexs.append(js["list"][1]["A25"].string!)
                self.sexp.append(js["list"][0]["A5"].string!)
                self.sexp.append(js["list"][1]["A5"].string!)
            }
//            dispatch_async(dispatch_get_main_queue(), {
                self.tableView?.reloadData()
                self.b=1
                if self.a==1 && self.b==1 && self.c==1 && self.d==1 && self.e==1{
                    self.cover.hidden=true
                    self.clearAllNotice()
                }
//                return
//            })
            //                    print(4)
        }
        Alamofire.request(.POST, "http://www.zxmoa.com:83/general/address/pubcenter/addpublic_do.php",parameters:["op":"getAddressList","ADDRESS_TYPE":"1","GROUP_ID": "34","f":"view","sortField":"A13","sortType":"ASC","currentPage":"0","itemsPerPage":"20"],headers:["Cookie":"PHPSESSID=\(cookpsw)"]).responseData { response in
            if let j = response.result.value {//ID34 财务
                let js = JSON(data:j)
                self.phone.append(js["list"][0]["A1"].string!)
                self.phones.append(js["list"][0]["A25"].string!)
                self.phonep.append(js["list"][0]["A5"].string!)
            }
//            dispatch_async(dispatch_get_main_queue(), {
                self.tableView?.reloadData()
                self.c=1
                if self.a==1 && self.b==1 && self.c==1 && self.d==1 && self.e==1{
                    self.cover.hidden=true
                    self.clearAllNotice()
                }
//                return
//            })
            //                    print(5)
        }
        Alamofire.request(.POST, "http://www.zxmoa.com:83/general/address/pubcenter/addpublic_do.php",parameters:["op":"getAddressList","ADDRESS_TYPE":"1","GROUP_ID": "31","f":"view","sortField":"A13","sortType":"ASC","currentPage":"0","itemsPerPage":"20"],headers:["Cookie":"PHPSESSID=\(cookpsw)"]).responseData { response in
            if let j = response.result.value {//ID31 4G
                let js = JSON(data:j)
                let a:Int = js["list"].count
                for var i=0;i<a;i++
                {
                    self.zhiW.insert(js["list"][i]["A1"].string!, atIndex: i)
                    self.zhiWs.insert(js["list"][i]["A25"].string!, atIndex: i)
                    self.zhiWp.insert(js["list"][i]["A5"].string!, atIndex: i)
                }
            }
//            dispatch_async(dispatch_get_main_queue(), {
                self.tableView?.reloadData()
                self.d=1
                if self.a==1 && self.b==1 && self.c==1 && self.d==1 && self.e==1{
                    self.cover.hidden=true
                    self.clearAllNotice()
                }
//                return
//            })
        }
        Alamofire.request(.POST, "http://www.zxmoa.com:83/general/address/pubcenter/addpublic_do.php",parameters:["op":"getAddressList","ADDRESS_TYPE":"1","GROUP_ID": "33","f":"view","sortField":"A13","sortType":"ASC","currentPage":"0","itemsPerPage":"20"],headers:["Cookie":"PHPSESSID=\(cookpsw)"]).responseData { response in
            if let j = response.result.value {//ID33 工程
                let js = JSON(data:j)
                self.BuMen.insert(js["list"][0]["A1"].string!, atIndex: 0)
                self.BuMen.insert(js["list"][1]["A1"].string!, atIndex: 1)
                self.BuMen.insert(js["list"][2]["A1"].string!, atIndex: 2)
                self.BuMens.insert(js["list"][0]["A25"].string!, atIndex: 0)
                self.BuMens.insert(js["list"][1]["A25"].string!, atIndex: 1)
                self.BuMens.insert(js["list"][2]["A25"].string!, atIndex: 2)
                self.BuMenp.insert(js["list"][0]["A5"].string!, atIndex: 0)
                self.BuMenp.insert(js["list"][1]["A5"].string!, atIndex: 1)
                self.BuMenp.insert(js["list"][2]["A5"].string!, atIndex: 2)
            }
//            dispatch_async(dispatch_get_main_queue(), {
                self.tableView?.reloadData()
                self.e=1
                if self.a==1 && self.b==1 && self.c==1 && self.d==1 && self.e==1{
                    self.cover.hidden=true
                    self.clearAllNotice()
                }

//                return
//            })
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
            urlrp()
//        self.navigationItem.leftBarButtonItem = self.editButtonItem()//添加编辑按钮
//        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "listcelldata:")//增加按钮实现方法
//        self.navigationItem.rightBarButtonItem = addButton//添加增加按钮
//        tableView=UITableView(frame:self.view.frame,style:UITableViewStyle.Grouped)
        showNoticeWait()
        tableView.delegate = self
        tableView.dataSource = self
//        self.view.addSubview(tableView)
        
     // Uncomment the following line to preserve selection between presentations
     // self.clearsSelectionOnViewWillAppear = false

     // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }//title高度
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }//设置分区数量
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        switch (section) {
        case 0:
          return "总经理"
        case 1:
            return "办公室"
        case 2:
            return "财务室"
        case 3:
            return "4G事业部"
        case 4:
            return "工程部"
        default: return  ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (0 == section) {
            return name.count
        } else if (1 == section) {
            return sex.count
        } else if (2 == section) {
            return phone.count
        }
        else if (3 == section) {
            return zhiW.count
        }
        else if (4 == section) {
            return BuMen.count
        }
        return 0

    }//每组有多少

    
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    print(1)
    var cell = tableView.dequeueReusableCellWithIdentifier("cellid")
    if cell == nil{
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cellid")//设置cell样式
        cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator//右侧加小剪头
        }
    if (0 == indexPath.section) {
        cell?.textLabel?.text = name[indexPath.row]
        cell?.detailTextLabel?.text = "职务：\(names[indexPath.row])  | 电话：\(namep[indexPath.row])"
    }
        
    else if(1 == indexPath.section) {
    cell?.textLabel?.text = sex[indexPath.row]
        cell?.detailTextLabel?.text = "职务：\(sexs[indexPath.row])  | 电话：\(sexp[indexPath.row])"
    }
    
    else if (2 == indexPath.section) {
        cell?.textLabel?.text = phone[indexPath.row]
        cell?.detailTextLabel?.text = "职务：\(phones[indexPath.row])  | 电话：\(phonep[indexPath.row])"
    }
    else if (3 == indexPath.section) {
       cell?.textLabel?.text = zhiW[indexPath.row]
        cell?.detailTextLabel?.text = "职务：\(zhiWs[indexPath.row])  | 电话：\(zhiWp[indexPath.row])"
    }

    else if (4 == indexPath.section) {
        cell?.textLabel?.text = BuMen[indexPath.row]
        cell?.detailTextLabel?.text = "职务：\(BuMens[indexPath.row])  | 电话：\(BuMenp[indexPath.row])"

    }
    return cell!
    }//绘制cell
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ccc:NSIndexPath = indexPath
        var qb:[String]=["1","2","3","1"]
        if (0 == ccc.section) {
            qb[0]=name[ccc.row]
            qb[1]=names[ccc.row]
            qb[2]="总经理"
            qb[3]=namep[ccc.row]
        } else if (1 == ccc.section) {
            qb[0]=sex[ccc.row]
            qb[1]=sexs[ccc.row]
            qb[2]="办公室"
            qb[3]=sexp[ccc.row]
        } else if (2 == ccc.section) {
            qb[0]=phone[ccc.row]
            qb[1]=phones[ccc.row]
            qb[2]="财务室"
            qb[3]=phonep[ccc.row]
        }
        else if (3 == ccc.section) {
            qb[0]=zhiW[ccc.row]
            qb[1]=zhiWs[ccc.row]
            qb[2]="4G事业部"
            qb[3]=zhiWp[ccc.row]
        }
        else if (4 == ccc.section) {
            qb[0]=BuMen[ccc.row]
            qb[1]=BuMens[ccc.row]
            qb[2]="工程部"
            qb[3]=BuMenp[ccc.row]
        }

        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //点击cell后cell不保持选中状态
        
        
        let alertController = UIAlertController(title: "个人详情",
            message: "姓名：\(qb[0])     \n\n部门: \(qb[2])     \n\n职务：\(qb[1])     \n\n电话： \(qb[3])     \n\n", preferredStyle: .Alert)

        
        
        
        
        /**底部警告窗口设置*/
        let phe = UIAlertController(title: "呼出电话", message: "是否呼叫 \(qb[0])", preferredStyle: .ActionSheet)
        /**/
        let ok = UIAlertAction(title: "确定", style: .Default, handler: {action in let url1 = NSURL(string: "tel://\(qb[3])")
            UIApplication.sharedApplication().openURL(url1!)})
        /**警告窗口设置*/
        let cancelAction = UIAlertAction(title: "取消", style: .Destructive, handler: nil)
        
        phe.addAction(ok)
        phe.addAction(cancelAction)
        
        
        
        let cacel = UIAlertAction(title: "呼出", style:.Destructive,handler:{ action in self.presentViewController(phe, animated: true, completion: nil)} )
        let okAction = UIAlertAction(title: "取消", style: .Cancel,
            handler: nil)//定义详情取消按钮
        
        
        alertController.addAction(okAction)
        alertController.addAction(cacel)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.clearAllNotice()
    }

}
