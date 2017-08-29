//
//  LocalVC.swift
//  myGifSwift
//
//  Created by zhangmingwei on 2017/8/22.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

import UIKit
import Photos

import XLPhotoBrowser_CoderXL

import AssetsLibrary

class LocalVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.needReloadFlag = true
        DispatchQueue.main.async {
            self.getLocalImagesAction()
        }
    }
    
    var tableView: UITableView!
    var dataArr: NSMutableArray!
    var needReloadFlag: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true; // 隐藏导航栏
        self.initTableViewAndData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 获取收藏的数组的url
        self.getLocalImagesAction()
    }
    
    
    /// 获取本地相册所有照片方法
    func getLocalImagesAction() {
        if !needReloadFlag {
            self.tableView.reloadData()
            return
        }
        self.needReloadFlag = false
        ProgressHUD.show(with: self.view, title: "")
        // PH方式
        PHPhotoLibrary.shared().register(self as PHPhotoLibraryChangeObserver)
        let allOptions = PHFetchOptions()
        let allResults = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: allOptions)
        if allResults.count > 0 {
            let tempArr = NSMutableArray()
            self.dataArr = NSMutableArray()
            for i in 0 ..< allResults.count {
                let ph = allResults[i]
                let reources = PHAssetResource.assetResources(for: ph)
                let fileName = reources[0].originalFilename
                if fileName.hasSuffix("GIF") {
                    tempArr.add(allResults[i])
                }
            }
            self.dataArr = NSMutableArray.init(array: tempArr)
        }
        self.tableView.reloadData()
        ProgressHUD.dismissDelay(0)
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
        
        let option = PHImageRequestOptions.init()
        option.isSynchronous = true
        option.version = .original
        
        PHCachingImageManager.default().requestImageData(for: phAsset, options: option) { (data, str, orientation, dictInfo) in
            if let imageD = data {
                cell.reloadBackgroundImage(UIImage.init(data: imageD), description: "")
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let photoB =  XLPhotoBrowser.show(withImages: self.dataArr as! [Any]!, currentImageIndex: indexPath.row)
        photoB?.browserStyle = .indexLabel
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in self.tableView.visibleCells {
            if let cell = cell as? PSVisualCell {
                cell.reload(with: scrollView, totalView: self.view)
            }
        }
    }
    
}
