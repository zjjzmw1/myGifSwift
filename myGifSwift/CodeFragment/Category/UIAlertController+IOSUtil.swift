//
//  UIAlertController+IOSUtil.swift
//  niaoyutong
//
//  Created by zhangmingwei on 2017/5/24.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    /// MARK: 初始化AlertController - 第一步
    public class func initAlertC(title: String?, msg: String?, style: UIAlertControllerStyle) -> UIAlertController {
        let vc = UIAlertController(title: title, message: msg, preferredStyle: style)
        return vc
    }
    /// 添加相关的按钮 - 第二步
    public func addMyAction(title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(action)
    }
    /// 弹出AlertV - 第三步
    public func showAlertC(vc: UIViewController!, completion: (() -> Void)?) {
        vc.present(self, animated: true, completion: completion)
    }

}
