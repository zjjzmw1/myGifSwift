//
//  HomeVC.swift
//  myGifSwift
//
//  Created by zhangmingwei on 2017/8/23.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class HomeVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView: UITableView!
    var dataArr: NSMutableArray!
    
    var refreshControl:ZJRefreshControl!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true; // 隐藏导航栏
        self.initTableViewAndData()
        self.requestAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initTableViewAndData() {
        dataArr = NSMutableArray()
        tableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 0 - TABBAR_HEIGHT), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(PSVisualCell.classForCoder(), forCellReuseIdentifier: "PSVisualCell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.1))
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.1))
        tableView.sectionFooterHeight = 0.1
        tableView.backgroundColor = UIColor.getBackgroundColorSwift()
        
        // 下拉刷新
//        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
//        loadingView.tintColor = UIColor.white
//        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
//            self?.requestAction()
//            }, loadingView: loadingView)
//        tableView.dg_setPullToRefreshFillColor(UIColor.getMainColorSwift())
//        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        // 上提刷新
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
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PSVisualCell", for: indexPath) as! PSVisualCell
        
        let myGifM = self.dataArr.object(at: indexPath.row) as? MyGifModel
        if let urlStr = myGifM?.dataDic?.image?.url {
            cell.reloadBackgroundImageUrl(urlStr, description: "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in self.tableView.visibleCells {
            if let cell = cell as? PSVisualCell {
                cell.reload(with: scrollView, totalView: self.view)
            }
        }
    }
    
    func requestAction() {
        let bquery = BmobQuery.init(className: "MyGif")
        bquery?.findObjectsInBackground({ [weak self] (resultArr, error) in
            self?.tableView.dg_stopLoading()
            self?.refreshControl.endRefreshing()
            if let resultArr = resultArr {
                self?.dataArr = NSMutableArray.init()
                for i in 0 ..< resultArr.count {
                    let mygifM = MyGifModel.deserialize(from: (resultArr[i] as! BmobObject).modelToJSONString())
                    self?.dataArr.add(mygifM ?? MyGifModel.init())
                }
            }
            self?.refreshAction()
        })
    }
    
    func requestMoreAction() {
        let bquery = BmobQuery.init(className: "MyGif")
        bquery?.findObjectsInBackground({ [weak self] (resultArr, error) in
            self?.tableView.dg_stopLoading()
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
           let arr = Tool.getHandyModelArrayFromFile(fileName: "MyGif") // 获取动图列表
            if let arr = arr, arr.count > 0 {
                self.dataArr = NSMutableArray.init(array: arr)
            }
        }
        self.tableView.reloadData()
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
}
