//
//  GroupCellAll.swift
//  zxmoa
//
//  Created by mingxing on 16/3/17.
//  Copyright © 2016年 ruanxr. All rights reserved.
//

import UIKit

/**自定义cell的xib视图*/
class GroupCellAll: UITableViewCell {

    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var GroupEdit: UILabel!
    @IBOutlet weak var GroupTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        groupView.layer.cornerRadius = 5
        
        /**自动换行*/
        titleView.lineBreakMode = NSLineBreakMode.ByWordWrapping
        /**自动换行*/
        titleView.numberOfLines = 0
        // Initialization code
        
        /**设置cell阴影*/
        self.layer.shadowColor = UIColor.grayColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0, 3)//偏移距离
        self.layer.shadowOpacity = 0.3//不透明度
        self.layer.shadowRadius = 2.0//半径
        self.clipsToBounds = false
        /**设置cell阴影*/
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
