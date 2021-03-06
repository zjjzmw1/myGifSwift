//
//  HomeVC.swift
//  myGifSwift
//
//  Created by zhangmingwei on 2017/8/23.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import pop

class HomeVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,KSPhotoBrowserDelegate {
    
    var tableView: UITableView!
    var dataArr: NSMutableArray!
    
    var refreshControl:ZJRefreshControl!;
    
    var lastRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true; // 隐藏导航栏
        self.initTableViewAndData()
        self.refreshAction()
        self.requestAction()
        
        // 接收通知：
        _ = NotificationCenter.default.rx.notification(Notification.Name("kBigImageDismissNofi")).takeUntil(self.rx.deallocated).subscribe(onNext: { (value) in
            SLog("aaaaaaaaaaaaaaa")
            self.tabBarController?.tabBar.isHidden = false
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initTableViewAndData() {
        dataArr = NSMutableArray()
        tableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 0 - TABBAR_HEIGHT), style: .grouped)
        if IS_IOS11 {
            tableView.frame = CGRect.init(x: 0, y: -20, width: SCREEN_WIDTH, height: SCREEN_HEIGHT + 20 - TABBAR_HEIGHT)
        }
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(PSVisualCell.classForCoder(), forCellReuseIdentifier: "PSVisualCell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.1))
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.1))
        tableView.sectionFooterHeight = 0.1
        tableView.backgroundColor = UIColor.getBackgroundColorSwift()
        
