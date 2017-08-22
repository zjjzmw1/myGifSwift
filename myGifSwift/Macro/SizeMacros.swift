//
//  GlobalDefine.swift
//  swiftDemo1
//
//  Created by xiaoming on 16/3/7.
//  Copyright © 2016年 shandandan. All rights reserved.
//

import Foundation
import UIKit

/// 屏幕宽度
let SCREEN_WIDTH           = UIScreen.main.bounds.width
/// 屏幕高度
let SCREEN_HEIGHT          = UIScreen.main.bounds.height
// 状态栏高度
let STATUSBAR_HEIGHT : CGFloat = 20.0
/// 导航栏高度 64
let NAVIGATIONBAR_HEIGHT: CGFloat = 64.0
/// tabbar的高度 49
let TABBAR_HEIGHT: CGFloat = 49.0

/// 是否是iPhone5的屏幕宽度
let Is_Iphone5_Width          =    (UIScreen.main.bounds.width <= 320)

// App 版本号.
let APP_VERSION = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
// APP 名字
let APP_NAME    = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
// app build 版本
let APP_BUILD   = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
