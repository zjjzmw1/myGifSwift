//
//  Tool.swift
//  niaoyutong
//
//  Created by zhangmingwei on 2017/5/27.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import HandyJSON
import MediaPlayer
import MapKit

/// 网络返回的成功码
let kSuccessCode = 200
/// 当前语言是中文
let kLanguage_is_chinese = NSLocale.preferredLanguages[0].hasPrefix("zh")

// Locale String [Upper Case]
// 英文-香港    EN_HK
// 中文-香港    ZH_HK
// 英文-中国    EN_CN
// 英文-台湾    EN_TW
// 英文-澳门    EN_MO
let kLocal_string_upper_case = NSLocale.current.identifier.uppercased()

//
// 该宏用户判断是否处于国际化模式下，即非中文模式；
// 该宏的判断逻辑可以使用语言来判是否需要进行国际化，包括单位转换等；
// 在非中国的海外地区 - 在内地的话才用高德地图
let kArea_out_China_neidi = (!kLocal_string_upper_case.hasSuffix("CN") || kLocal_string_upper_case.hasSuffix("HK") || kLocal_string_upper_case.hasSuffix("TW") || kLocal_string_upper_case.hasSuffix("MO"))

//
// 该宏用户判断是否处于国际化模式下，即非中文模式；
// 该宏的判断逻辑可以使用语言来判是否需要进行国际化，包括单位转换等；
// 在非中国的海外地区
//
//let kArea_Out_China \
//(!([LOCALE_STRING_UPPER_CASE hasSuffix:@"CN"] ||    \
//[LOCALE_STRING_UPPER_CASE hasSuffix:@"HK"] ||   \
//[LOCALE_STRING_UPPER_CASE hasSuffix:@"TW"] ||   \
//[LOCALE_STRING_UPPER_CASE hasSuffix:@"MO"]))

//非中国大陆或者香港的话是用苹果地图。。。。
//#define kArea_Out_China_Neidi \
//(!([LOCALE_STRING_UPPER_CASE hasSuffix:@"CN"] ||    \
//[LOCALE_STRING_UPPER_CASE hasSuffix:@"HK"]))

//MARK:公共方法
/// 自定义Log
///
/// - Parameters:
///   - messsage: 正常输出内容
///   - file: 文件名
///   - funcName: 方法名
///   - lineNum: 行数
func SLog<T>(_ messsage: T, time: NSDate = NSDate(), file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    //    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("\(time):\(fileName):(\(lineNum))======>>>>>>\n\(messsage)")
    //    #endif
}

/// MD5加密
///
/// - Parameter str: 需要加密的字符串
/// - Returns: 32位大写加密
func md5(_ str: String) -> String {
//    let cStr = str.cString(using: String.Encoding.utf8)
//    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
//    CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
//    let md5String = NSMutableString()
//    for i in 0 ..< 16 {
//        md5String.appendFormat("%02x", buffer[i])
//    }
//    free(buffer)
//    return md5String as String
    return ""
}

public class Tool: NSObject,UIActionSheetDelegate {
    
    static let shared = Tool()
    
    var goalLocation: CLLocation? // 目标点
    var goalName: String? // 目的地名字
    
    /**
     封装的UILabel 初始化
     
     - parameter frame:      大小位置
     - parameter textString: 文字
     - parameter font:       字体
     - parameter textColor:  字体颜色
     
     - returns: UILabel
     */
    public class func initALabel(frame:CGRect,textString:String,font:UIFont,textColor:UIColor) -> UILabel {
        let aLabel = UILabel()
        aLabel.frame = frame
        aLabel.backgroundColor = UIColor.clear
        aLabel.text = textString
        aLabel.font = font
        aLabel.textColor = textColor
        //        aLabel.sizeToFit()
        
        return aLabel
    }
    
    public class func initAImageV(frame:CGRect) -> UIImageView {
        let aImageV = UIImageView(frame: frame)
        aImageV.contentMode = .scaleAspectFill
        aImageV.layer.masksToBounds = true
        return aImageV
    }
    
