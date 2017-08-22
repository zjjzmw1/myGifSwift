//
//  UtilMacros.swift
//  ZMWJoke
//
//  Created by xiaoming on 16/9/3.
//  Copyright © 2016年 shandandan. All rights reserved.
//

import Foundation
import UIKit
// iOS系统版本
let IS_IOS7 = (UIDevice.current.systemVersion as NSString).doubleValue >= 7.0
let IS_IOS8 = (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0
let IS_IOS9 = (UIDevice.current.systemVersion as NSString).doubleValue >= 9.0
let IS_IOS10 = (UIDevice.current.systemVersion as NSString).doubleValue >= 10.0

/// 获取字体的方法
public func FONT_PingFang(fontSize: CGFloat) -> UIFont {
    var font = UIFont.init(name: "PingFangSC-Regular", size: fontSize)
    if !IS_IOS9 {
        font = UIFont.init(name: "Helvetica", size: fontSize)
    }
    return font!
}
