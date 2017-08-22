//
//  UINavigationItem+JCLoading.swift
//  JCSwiftKitDemo
//
//  Created by molin.JC on 2017/1/22.
//  Copyright © 2017年 molin. All rights reserved.
//

import UIKit
import Foundation

private var _kLoading = "kLoading";

extension UINavigationItem {
    
    func startLoadingAnimating(_ loadingTitle: String?) {
        // 默认文字
        var titleStr = NSLocalizedString("加载中...", comment: "")
        self.stopLoadingAnimating();
        objc_setAssociatedObject(self, _kLoading, self.titleView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        let loader = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray);
        if !String.isEmptyString(str: loadingTitle) {
            titleStr = loadingTitle!
        }
        let titleW = titleStr.sizeFor(size: CGSize.init(width: SCREEN_WIDTH, height: 20),font: FONT_PingFang(fontSize: 18)).width
        let titleV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 44))
        self.titleView = titleV;
        titleV.backgroundColor = UIColor.clear
        let titleLbl = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: titleW, height: 44))
        titleLbl.text = titleStr
        titleLbl.textAlignment = .center
        titleLbl.textColor = UIColor.getTitleColorSwift()
        titleLbl.font = FONT_PingFang(fontSize: 18)
        titleLbl.backgroundColor = UIColor.clear
        titleV.addSubview(loader)
        titleV.addSubview(titleLbl)
        titleLbl.centerX = titleLbl.superview!.centerX + 15
        titleLbl.centerY = titleV.centerY
        loader.centerX = titleLbl.superview!.centerX - titleW/2.0
        loader.centerY = titleV.centerY
        loader.startAnimating();
    }
    
    func stopLoadingAnimating() {
        let componentToRestore = objc_getAssociatedObject(self, _kLoading);
        self.titleView = componentToRestore as! UIView?;
        objc_setAssociatedObject(self, _kLoading, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
