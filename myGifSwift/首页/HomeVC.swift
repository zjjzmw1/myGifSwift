//
//  HomeVC.swift
//  myGifSwift
//
//  Created by zhangmingwei on 2017/8/23.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView: UITableView!
    var dataArr: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTitle(titleString: NSLocalizedString("我的行程", comment: ""))
        self.initTableViewAndData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestAction()
    }
    
    func initTableViewAndData() {
        dataArr = NSMutableArray()
        tableView = UITableView(frame: CGRect.init(x: 0, y: NAVIGATIONBAR_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(PSVisualCell.classForCoder(), forCellReuseIdentifier: "PSVisualCell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.1))
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.1))
        tableView.sectionFooterHeight = 0.1
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
            if let resultArr = resultArr {
                self?.dataArr = NSMutableArray.init()
                for i in 0 ..< resultArr.count {
                    let mygifM = MyGifModel.deserialize(from: (resultArr[i] as! BmobObject).modelToJSONString())
                    self?.dataArr.add(mygifM ?? MyGifModel.init())
                }
            }
            self?.tableView.reloadData()
        })
    }

}
