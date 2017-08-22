//
//  JCView.swift
//  JCSwiftKitDemo
//
//  Created by molin.JC on 2016/12/31.
//  Copyright © 2016年 molin. All rights reserved.
//

import UIKit

extension UIView {

    /// 删除所有子视图
    func removeAllSubViews() {
        for view in self.subviews {
            view.removeFromSuperview();
        }
    }
    
    /// - UIView通用的点击事件 - 返回self (返回的直接用就可以，不会引起循环引用)
//    func setTapAction(complation: @escaping (Any?)->Void) -> Void {
//        self.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer.init() { (tap) in
//            complation(self)
//        }
//        self.addGestureRecognizer(tap)
//    }

    /// 获取View所在的控制器，响应链上的第一个Controller
    func topVC() -> UIViewController? {
        var nextResponder = self as UIResponder?;
        repeat {
            if nextResponder?.next == nil {
                return nil
            }
            nextResponder = nextResponder?.next!;
            if nextResponder is UIViewController {
                return nextResponder as? UIViewController;
            }
        }while (nextResponder != nil);
        return nil;
    }
    
    
    func cornerRadius(radius: CGFloat) -> UIView {
        self.clipsToBounds = true;
        self.layer.cornerRadius = radius;
        return self;
    }
    
    func borderWidth(width: CGFloat) -> UIView {
        self.layer.borderWidth = width;
        return self;
    }
    
    func borderColor(color: UIColor) -> UIView {
        self.layer.borderColor = color.cgColor;
        return self;
    }
    
    /// 视图快照(截图)
    func snapshotImageSwift() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0);
        self.layer.render(in: (UIGraphicsGetCurrentContext())!);
        let snap = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snap!;
    }
    
    ///视图快照(截图) 屏幕会闪下
    func snapshotImageAfterScreenUpdates(afterUpdates: Bool) -> UIImage {
        if !self.responds(to: #selector(UIView.drawHierarchy(in:afterScreenUpdates:))) {
            return self.snapshotImageSwift();
        }
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0);
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: afterUpdates);
        let snap = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snap!;
    }
    
    /// 生成快照PDF
    func snapshotPDFSwift() -> NSData {
        var bounds = self.bounds;
        let data = NSMutableData.init();
        let consumer = CGDataConsumer.init(data: data as CFMutableData);
        let context = CGContext.init(consumer: consumer!, mediaBox: &bounds, nil);
        context?.beginPDFPage(nil);
        context?.translateBy(x: 0, y: bounds.size.height);
        context?.scaleBy(x: 1.0, y: -1.0);
        self.layer.render(in: context!);
        context?.endPDFPage();
        context?.closePDF();
        return data;
    }
    
    /// 根据触摸点，获取子视图
    func getSubviewWithTouches(touches: Set<UITouch>) -> AnyObject? {
        let touch = touches.first;
        let point = touch?.location(in: self);
        for _subview in self.subviews {
            if (_subview.frame.contains(point!)) {
                return _subview;
            }
        }
        return nil;
    }
}

// MARK: - Frame
extension UIView {
    
    /// 左边   -   读、写
    func left() -> CGFloat! {
        return self.frame.origin.x
    }
    func left(x:CGFloat) {
        var aFrame : CGRect = self.frame
        aFrame.origin.x = x
        self.frame = aFrame
    }
    /// 上边   -   读、写
    func top() -> CGFloat! {
        return self.frame.origin.y
    }
    func top(y:CGFloat) {
        var aFrame : CGRect = self.frame
        aFrame.origin.y = y
        self.frame = aFrame
    }
    
    func width(w:CGFloat) {
        var aFrame : CGRect = self.frame
        aFrame.size.width = w
        self.frame = aFrame
    }
    
    func height(h:CGFloat) {
        var aFrame : CGRect = self.frame
        aFrame.size.height = h
        self.frame = aFrame
    }
    
    func centerX(cX:CGFloat) {
        self.center = CGPoint.init(x: cX, y: self.center.y)
    }
    
    func centerY(cY:CGFloat) {
        self.center = CGPoint.init(x: self.center.x, y: cY)
    }
    
    // frame.origin.x
    var x: CGFloat {
        set {
            var rect = self.frame;
            rect.origin.x = x;
            self.frame = rect;
        }
        
        get {
            return self.frame.origin.x;
        }
    }
    
    // frame.origin.y
    var y: CGFloat {
        set {
            var rect = self.frame;
            rect.origin.y = y;
            self.frame = rect;
        }
        
        get {
            return self.frame.origin.y;
        }
    }
    
    // 左间距
    var leftSpacing: CGFloat {
        set {
            self.x = leftSpacing;
        }
        
        get {
            return self.x;
        }
    }
    
//    // 右间距
//    var rightSpacing: CGFloat {
//        set {
//            self.width = (self.superview?.width)! - rightSpacing - self.x;
//        }
//
//        get {
//            return (self.superview?.width)! - self.width - self.x;
//        }
//    }
    
    // 上间距
    var topSpacing: CGFloat {
        set {
            self.y = topSpacing;
        }
        
        get {
            return self.y;
        }
    }
    
//    // 下间距
//    var bottomSpacing: CGFloat {
//        set {
//            self.height = (self.superview?.height)! - bottomSpacing - self.y;
//        }
//
//        get {
//            return (self.superview?.height)! - self.height - self.y;
//        }
//    }
}
