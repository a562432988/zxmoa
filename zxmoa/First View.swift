//
//  First View.swift
//  zxmoa
//
//  Created by mingxing on 16/3/7.
//  Copyright © 2016年 ruanxr. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

var USER_ID:String!
var USER_PRIV:String!
var DEPT_NAME:String!
class First_View: PageController{
//    @IBOutlet var backGroudView: UIView!

    var vcTitles = ["新闻", "公告", "资料","补丁"]
//    var vcTitles = ["新闻", "公告"]
    let vcClasses: [UIViewController.Type] = [XinWenController.self, GongGaoController.self,ZiLiaoController.self,BuDingController.self]
//    let vcClasses: [UIViewController.Type] = [XinWenController.self, GongGaoController.self]
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        itemsWidths = [80, 80,80,80]
        dataSource = self
        delegate = self
        preloadPolicy = PreloadPolicy.Neighbour
        titles = vcTitles
        viewControllerClasses = vcClasses
        pageAnimatable = true
        menuViewStyle = MenuViewStyle.Line
        bounces = true
        menuHeight = 40
        titleSizeNormal = 16
        titleSizeSelected = 17
        menuBGColor = .clearColor()
        automaticallyAdjustsScrollViewInsets = false // 阻止 tableView 上面的空白
        //        showOnNavigationBar = true
        //        pageController.selectedIndex = 1
        //        pageController.progressColor = .blackColor()
        //        pageController.viewFrame = CGRect(x: 50, y: 100, width: 320, height: 500)
        //        pageController.itemsWidths = [100, 50]
        //        pageController.itemsMargins = [50, 10, 100]
        //        pageController.titleSizeNormal = 12
        //        pageController.titleSizeSelected = 14
        //        pageController.titleColorNormal = UIColor.brownColor()
//                pageController.titleColorSelected = UIColor.blackColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ursll()
    }
    func ursll(){
        let urll = "http://www.zxmoa.com:83/general/info/user/do.php"
        let header = ["Cookie":"PHPSESSID=\(cookpsw)"]
        let param = ["op":"getSearchList","username":"\(Usernn)","b_month":"0","sex":"ALL","currentPage":"0","itemsPerPage":"10"]
        Alamofire.request(.POST,urll,parameters: param,headers:header).responseData{ response in
            if let j = response.result.value{
                let js = JSON(data: j)
                USER_ID = js["list"][0]["USER_ID"].string
                USER_PRIV = js["list"][0]["USER_PRIV"].string
                DEPT_NAME = js["list"][0]["DEPT_NAME"].string
                print("\(USER_ID),\(USER_PRIV),\(DEPT_NAME)")
            }
        }
    }

    
    // 内存警告!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - PageController DataSource
    func numberOfControllersInPageController(pageController: PageController) -> Int {
        return vcTitles.count
    }
    
    func pageController(pageController: PageController, titleAtIndex index: Int) -> String {
        return vcTitles[index]
    }

    // 代理里的方法
    // 结束就会触发
//    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        let i:Int = Int(self.contentScrollView.contentOffset.x / screenW)
//        selTitleBtn(buttons[i])
//        setUpOneChildViewController(i)
//    }
    
    /* 滑动就会触发
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    */

}