    public class func initATextField(frame:CGRect,textString:String,font:UIFont,textColor:UIColor) -> UITextField {
        let textF = UITextField()
        textF.frame = frame
        textF.backgroundColor = UIColor.clear
        textF.textColor = textColor
        textF.font = font
        return textF
    }
    
    /**
     封装的UIButton 初始化
     
     - parameter frame:       位置大小
     - parameter titleString: 按钮标题
     - parameter font:        字体
     - parameter textColor:   标题颜色
     - parameter bgImage:     按钮背景图片
     
     - returns: UIButton
     */
    public class func initAButton(frame:CGRect ,titleString:String, font:UIFont, textColor:UIColor, bgImage:UIImage?) -> UIButton {
        let aButton = UIButton()
        aButton.frame = frame
        aButton.backgroundColor = UIColor.clear
        aButton .setTitle(titleString, for: UIControlState.normal)
        aButton .setTitleColor(textColor, for: UIControlState.normal)
        aButton.titleLabel?.font = font
        if bgImage != nil { // bgImage 必须是可选类型，否则警告
            aButton .setBackgroundImage(bgImage, for: UIControlState.normal)
        }
        
        return aButton
    }
    
    /// 获取图片和title左右布局的按钮
    public class func initAButtonTitleImage(image:UIImage? ,title:String?, font:UIFont?, textColor:UIColor?, spacing: CGFloat, alignmentType: ButtonImageTitleType) -> UIButton {
        let aButton = UIButton()
        aButton.backgroundColor = UIColor.clear
        if let title = title {
            aButton .setTitle(title, for: UIControlState.normal)
        }
        if let textColor = textColor {
            aButton .setTitleColor(textColor, for: UIControlState.normal)
        }
        if let font = font {
            aButton.titleLabel?.font = font
        }
        aButton.titleLabel?.backgroundColor = aButton.backgroundColor
        aButton.imageView?.backgroundColor = aButton.backgroundColor
        aButton.titleLabel?.font = font
        