        // 下拉刷新 -- 绚丽的，暂时不用
//        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
//        loadingView.tintColor = UIColor.white
//        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
//            self?.requestAction()
//            }, loadingView: loadingView)
//        tableView.dg_setPullToRefreshFillColor(UIColor.getMainColorSwift())
//        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        // 下拉、上提刷新
        refreshControl = ZJRefreshControl(scrollView: tableView, refreshBlock: {
            self.requestAction()
        }, loadmoreBlock: {
            self.requestMoreAction()
        })
        
    }
    
    // MARK: 表格代理相关
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 206
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PSVisualCell", for: indexPath) as! PSVisualCell
        
        let myGifM = self.dataArr.object(at: indexPath.row) as? MyGifModel
        if let urlStr = myGifM?.dataDic?.image?.url {
            cell.reloadBackgroundImageUrl(urlStr, description: "")
        } else if let urlStr = myGifM?.dataDic?.userImage?.url {
            cell.reloadBackgroundImageUrl(urlStr, description: "")
        }
        // 添加pop动画 -- 透明度渐变
        let animation1: POPBasicAnimation! = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        animation1.fromValue = 0.0
        animation1.toValue = 1.0
        animation1.duration = 1.0
        cell.backgroundImageView.pop_add(animation1, forKey: "fade")
        // 添加pop动画 -- 渐进
        let animation: POPBasicAnimation! = POPBasicAnimation(propertyNamed: kPOPLayerPositionX)
        if lastRow <= indexPath.row {
            animation.fromValue = NSValue.init(cgPoint: CGPoint.init(x: -SCREEN_WIDTH/2.0, y: 0 ))
        } else {
            animation.fromValue = NSValue.init(cgPoint: CGPoint.init(x: SCREEN_WIDTH, y: 0 ))
        }
        lastRow = indexPath.row
        animation.toValue = NSValue.init(cgPoint: CGPoint.init(x: SCREEN_WIDTH/2.0, y: 0 ))
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        cell.backgroundImageView.layer.pop_add(animation, forKey: "position")
        // 添加pop动画 -- 变大
        let animation2: POPSpringAnimation! = POPSpringAnimation(propertyNamed: kPOPLayerBounds)
        animation2.toValue = NSValue.init(cgRect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 300))
        cell.backgroundImageView.layer.pop_add(animation2, forKey: "size")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath) as! PSVisualCell
        let myGifM = self.dataArr.object(at: indexPath.row) as? MyGifModel
        let urlArr = NSMutableArray.init()
        for i in 0 ..< self.dataArr.count {
            let model = self.dataArr.object(at: i) as? MyGifModel
            var url = model?.dataDic?.image?.url
            if url == nil {
                url = model?.dataDic?.userImage?.url
            }
            if let url = url {
                urlArr.add(url)
            }
        }
        var urlStr = myGifM?.dataDic?.image?.url
        if urlStr == nil {
            urlStr = myGifM?.dataDic?.userImage?.url
        }
        if urlStr == nil {
            return
        }
        var currentIndex = 0
        var urlCount = 1
        if urlArr.count > 1 {
            urlCount = urlArr.count
        }
        if urlCount > indexPath.row {
            currentIndex = indexPath.row
        }
        self.tabBarController?.tabBar.isHidden = true
        // 大图浏览器
        Tooles.showBigImage(cell.backgroundImageView, bigImageUrl: urlStr, bigImageUrlArray: urlArr as! [Any], pictureCount: Int32(urlCount), currentIndex: Int32(currentIndex))
    }
    
    func ks_photoBrowser(_ browser: KSPhotoBrowser, didSelect item: KSPhotoItem, at index: UInt) {
//        SLog(index)
        // 收藏、保存到本地
//        if (![NSString isEmptyString:bigImageUrlArray[index]]) {
//            [Tool showAlertCWithUrlStr:bigImageUrlArray[index] currentImage:wBrowser.currentLongPressImage];
//        }
        
//        if !String.isEmptyString(str: item.imageUrl.absoluteString) {
//            Tool.showAlertC(urlStr: item.imageUrl.absoluteString, currentImage: item.image)
//        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in self.tableView.visibleCells {
            if let cell = cell as? PSVisualCell {
                cell.reload(with: scrollView, totalView: self.view)
            }
        }
    }
    
    func requestAction() {
        if self.dataArr.count == 0 {
            ProgressHUD.show(with: self.view, title: "")
        }
        let bquery = BmobQuery.init(className: "MyGif")
        bquery?.limit = 20
        bquery?.order(byDescending: "updatedAt")
        bquery?.findObjectsInBackground({ [weak self] (resultArr, error) in
//            self?.tableView.dg_stopLoading()
            self?.refreshControl.endRefreshing()
            if let resultArr = resultArr {
                ProgressHUD.dismissDelay(0)
                self?.dataArr = NSMutableArray.init()
                for i in 0 ..< resultArr.count {
                    let mygifM = MyGifModel.deserialize(from: (resultArr[i] as! BmobObject).modelToJSONString())
                    self?.dataArr.add(mygifM ?? MyGifModel.init())
                }
            } else {
                ProgressHUD.showError("加载失败")
            }
            self?.refreshAction()
        })
    }
    
    func requestMoreAction() {
        let bquery = BmobQuery.init(className: "MyGif")
        bquery?.limit = 20
        bquery?.skip = self.dataArr.count
        bquery?.order(byDescending: "updatedAt")
        bquery?.findObjectsInBackground({ [weak self] (resultArr, error) in
//            self?.tableView.dg_stopLoading()
            self?.refreshControl.endLoadingmore()
            if let resultArr = resultArr {
                for i in 0 ..< resultArr.count {
                    let mygifM = MyGifModel.deserialize(from: (resultArr[i] as! BmobObject).modelToJSONString())
                    self?.dataArr.add(mygifM ?? MyGifModel.init())
                }
            }
            self?.refreshAction()
        })
    }
    
    func refreshAction() {
        if self.dataArr.count > 0 {
            Tool.saveHandyModelArrayToJSON(modelArray: self.dataArr, fileName: "MyGif") // 保存动图列表
        } else {
           self.dataArr = NSMutableArray.init()
           let arr = Tool.getHandyModelArrayFromFile(fileName: "MyGif") // 获取动图列表 - 里面其实是字典，需要转为model才OK
            if let arr = arr, arr.count > 0 {
                for dict in arr {
                    if let dict = dict as? NSDictionary, let model = MyGifModel.deserialize(from: dict) {
                        self.dataArr.add(model)
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    // 滑动删除、收藏等   ----------- 注释了这行就没有滑动删除了。。。。很方便
    /// - 滑动方法
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action2 = UITableViewRowAction(style: .default, title: NSLocalizedString("删除", comment: "")) { [weak self] (rowAction, indexP) in
            // 删除的方法
            let myGifM = self?.dataArr.object(at: indexPath.row) as? MyGifModel
            let bmobQ = BmobQuery.init(className: "MyGif")
            bmobQ?.getObjectInBackground(withId: myGifM?.dataDic?.objectId, block: { [weak self] (bmobObject, error) in
                if error == nil {
                    if let bmobObject = bmobObject {
                        bmobObject.deleteInBackground({ (isSuccessed, error) in
                            if isSuccessed {
                                self!.dataArr.removeObject(at: indexPath.row)
                                self?.refreshAction()
                            }
                        })
                    }
                }
            })
        }
        
        return [action2]
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
}
