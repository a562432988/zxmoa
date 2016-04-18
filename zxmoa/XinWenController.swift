//
//  XinWenController.swift
//  zxmoa
//
//  Created by mingxing on 16/3/16.
//  Copyright © 2016年 ruanxr. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh

class XinWenController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var tableView:UITableView?
    var cover:UILabel?
    var Xinwen:[[String]]=[]
    var isNew:[[Bool]] = []
    var a = 0, b = 0 , c = 0,flag = 0
    var urll = "http://www.zxmoa.com:83/general/news/show/newslist_do.php"
    var parameters:[String : String] = ["type":"list","USER_ID":"\(USER_ID)","currentPage":"0","itemsPerPage":"10"]
    var header = ["Cookie":"PHPSESSID=\(cookpsw)"]
    // 顶部刷新
    let aheader = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    
    override func loadView() {
        super.loadView()//通过xib加载时图
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.Xinwen = [[String]](count: 0, repeatedValue: [String](count: 4, repeatedValue: ""))
        ursll("0")
        creativeCell()//创建cell
        //发送请求
        tableView!.reloadData()
        // 下拉刷新
        aheader.setRefreshingTarget(self, refreshingAction: Selector("headerRefresh"))
        // 现在的版本要用mj_header
        tableView!.mj_header = aheader
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: Selector("footerRefresh"))
        tableView!.mj_footer = footer
        self.tabBarController?.tabBar.hidden = false
    }
    // 底部刷新
    var index = 0
    func footerRefresh(){
        if index < b - 1{
            index += 1
            ursll("\(index)")
            self.tableView!.mj_footer.endRefreshing()
        }
        else {
            footer.endRefreshingWithNoMoreData()
        }
    }
    func headerRefresh(){
        uryanz("0")
        if flag == 1{
            headerursll("0")
            // 结束刷新
            self.tableView!.mj_header.endRefreshing()
        }
        else{
            self.tableView!.mj_header.endRefreshing()
        }
    }

    /**判断是否有新的*/
    func uryanz(ur:String){
        parameters.updateValue(ur, forKey: "currentPage")
        Alamofire.request(.POST,urll,parameters:parameters,headers: header ).responseData{ response in
            if let j = response.result.value{
                let js = JSON(data: j)
                let q = Int(js["totalCount"].string!)!
                if(q > self.c){
                    self.flag = q - self.c
                } else {
                    self.flag = 0
                }
            }
            
        }
    }
    
    func headerursll(ur:String){
        var xin:[[String]]=[]
        parameters.updateValue(ur, forKey: "currentPage")
        Alamofire.request(.POST,urll,parameters:parameters,headers: header ).responseData{ response in
            if let j = response.result.value{
                let js = JSON(data: j)
                self.a = js["list"].count;self.b = Int(js["totalCount"].string!)!
                self.c = self.b
                xin = [[String]](count: self.a, repeatedValue: [String](count: 4, repeatedValue: ""))
                //                print(self.Xinwen, 111)
                let qq:[String]=["NEWS_ID","SUBJECT","PROVIDER_NAME","NEWS_TIME"]
                for var i=0;i<self.flag;i+=1{
                    for var j=0;j<4;j+=1{
                        let q = qq[j]
                        xin[i][j] = js["list"][i][q].string!
                    }
                    if self.Xinwen.count >= 10{
                        self.Xinwen.removeLast()
                    }
                    self.Xinwen.insert(xin[i],atIndex:0)
                }
                self.tableView!.reloadData()
                self.cover!.hidden=true
            }
        }
    }

    func ursll(ur:String){
        var xin:[[String]]=[]
        parameters.updateValue(ur, forKey: "currentPage")
//        showNoticeWait()
        Alamofire.request(.POST,urll,parameters:parameters,headers: header ).responseData{ response in
            if let j = response.result.value{
                let js = JSON(data: j)
                self.a = js["list"].count;self.b = Int(js["totalCount"].string!)!
                self.c = self.b
                xin = [[String]](count: self.a, repeatedValue: [String](count: 4, repeatedValue: ""))
                //                print(self.Xinwen, 111)
                let qq:[String]=["NEWS_ID","SUBJECT","PROVIDER_NAME","NEWS_TIME"]
                for var i=0;i<self.a;i+=1{
                    for var j=0;j<4;j+=1{
                        let q = qq[j]
                        xin[i][j] = js["list"][i][q].string!
                    }
                }
                if self.b%10 == 0 {
                    self.b = self.b / 10
                }else{
                    self.b = self.b / 10 + 1
                }
                self.Xinwen += xin
//                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView!.reloadData()
                    self.cover!.hidden=true
                    self.clearAllNotice()
//                    return
//                })
            }
            
        }
        
    }
    
    
    func creativeCell(){
        self.tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Plain)
        self.tableView?.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 150)
        cover = UILabel(frame: self.view.frame )
        cover!.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255,
            blue: 0xf0/255, alpha: 1)
        
        //创建控件
        self.tableView!.dataSource=self
        self.tableView!.delegate=self
        //实现代理
        
        self.tableView!.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255,
            blue: 0xf0/255, alpha: 1)
        
        self.tableView!.registerNib(UINib(nibName:"GroupCellAll", bundle:nil),
            forCellReuseIdentifier:"mycell")
        
        //        self.tableView!.rowHeight = UITableViewAutomaticDimension;
        self.tableView!.estimatedRowHeight = 150.0;
        
        //去除单元格分隔线
        self.tableView!.separatorStyle = .None
        
        //去除尾部多余的空行
        //        tableView!.tableFooterView = UIView(frame:CGRectZero)
        
        self.view.addSubview(tableView!)
        self.view.addSubview(cover!)
        //显示控件
    }

    
    //设置每组有多少数量
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Xinwen.count
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:GroupCellAll = tableView.dequeueReusableCellWithIdentifier("mycell")
            as! GroupCellAll

        cell.titleView.text = self.Xinwen[indexPath.row][1]
        cell.GroupEdit.text = self.Xinwen[indexPath.row][2]
        cell.GroupTime.text = self.Xinwen[indexPath.row][3]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //点击cell后cell不保持选中状态
        
        let newId = "news/show/read_news.php?NEWS_ID=" + self.Xinwen[indexPath.row][0]
        let vc = webView()
        vc.data = newId
        vc.titles = "公司新闻"
        
        //present方法进入二级页面
//        self.presentViewController(vc, animated: true, completion: nil)
        
        vc.hidesBottomBarWhenPushed = true
        //在push到二级页面后隐藏tab bar
        
        self.navigationController?.pushViewController(vc, animated: true)
        //页面跳转 push方法
        

    }
    
    override func viewDidDisappear(animated: Bool) {
        self.clearAllNotice()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
