//
//  MyGifModel.swift
//  myGifSwift
//
//  Created by zhangmingwei on 2017/8/24.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

import UIKit
import HandyJSON

class MyGifModel: HandyJSON {
    
    var dataDic: DataModel?
    
    required init() {
        
    }
    
}

class DataModel: HandyJSON {
    var objectId: String = ""
    var createdAt: String?
    var updatedAt: String?
    var image: ImageModel?
    var filetype: ImageModel? // 自己上传的图片
    
    required init() {
        
    }
}

class ImageModel: HandyJSON {
    
    var url: String = ""
    
    required init() {
        
    }
}

/*
 
 className = MyGif;
 objectId = Wrki7778;
 createdAt = 2017年8月23日 星期三 中国标准时间 上午11:54:57;
 updatedAt = 2017年8月23日 星期三 中国标准时间 上午11:54:57;
 data = {
 createdAt = "2017-08-23 11:54:57";
 image =     {
 "__type" = File;
 cdn = upyun;
 filename = "3.gif";
 url = "http://bmob-cdn-13644.b0.upaiyun.com/2017/08/23/8d69b68040d57a528029151b37a6f967.gif";
 };
 objectId = Wrki7778;
 updatedAt = "2017-08-23 11:54:57";
 };
 
 */
