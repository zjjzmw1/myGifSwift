//
//  BaseViewController.swift
//  supermarket
//
//  Created by zhangmingwei on 2017/8/15.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

import UIKit
import Cartography
import IQKeyboardManagerSwift
import RxCocoa
import RxSwift

class BaseViewController: UIViewController {

    // 添加单利后其他的页面才可以调用本文件，并且新建文件的时候可以继承本文件！！！！！！
    static let shared = BaseViewController() // 跟视图的单利
    
    var refreshHeaderSwift: RHRefreshHeader?    // 下拉刷新控件
    var refreshFooterSwift: RHRefreshFooter?    // 上提刷新控件
    var currentPage: Int = 0    // 当前页数
    var emptyView: EmptyView!   // 空页面
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 默认是带的
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = true
        // 默认背景色
        view.backgroundColor = UIColor.getBackgroundColorSwift()
        // 默认显示导航栏
//        self.fd_prefersNavigationBarHidden = false; // .........
        
        // 隐藏导航栏 在具体的页面的viewDidLoad方法添加这句
        //    self.fd_prefersNavigationBarHidden = true;
        self.automaticallyAdjustsScrollViewInsets = false;
        
        //        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
        //        IQKeyboardManager.sh
        self.baseNextPageTitleButton(nextPageTitle: " ")
        // 初始化空页面
        self.emptyView = EmptyView.init(frame: self.view.frame)
        self.view.addSubview(self.emptyView)
        self.emptyView.isHidden = true
        self.emptyView.image(nil, label: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    // MARK: - 添加标题
    func addTitle(titleString: String) {
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
        titleLbl.text = titleString
        titleLbl.textAlignment = .center
        titleLbl.textColor = UIColor.black
        titleLbl.font = FONT_PingFang(fontSize: 18)
        self.navigationItem.titleView = titleLbl
    }
    
    // MARK: - 下个页面的返回按钮------（传空格就是只有一个箭头）。
    func baseNextPageTitleButton(nextPageTitle: String?) {
        var titleString: String;
        if (nextPageTitle == nil || nextPageTitle == "") {//传空 ，默认返回。
            titleString = NSLocalizedString("返回", comment: "")
        } else {
            titleString = nextPageTitle!;
        }
        //下一级界面返回按钮
        let temporaryBarButtonItem = UIBarButtonItem();
        temporaryBarButtonItem.title = titleString;
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    }
    
    
    /// 导航栏右边的按钮
    ///
    /// - Parameters:
    ///   - name: 按钮名字
    ///   - image: 按钮图片
    ///   - block: 点击按钮的回调
    func rightButton(name: String?, image: UIImage?, block:((_ button: UIButton?) -> Void)?) {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: 100, height: 44)
        btn.contentHorizontalAlignment = .right
        btn.titleLabel?.font = FONT_PingFang(fontSize: 15)
        if let image = image {
            btn.setImage(image, for: .normal)
        }
        if let name = name {
            btn.setTitle(name, for: .normal)
            btn.setTitleColor(UIColor.getContentColorSwift(), for: .normal)
            let width = btn.title(for: .normal)?.sizeFor(size: CGSize.init(width: SCREEN_WIDTH, height: 44), font: FONT_PingFang(fontSize: 15), lineBreakMode: .byWordWrapping).width ?? 60.0
            btn.frame = CGRect.init(x: 0, y: 0, width: width, height: 44)
        } else {
            btn.frame = CGRect.init(x: 0, y: 0, width: 60, height: 44)
        }
        
        let rightItem = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = rightItem
        let naviSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        naviSpace.width = -5 // 值越大越靠左边
        self.navigationItem.rightBarButtonItems = [naviSpace,rightItem]
        if let block = block {
//            btn.rac_signal(for: .touchUpInside).subscribeNext({ UIButton in
//                block(btn)
//            })
            _ = btn.rx.controlEvent(.touchUpInside).subscribe({_ in
                block(btn)
            })
        }
    }
    
    func rightView(tempV: UIView, block:((_ tempV: UIView) -> Void)?) {
        
        let rightItem = UIBarButtonItem(customView: tempV)
        self.navigationItem.rightBarButtonItem = rightItem
        let naviSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        naviSpace.width = -5 // 值越大越靠左边
        self.navigationItem.rightBarButtonItems = [naviSpace,rightItem]
        if let block = block {
            tempV.setTapActionWith({
                block(tempV)
            })
        }
    }
    
    /// 导航栏右边的按钮
    ///
    /// - Parameters:
    ///   - name: 按钮名字
    ///   - image: 按钮图片
    ///   - block: 点击按钮的回调
    func leftButton(name: String?, image: UIImage?, block:((_ button: UIButton?) -> Void)?) {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: 100, height: 44)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font = FONT_PingFang(fontSize: 15)
        if let image = image {
            btn.setImage(image, for: .normal)
        }
        if let name = name {
            btn.setTitle(name, for: .normal)
            btn.setTitleColor(UIColor.getContentColorSwift(), for: .normal)
            let width = btn.title(for: .normal)?.sizeFor(size: CGSize.init(width: SCREEN_WIDTH, height: 44), font: FONT_PingFang(fontSize: 15), lineBreakMode: .byWordWrapping).width ?? 60.0
            btn.frame = CGRect.init(x: 0, y: 0, width: width, height: 44)
        } else {
            btn.frame = CGRect.init(x: 0, y: 0, width: 60, height: 44)
        }
        
        let leftItem = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = leftItem
        let naviSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        naviSpace.width = -5 // 值越大越靠左边
        self.navigationItem.leftBarButtonItems = [naviSpace,leftItem]
        if let block = block {
//            btn.rac_signal(for: .touchUpInside).subscribeNext({ UIButton in
//                block(btn)
//            })
            _ = btn.rx.controlEvent(.touchUpInside).subscribe({_ in
                    block(btn)
            })
        }
    }
    
    /// 可以查看某个页面是否引起的循环引用
    deinit {
        print("页面: \(self.className()) 释放了内存")
    }
    
}

