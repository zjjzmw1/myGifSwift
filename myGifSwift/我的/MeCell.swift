//
//  MeCell.swift
//  myGifSwift
//
//  Created by zhangmingwei on 2017/8/29.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

import UIKit
import Cartography

class MeCell: UITableViewCell {

    var nameLbl: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.nameLbl = Tool.initALabel(frame: .zero, textString: "", font: FONT_PingFang(fontSize: 14), textColor: UIColor.getMainColorSwift())
        self.nameLbl.textAlignment = .left
        self.nameLbl.numberOfLines = 0
        self.contentView.addSubview(self.nameLbl)
        constrain(nameLbl) { nameLbl in
            nameLbl.left == nameLbl.superview!.left + 10
            nameLbl.right == (nameLbl.superview!.right) - 10
            nameLbl.centerY == nameLbl.superview!.centerY
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
