//
//  UIButton+IOSUtil.swift
//  niaoyutong
//
//  Created by zhangmingwei on 2017/5/24.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    /// - 设置按钮是否可以点击的状态 （不可点击为灰色，可点击为蓝色）
    public func setButtonEnabled(isEnable: Bool) {
        if isEnable {
            self.backgroundColor = UIColor.getMainColorSwift()
            self.setTitleColor(UIColor.white, for: .normal)
            self.isUserInteractionEnabled = true
        } else {
            self.backgroundColor = UIColor.colorRGB16(value: 0xececec)
            self.setTitleColor(UIColor.getContentSecondColorSwift(), for: .normal)
            self.isUserInteractionEnabled = false
        }
    }
    
}

/// MARK: - 避免按钮多次点击的方法 - (按钮的touchUpInside和Down能做到相互不影响)
extension UIButton {
    /// 默认是0.5秒内不能重复点击按钮
    private struct AssociatedKeys {
        static var xlx_defaultInterval:TimeInterval = 0.5
        static var xlx_customInterval = "xlx_customInterval"    // 需要自定义事件间隔的话例如 :TimeInterval = 1.0
        static var xlx_ignoreInterval = "xlx_ignoreInterval"
    }
    // 自定义属性用来添加自定义的间隔时间。可以设置 1秒、2秒，等等
    var customInterval: TimeInterval {
        get {
            let xlx_customInterval = objc_getAssociatedObject(self, &AssociatedKeys.xlx_customInterval)
            if let time = xlx_customInterval {
                return time as! TimeInterval
            }else{
                return AssociatedKeys.xlx_defaultInterval
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.xlx_customInterval,  newValue as TimeInterval ,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /// 自定义属性 - 是否忽略间隔
    var ignoreInterval: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.xlx_ignoreInterval) != nil)
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.xlx_ignoreInterval, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override open class func initialize() {
        if self == UIButton.self {
            DispatchQueue.once("com.wj.niaoyutong", block: {
//                DispatchQueue.once(NSUUID().uuidString, block: {
                // 先获取到系统和自己的 selector
                let systemSel = #selector(UIButton.sendAction(_:to:for:))
                let swizzSel = #selector(UIButton.mySendAction(_:to:for:))
                // 再根据seletor获取到Method
                let systemMethod = class_getInstanceMethod(self, systemSel)
                let swizzMethod = class_getInstanceMethod(self, swizzSel)
                /// 把系统的方法添加到类里面 - 如果存在就添加失败
                let isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod))
                if isAdd {
                    class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
                } else {
                    method_exchangeImplementations(systemMethod, swizzMethod);
                }
            })
        }
    }
    
    private dynamic func mySendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if !ignoreInterval {
            isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+customInterval, execute: { [weak self] in
                self?.isUserInteractionEnabled = true
            })
        }
        mySendAction(action, to: target, for: event)
    }
}



