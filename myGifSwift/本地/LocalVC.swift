//
//  LocalVC.swift
//  myGifSwift
//
//  Created by zhangmingwei on 2017/8/22.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

import UIKit
import Photos

class LocalVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.getLocalImagesAction()
    }
    
    var tableView: UITableView!
    var dataArr: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true; // 隐藏导航栏
        self.initTableViewAndData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 获取收藏的数组的url
        self.getLocalImagesAction()
        
        
    }
    
    /// 获取本地相册所有照片方法
    func getLocalImagesAction() {
        // 注册通知
        PHPhotoLibrary.shared().register(self as PHPhotoLibraryChangeObserver)
        let allOptions = PHFetchOptions()
        let allResults = PHAsset.fetchAssets(with: allOptions)
        if allResults.count > 0 {
            let tempArr = NSMutableArray()
            self.dataArr = NSMutableArray()
            for i in 0 ..< allResults.count {
                tempArr.add(allResults[i])
            }
            self.dataArr = NSMutableArray.init(array: tempArr)
        }
        self.tableView.reloadData()
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
        
        let phAsset = self.dataArr[indexPath.row] as! PHAsset
        
        PHCachingImageManager.default().requestImage(for: phAsset, targetSize: .zero, contentMode: .aspectFit, options: nil) { (image, dict) in
            cell.reloadBackgroundImage(image, description: "")
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath) as! PSVisualCell
//        let urlStr = self.dataArr.object(at: indexPath.row) as! String
//        self.tabBarController?.tabBar.isHidden = true
//
//        if !String.isEmptyString(str: urlStr) {
//            var currentIndex = 0
//            var urlCount = 1
//            if dataArr.count > 1 {
//                urlCount = dataArr.count
//            }
//            if urlCount > indexPath.row {
//                currentIndex = indexPath.row
//            }
            // 大图浏览器
//            Tooles.showBigImage(cell.backgroundImageView, bigImageUrl: urlStr, bigImageUrlArray: self.dataArr as! [Any], pictureCount: Int32(urlCount), currentIndex: Int32(currentIndex))
        
//        Tooles.showBigImage(cell.backgroundImageView, bigImageUrl: <#T##String!#>, bigImageUrlArray: <#T##[Any]!#>, pictureCount: <#T##Int32#>, currentIndex: <#T##Int32#>)
        
        
//        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in self.tableView.visibleCells {
            if let cell = cell as? PSVisualCell {
                cell.reload(with: scrollView, totalView: self.view)
            }
        }
    }
    
}
