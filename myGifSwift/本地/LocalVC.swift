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

class LocalVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,PHPhotoLibraryChangeObserver,KSPhotoBrowserDelegate {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.needReloadFlag = true
    }
    
    var tableView: UITableView!
    var dataArr: NSMutableArray!
    var items: NSMutableArray!
    var needReloadFlag: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self as PHPhotoLibraryChangeObserver)
        self.fd_prefersNavigationBarHidden = true; // 隐藏导航栏
        self.initTableViewAndData()
        
        // 接收通知：
        _ = NotificationCenter.default.rx.notification(Notification.Name("kUploadUserImageNoti")).takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] (value) in

            SLog(value.object)
            if let dict = value.object as? Dictionary<String, AnyObject> {
                SLog("===\(dict["page"]),,,,\(dict["vc"])")
                self?.userUploadImageAction(fromVC: dict["vc"] as! UIViewController, currentP: Int(dict["page"] as! NSNumber))

            }
            

        })
        

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
        ProgressHUD.show(with: nil, title: "")
        
        DispatchQueue.global().async {
            // PH方式
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
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.items = NSMutableArray()
                /// 初始化 KSPhotoItem
                for j in 0 ..< self.dataArr.count {
                    if self.tableView.visibleCells.count == 0 {
                        break
                    }
                    let cell = self.tableView.visibleCells[0] as! PSVisualCell
                    let tempPH = self.dataArr[j] as! PHAsset
                    let item = KSPhotoItem.init(sourceView: cell.backgroundImageView, thumbImage: cell.backgroundImageView.image ?? #imageLiteral(resourceName: "icon_1024"), imagePHasset: tempPH)
                    self.items.add(item)
                }
                self.tableView.reloadData()
                ProgressHUD.dismissDelay(0)
            }
        }
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
        // 这个清楚，但是卡
//        PHCachingImageManager.default().requestImageData(for: phAsset, options: option) { (data, str, orientation, dictInfo) in
//            if let imageD = data {
//                cell.reloadBackgroundImage(UIImage.init(data: imageD), description: "")
//            }
//        }
        // 这个不清楚，但是不卡
        PHCachingImageManager.default().requestImage(for: phAsset, targetSize: .zero, contentMode: .aspectFit, options: option) { (image, dictInfo) in
            cell.reloadBackgroundImage(image, description: "")
        }
        
        return cell
    }
    
    /// 用户上传图片的方法
    func userUploadImageAction(fromVC: UIViewController, currentP: Int) {
        let alertC = UIAlertController.initAlertC(title: "上传图片", msg: nil, style: .actionSheet)
        let collectionStr = "上传"
        alertC.addMyAction(title: collectionStr, style: .default) { (alertA) in
            // 上传的方法
            // 先上传文件
            ProgressHUD.show(with: nil, title: "上传中...")
            ProgressHUD.defaultManager().hud.mode = .annularDeterminate
            ProgressHUD.defaultManager().hud.tintColor = UIColor.white
            let phAsset = self.dataArr[currentP] as! PHAsset
            let option = PHImageRequestOptions.init()
            option.isSynchronous = true
            option.version = .original
            option.deliveryMode = .highQualityFormat
            
            PHCachingImageManager.default().requestImageData(for: phAsset, options: option) { (data, str, orientation, dictInfo) in
                if let imageD = data {
                
                    let bmobFile: BmobFile = BmobFile.init(fileName: "userUploadGif.gif", withFileData: imageD)
                    bmobFile.save(inBackground: { (isSuccessed, error) in
                        if isSuccessed {
                            ProgressHUD.showSuccess("上传成功")
                            let myGif = BmobObject.init(className: "MyGif")
                            myGif?.setObject(bmobFile, forKey: "userImage") // 对应的列表的名字。。。。
                            myGif?.saveInBackground(resultBlock: { (isSuccess, error) in
                                
                            })
                        } else {
                            ProgressHUD.showError("上传失败")
                        }
                    }, withProgressBlock: { (progressFloat) in
                        ProgressHUD.defaultManager().hud.progress = Float.init(progressFloat)
                    })
                } else {
                    ProgressHUD.showError("上传失败")
                }
            }

            ProgressHUD.defaultManager().hud.isUserInteractionEnabled = false
        }
        alertC.addMyAction(title: "取消", style: .cancel)
        let vc = fromVC
        alertC.showAlertC(vc: vc, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let cell = tableView.cellForRow(at: indexPath) as! PSVisualCell
        let tempPH = self.dataArr[indexPath.row] as! PHAsset
        let item = KSPhotoItem.init(sourceView: cell.backgroundImageView, thumbImage: cell.backgroundImageView.image ?? #imageLiteral(resourceName: "icon_1024"), imagePHasset: tempPH)
        self.items.replaceObject(at: indexPath.row, with: item)
        /// 弹出图片浏览器
        let browser = KSPhotoBrowser.init(photoItems: self.items as! [KSPhotoItem], selectedIndex: UInt(indexPath.row))
        browser.delegate = self
        browser.dismissalStyle = .rotation
        browser.backgroundStyle = .blurPhoto
        browser.loadingStyle = .determinate
        browser.pageindicatorStyle = .text
        browser.bounces = true
        browser.show(from: self)
    }
    
    func ks_photoBrowser(_ browser: KSPhotoBrowser, didSelect item: KSPhotoItem, at index: UInt) {
       SLog(index)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in self.tableView.visibleCells {
            if let cell = cell as? PSVisualCell {
                cell.reload(with: scrollView, totalView: self.view)
            }
        }
    }
    
}