        if let image = image {
            aButton.setImage(image, for: .normal)
            let imageWidth:CGFloat = image.size.width
            var titleWidth:CGFloat = 0.0
            if let font = font {
                titleWidth = (aButton.currentTitle?.sizeFor(size: CGSize.init(width: SCREEN_WIDTH, height: 20), font: font).width)!
            }
            if alignmentType == imageLeft_wholeCenter { // 图片左，整体居中
                aButton.contentHorizontalAlignment = .center
                aButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: CGFloat(-spacing/2.0), bottom: 0, right: 0)
                aButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: CGFloat(spacing), bottom: 0, right: 0)
            } else if alignmentType == imageLeft_wholeLeft { // 图片左，整体居左边
                aButton.contentHorizontalAlignment = .left
                aButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
                aButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: CGFloat(spacing), bottom: 0, right: 0)
            } else if alignmentType == imageleft_wholeRight { // 图片左，整体居右
                aButton.contentHorizontalAlignment = .right
                aButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: CGFloat(spacing))
                aButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            } else if alignmentType == imageRight_wholeCenter { // 图片you，整体居中
                aButton.contentHorizontalAlignment = .center
                aButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: CGFloat(titleWidth + spacing), bottom: 0, right: -(titleWidth + spacing))
                aButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: CGFloat(-(imageWidth + spacing)), bottom: 0, right: imageWidth + spacing)
            } else if alignmentType == imageRight_wholeLeft { // 图片you，整体居zuo
                aButton.contentHorizontalAlignment = .left
                aButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: titleWidth + spacing, bottom: 0, right: -(titleWidth + spacing))
                aButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(imageWidth + spacing), bottom: 0, right: imageWidth + spacing)
            } else if alignmentType == imageRight_wholeRight { // 图片you，整体居中
                aButton.contentHorizontalAlignment = .right
                aButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: titleWidth + spacing, bottom: 0, right: -(titleWidth + spacing))
                aButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(imageWidth + spacing), bottom: 0, right: imageWidth + spacing)
            }
        }
        
        return aButton
    }
    
    /// 保存NSArray 数据到本地文件
    public class func saveArrayToFile(resultArray: NSArray! , fileName: String!) {
        let jsonString : NSString = self.toJSONString(arr: resultArray)!
        let jsonData :Data? = jsonString.data(using: UInt(String.Encoding.utf8.hashValue))
        
        let file = fileName
        let fileUrl = URL(fileURLWithPath: kPathTemp).appendingPathComponent(file!)
        print("fileUrl = \(fileUrl)")
        let data = NSMutableData()
        data.setData(jsonData!)
        if data.write(toFile: fileUrl.path, atomically: true) {
            print("保存成功：\(fileUrl.path)")
        } else {
            print("保存失败：\(fileUrl.path)")
        }
    }
    
    /// 转换数组到JSONStirng
    public class func toJSONString(arr: NSArray!) -> NSString? {
        guard let data = try? JSONSerialization.data(withJSONObject: arr, options: .prettyPrinted),
            // Notice the extra question mark here!
            let strJson = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                //throws MyError.InvalidJSON
                return nil
        }
        return strJson
    }
    
    /// 从本地获取json数据
    public class func getJsonFromFile(fileName: String) -> Any? {
        let file = fileName
        let fileUrl = URL(fileURLWithPath: kPathTemp).appendingPathComponent(file)
        if let readData = NSData.init(contentsOfFile: fileUrl.path) {
            let jsonValue = try? JSONSerialization.jsonObject(with: readData as Data, options: .allowFragments)
            print("获取成功：\(fileUrl.path)")
            return jsonValue
        } else {
            print("获取失败：\(fileUrl.path)")
            return nil
        }
    }
    
    // MARK: 网络相关的类方法
    public class func getCode(result: JSON?) -> Int? {
        let code = result?["code"].int
        return code
    }
    public class func getMessage(result: JSON?) -> String? {
        let message = result?["message"].string
        return message
    }
    
    /// MARK: - 判断一个方法调用频繁的方法 - 两个方法交替调用不会被打断
    public class func isCallFrequent(funcName: String) -> Bool {
        struct Frequent {
            static var isFrequentFlag: Bool = false // 默认没有频繁调用
            static var lastFuncName : String = "defaultFuncName" // 默认的方法名字
        }
        if Frequent.lastFuncName != funcName { // 和上次的方法名字不一样就认为是不同的方法
            Frequent.isFrequentFlag = false
            Frequent.lastFuncName = funcName
        }
        if Frequent.isFrequentFlag { // 频繁调用了
            print("频繁被调用了--还没超过0.5秒")
            return true
        } else {  // 没有频繁调用
            /// 延迟0.5秒后执行
            Frequent.isFrequentFlag = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                Frequent.isFrequentFlag = false
            }
            return false
        }
    }
    
    /// 类文件字符串转换为ViewController
    ///
    /// - Parameter childControllerName: VC的字符串
    /// - Returns: ViewController
    public class func vcString_to_ViewController(_ childControllerName: String) -> UIViewController?{
        
        // 1.获取命名空间
        // 通过字典的键来取值,如果键名不存在,那么取出来的值有可能就为没值.所以通过字典取出的值的类型为AnyObject?
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            print("命名空间不存在")
            return nil
        }
        // 2.通过命名空间和类名转换成类
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + childControllerName)
        
        // swift 中通过Class创建一个对象,必须告诉系统Class的类型
        guard let clsType = cls as? UIViewController.Type else {
            print("无法转换成UIViewController")
            return nil
        }
        // 3.通过Class创建对象
        let childController = clsType.init()
        
        return childController
    }
    
    /// 获取地图显示区域
//    class func getMapRegion(annotations: [Station]) -> MKCoordinateRegion? {
//        if annotations.count == 0 {
//            return nil
//        }
//        var coordinate = CLLocationCoordinate2DMake(0, 0)
//        coordinate = annotations[0].coordinate
//        var max_lat = coordinate.latitude
//        var min_lat = coordinate.latitude
//        var max_lon = coordinate.longitude
//        var min_lon = coordinate.longitude
//
//        for coor in annotations {
//            if coor.latitude > max_lat {
//                max_lat = coor.latitude
//            }
//            if coor.latitude < min_lat {
//                min_lat = coor.latitude
//            }
//            if coor.longitude > max_lon {
//                max_lon = coor.longitude
//            }
//            if coor.longitude < min_lon {
//                min_lon = coor.longitude
//            }
//        }
//        let center = CLLocationCoordinate2DMake((max_lat + min_lat)/2.0, (max_lon + min_lon)/2.0)
//        let span = MKCoordinateSpanMake((max_lat - min_lat) * 1.5, (max_lon - min_lon) * 1.5) // 加 2是避免太靠边了
////        SLog("center===\(center),,,span===\(span)")
//        return MKCoordinateRegionMake(center, span)
//    }
    
    
    // MARK: swift 保存Handy model为json到本地    !!!!!!!!
    @discardableResult // 返回值可以不用
    public class func saveHandyModelToJSON(model: HandyJSON, fileName: String!) -> Bool {
        let modelJson = model.toJSON()
        if modelJson == nil {
            return false
        }
        let jsonData : NSData = NSKeyedArchiver.archivedData(withRootObject: modelJson!) as NSData
        
        let file = fileName
        let fileUrl = URL(fileURLWithPath: kPathTemp).appendingPathComponent(file!)
        print("fileUrl = \(fileUrl)")
        let data = NSMutableData()
        data.setData(jsonData as Data)
        if data.write(toFile: fileUrl.path, atomically: true) {
            print("保存成功：\(fileUrl.path)")
            return true
        } else {
            print("保存失败：\(fileUrl.path)")
            return false
        }
    }
    // MARK:  从本地获取json获取Handy model     !!!!!!!!  TripManager.deserialize(from: Tool.getHandyModelFromFile(fileName: "TripManager"))! // 获取model的方法
    public class func getHandyModelFromFile(fileName: String) -> NSDictionary? {
        let file = fileName
        let fileUrl = URL(fileURLWithPath: kPathTemp).appendingPathComponent(file)
        if let readData = NSData.init(contentsOfFile: fileUrl.path) {
            let jsonValue = NSKeyedUnarchiver.unarchiveObject(with: readData as Data)
            print("获取成功：\(fileUrl.path)")
            return jsonValue as? NSDictionary
        } else {
            print("获取失败：\(fileUrl.path)")
            return nil
        }
    }
    // MARK: swift 保存Handy modelArray为json到本地    !!!!!!!! 假设最多存储50条数据
    @discardableResult // 返回值可以不用
    public class func saveHandyModelArrayToJSON(modelArray: NSArray, fileName: String!) -> Bool {
        for i in 0..<50 {
            if i < modelArray.count {
                Tool.saveHandyModelToJSON(model: modelArray[i] as! HandyJSON, fileName: String.init(format: "%@_%d",fileName,i))
            } else {
                Tool.removeHandyModelToJSON(fileName: String.init(format: "%@_%d",fileName,i))
            }
        }
        return true
    }
    // MARK:  从本地获取json获取Handy model     !!!!!!!!   // 获取model的方法 假设最多存储50条数据
    public class func getHandyModelArrayFromFile(fileName: String) -> NSArray? {
    
        let resultArr = NSMutableArray()
        for i in 0..<50 {
            let dict = Tool.getHandyModelFromFile(fileName: String.init(format: "%@_%d",fileName,i))
            if (dict != nil) {
                resultArr.add(dict!)
            } else {
                return resultArr
            }
        }
        return nil
    }
    
    // MARK: swift 保存Handy model为json到本地    !!!!!!!!
    public class func removeHandyModelToJSON(fileName: String!) {
        let file = fileName
        let fileUrl = URL(fileURLWithPath: kPathTemp).appendingPathComponent(file!)
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            try! FileManager.default.removeItem(at: fileUrl)
        }
    }
    
    // MARK: 从jsonString里面获取字典
    public class func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    // MARK: 从 0 -- 6 转成 星期
    public class func toWeekStr(weekDay: Int) -> String {
        switch weekDay {
        case 1:
            return "SUN"
        case 2:
            return "MON"
        case 3:
            return "TUE"
        case 4:
            return "WED"
        case 5:
            return "THU"
        case 6:
            return "FRI"
        case 7:
            return "SAT"
        default:
            return "SUN"
        }
    }
    
    /// MARK: 去除电话的+ 、- 
    public class func getPhoneNumber(str: String?) -> String {
        var lastStr = str ?? ""
        if str == nil {
            return lastStr
        }
        lastStr = lastStr.replacingOccurrences(of: "+", with: "")
        lastStr = lastStr.replacingOccurrences(of: "-", with: "")
        lastStr = String.init(format: "tel:%@",lastStr)
        return lastStr
    }
    
    /// MARK: 调用地图BEGIN
    
    /// 路线查询方法 - 弹出好多地图供用户导航
    public class func showMapViewActionSheet() {
        Tooles.event("road_search")
        let actionSheet = UIActionSheet(title: NSLocalizedString("选择地图", comment: ""), delegate: Tool.shared, cancelButtonTitle: NSLocalizedString("取消", comment: ""), destructiveButtonTitle: nil, otherButtonTitles: NSLocalizedString("谷歌地图", comment: ""),NSLocalizedString("苹果地图", comment: ""), NSLocalizedString("高德地图", comment: ""),NSLocalizedString("百度地图", comment: ""))
        actionSheet.actionSheetStyle = .default
        actionSheet.show(in: ((UIApplication.shared.delegate?.window)!)!)
        
    }
    
    public func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 { // 谷歌地图
            self.goGoogleMap()
        } else if (buttonIndex == 2) { // 苹果地图
            /*
             MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
             MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:wSelf.bicycleShop.bicycleCoordinate addressDictionary:nil]];
             [MKMapItem openMapsWithItems:@[currentLocation, toLocation] launchOptions:@{ MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
             */
            let currentLoc = MKMapItem.forCurrentLocation()
            if #available(iOS 9.0, *) {
                if Tool.shared.goalLocation != nil {
                    let mapItem = MKMapItem.init(placemark: MKPlacemark.init(coordinate: (goalLocation?.coordinate)!, addressDictionary: nil))
                    MKMapItem.openMaps(with: [currentLoc,mapItem], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit])
                } else {
                    MKMapItem.openMaps(with: [currentLoc,currentLoc], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit])
                }
            } else {
                if Tool.shared.goalLocation != nil {
                    let mapItem = MKMapItem.init(placemark: MKPlacemark.init(coordinate: (goalLocation?.coordinate)!, addressDictionary: nil))
                    MKMapItem.openMaps(with: [currentLoc,mapItem], launchOptions: [:])
                } else {
                    MKMapItem.openMaps(with: [currentLoc], launchOptions: [:])
                }
            }
        } else if (buttonIndex == 3) { // 高德地图
            /* - 高德带经纬度
             NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2", NSLocalizedString(@"kAll_speedx",nil), @"speedx", wSelf.bicycleShop.bicycleCoordinate.latitude, wSelf.bicycleShop.bicycleCoordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
             */
            var gaodeUrlStr = String.init(format: "iosamap://navi?sourceApplication=%@&backScheme=%@&dev=0&style=2",NSLocalizedString("鸟语通", comment: ""),"com.wj.niaoyutong")
            if let goalLoc = Tool.shared.goalLocation {
                gaodeUrlStr = String.init(format: "iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",NSLocalizedString("鸟语通", comment: ""),"com.wj.niaoyutong",goalLoc.coordinate.latitude,goalLoc.coordinate.longitude)
            }
            if let url = URL.init(string: gaodeUrlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            } else {
                let urlString: String! = String.init(format: "https://m.amap.com/navigation/index/");
                let urlStr: String! = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) // 中文的时候才需要urlQueryAllowed
                let url = URL.init(string: urlStr)
                if let url = url {
                    UIApplication.shared.openURL(url)
                }
            }
            
        } else if (buttonIndex == 4) { // 百度地图
            /* - 带经纬度的情况
             NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02", wSelf.bicycleShop.bicycleCoordinate.latitude, wSelf.bicycleShop.bicycleCoordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
             */
            var baiduUrlStr = String.init(format: "baidumap://map/direction?origin={{我的位置}}")
            if let goalLoc = Tool.shared.goalLocation {
                baiduUrlStr = String.init(format: "baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f",goalLoc.coordinate.latitude,goalLoc.coordinate.longitude)
            }
            if let url = URL.init(string: baiduUrlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            } else {
                let urlString: String! = String.init(format: "http://map.baidu.com/mobile/webapp/index/index/tab=line");
                let urlStr: String! = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) // 中文的时候才需要urlQueryAllowed
                let url = URL.init(string: urlStr)
                if let url = url {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    // MARK: 没有谷歌地图的用户之间调整到浏览器
    func noGoogleApp() {
        let urlString: String! = String.init(format: "https://www.google.com/maps/dir///data=!4m2!4m1!3e3");
        let urlStr: String! = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) // 中文的时候才需要urlQueryAllowed
        let url = URL.init(string: urlStr)
        if let url = url {
            UIApplication.shared.openURL(url)
        }
    }
    // MARK: 有谷歌地图的
    func goGoogleMap() {
        let urlString: String! = String.init(format: "comgooglemaps://?x-source=%@&x-success=&saddr=&addr=&directionsmode=transit", APP_NAME,"www.wj.niaoyutong");
        let urlStr: String! = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) // 中文的时候才需要urlQueryAllowed
        let googleMapUrl = URL.init(string: urlStr)
        
        if UIApplication.shared.canOpenURL(googleMapUrl!) {
            UIApplication.shared.openURL(googleMapUrl!)
        } else { // 没有谷歌地图
            self.noGoogleApp()
            /*
             let alertV = UIAlertView.showWith(title: NSLocalizedString("您还没安装谷歌地图", comment: ""), message: "", style: .default, cancelButtonTitle:  NSLocalizedString("用浏览器打开", comment: ""), otherButtonTitles: [NSLocalizedString("去安装", comment: "")], tapBlock: { (alertV, buttonIndex) in
             })
             
             alertV.rac_buttonClickedSignal().subscribeNext({ (buttonIndex) in
             if let buttonIndex = buttonIndex {
             let index = (buttonIndex as? Int) ?? 0
             if  index == 0 {
             self.noGoogleApp()
             } else {
             // 去下载谷歌地图
             UIApplication.shared.openURL(URL.init(string: "itms-apps://itunes.apple.com/cn/app/google-maps/id585027354?mt=8")!)
             }
             }
             })
             */
        }
    }
    
    /// MARK: 调用地图END
    
    /// 改变系统声音为 80%
    public class func changeVolumeToMax() {
        let volumeBig = MPVolumeView()
        var slider: UISlider?
        for view: UIView in volumeBig.subviews {
//            SLog(view.self.description)
//            SLog(view.className())
            if view.className() == "MPVolumeSlider" {
                slider = view as? UISlider
                break
            }
        }
        let systemVolume = slider?.value ?? 0.6
        if systemVolume < 0.8 {
            slider?.setValue(0.8, animated: false)
            slider?.sendActions(for: .touchUpInside)
        }
    }
    
    
    
}
