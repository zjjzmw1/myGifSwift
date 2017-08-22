//
//  JHNetwork.swift
//  mysuper
//
//  Created by zhangmingwei on 2017/8/15.
//  Copyright © 2017年 niaoyutong. All rights reserved.
//

//
//  JHNetwork.swift
//  JHNetwork
//
//  Created by Jonhory on 2017/2/21.
//  Copyright © 2017年 com.wujh. All rights reserved.
//  

import UIKit
import Alamofire
import SwiftyJSON

/// MARK:
enum RequestType:Int {
    case GET
    case POST
    case PUT
    case DELETE
}

class JHNetwork {
    /// MARK:单例
    static let shared = JHNetwork()
    private init() {}
    /// 普通网络回调
    typealias networkResponse = (_ result:Any?,_ error:NSError?) -> ()
    /// JSON数据回调
    typealias networkJSON = (_ result:JSON?,_ error:NSError?) -> ()
    /// 网络状态监听回调
    typealias networkListen = (_ status:NetworkReachabilityManager.NetworkReachabilityStatus) -> Void
    
    /// 网络基础url
    var baseUrl:String? = kSBase_url
    /// 请求超时
    var timeout = 20
    /// 配置公共请求头
    var httpHeader:HTTPHeaders? = nil
    /// 是否自动ecode
    var encodeAble = false
    /// 设置是否打印log信息
    var isDebug = true
    /// 网络异常时，是否从本地提取数据
    var shoulObtainLocalWhenUnconnected = true
    /// 当前网络状态，默认WIFI，开启网络状态监听后有效
    var networkStatus = NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.ethernetOrWiFi)
    
    var manager:SessionManager!
    let listen = NetworkReachabilityManager()
    
    var needJsonBody: Bool  = false // 是否需要json的请求格式
    
    /// 当检测到网络异常时,是否从本地提取数据,如果是，则发起网络状态监听
    ///
    /// - Parameter shouldObtain: 是否从本地提取数据
    func shoulObtainLocalWhenUnconnected(shouldObtain:Bool) {
        shoulObtainLocalWhenUnconnected = shouldObtain
        if shouldObtain {
            listenNetworkReachabilityStatus {_ in }
        }
    }
}

// MARK: - 公共工具 - 监听网络请求状态
extension JHNetwork {
    /// 监听网络状态
    ///
    /// - Parameter networkListen: 网络状态回调
    func listenNetworkReachabilityStatus(networkListen:@escaping networkListen) {
        listen?.startListening()
        listen?.listener = { status in
            self.networkStatus = status
            if self.isDebug {
                SLog("*** <<<Network Status Changed>>> ***:\(status)")
            }
            networkListen(status)
        }
        if listen?.isReachable == false {
            networkStatus = .notReachable
            networkListen(networkStatus)
        }
    }
}

// MARK: - 网络请求相关
extension JHNetwork {
    /// MARK:缓存GET
    func getForJSON(url: String, refreshCache: Bool = true, parameters: [String :Any]? = nil, finished: @escaping networkJSON) -> Cancellable? {
        baseUrl = kSBase_url
        needJsonBody = false
        return requestJSON(methodType: .GET, urlStr: url, refreshCache: refreshCache, isCache: true, parameters: parameters, finished: finished)
    }
    //MARK:缓存POST
    func postForJSON(url: String, refreshCache: Bool = true, parameters: [String :Any]? = nil, finished: @escaping networkJSON) -> Cancellable? {
        baseUrl = kSBase_url
        needJsonBody = false
        return requestJSON(methodType: .POST, urlStr: url, refreshCache: refreshCache, isCache: true, parameters: parameters, finished: finished)
    }
    /// 新版本需要更改base_url  ----- 所有新版本的API用下面两个方法
    /// MARK:缓存GET
    func getForJSONV2(url: String, refreshCache: Bool = true, parameters: [String :Any]? = nil, finished: @escaping networkJSON) -> Cancellable? {
        baseUrl = kSBase_url_v2
        needJsonBody = false
        return requestJSON(methodType: .GET, urlStr: url, refreshCache: refreshCache, isCache: true, parameters: parameters, finished: finished)
    }
    //MARK:缓存POST
    func postForJSONV2(url: String, refreshCache: Bool = true, parameters: [String :Any]? = nil, finished: @escaping networkJSON) -> Cancellable? {
        baseUrl = kSBase_url_v2
        needJsonBody = false
        return requestJSON(methodType: .POST, urlStr: url, refreshCache: refreshCache, isCache: true, parameters: parameters, finished: finished)
    }
    //MARK:缓存delete
    func deleteForJSONV2(url: String, refreshCache: Bool = true, parameters: [String :Any]? = nil, finished: @escaping networkJSON) -> Cancellable? {
        baseUrl = kSBase_url_v2
        needJsonBody = false
        return requestJSON(methodType: .DELETE, urlStr: url, refreshCache: refreshCache, isCache: true, parameters: parameters, finished: finished)
    }
    
    /// --------------需要json格式的
    //MARK:缓存POST
    func postForJSONV2NeedJsonBody(url: String, refreshCache: Bool = true, parameters: [String :Any]? = nil, finished: @escaping networkJSON) -> Cancellable? {
        baseUrl = kSBase_url_v2
        needJsonBody = true
        return requestJSON(methodType: .POST, urlStr: url, refreshCache: refreshCache, isCache: true, parameters: parameters, finished: finished)
    }
    //MARK:缓存PUT
    func putForJSONV2(url: String, refreshCache: Bool = true, parameters: [String :Any]? = nil, finished: @escaping networkJSON) -> Cancellable? {
        baseUrl = kSBase_url_v2
        needJsonBody = true
        return requestJSON(methodType: .PUT, urlStr: url, refreshCache: refreshCache, isCache: true, parameters: parameters, finished: finished)
    }
    
    //MARK:请求JSON数据最底层
    /// 请求JSON数据最底层
    ///
    /// - Parameters:
    ///   - methodType: GET/POST
    ///   - urlStr: 接口
    ///   - refreshCache: 是否刷新缓存,如果为false则返回缓存
    ///   - isCache: 是否缓存
    ///   - parameters: 参数字典
    ///   - finished: 回调
    func requestJSON(methodType: RequestType, urlStr: String, refreshCache: Bool, isCache:Bool, parameters: [String :Any]?, finished: @escaping networkJSON) -> Cancellable? {
        var absolute: String? = nil
        absolute = absoluteUrl(path: urlStr)
        if encodeAble {
            absolute = absolute?.urlEncode
            if isDebug {
                SLog("Encode URL ===>>>>\(String(describing: absolute))")
            }
        }
        
        let URL: NSURL? = NSURL(string: absolute!)
        if URL == nil {
            if isDebug {
                SLog("URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL, absolute = \(String(describing: absolute))")
            }
            return nil
        }
        //开始业务判断
        if isCache {
            if shoulObtainLocalWhenUnconnected {
                if networkStatus == NetworkReachabilityManager.NetworkReachabilityStatus.unknown || networkStatus == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable {
                    let js = getCacheResponse(url: urlStr, parameters: parameters)
                    if js != nil {
                        if isDebug {
                            SLog("🇨🇳因为无网络连接而读取缓存")
                        }
                        networkLogSuccess(json: js, url: urlStr, params: parameters)
                        finished(js, nil)
                        return nil
                    }
                }
            }
            //如果不刷新缓存，如果已存在缓存，则返回缓存，否则请求网络，但是不缓存数据
            if !refreshCache {
                let js = getCacheResponse(url: urlStr, parameters: parameters)
                if js != nil {
                    if isDebug {
                        SLog("🇨🇳因为不刷新缓存而读取缓存")
                    }
                    networkLogSuccess(json: js, url: urlStr, params: parameters)
                    finished(js, nil)
                    return nil
                }
            }
        }
        // - manager 统一初始化
        if manager == nil {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = TimeInterval(timeout) // seconds
            configuration.timeoutIntervalForResource = TimeInterval(timeout)
            
            manager = Alamofire.SessionManager(configuration: configuration)
        }
        
        //定义请求结果回调闭包
        let resultCallBack = { (response: DataResponse<Any>) in
            if response.result.isSuccess {
                let value = response.result.value as Any?
                let js = JSON(value as Any)
                // 如果刷新缓存并且缓存
                if refreshCache && isCache {
                    self.cacheResponse(response: js, url: urlStr, parameters: parameters)
                }
                self.networkLogSuccess(json: js, url: urlStr, params: parameters)
                finished(js, nil)
            } else {
                let error = response.result.error as NSError?
                if error != nil && error!.code < 0 && isCache {
                    let js = self.getCacheResponse(url: urlStr, parameters: parameters)
                    if js != nil {
                        if self.isDebug {
                            SLog("🇨🇳因为\(String(describing: error))而读取缓存")
                        }
                        self.networkLogSuccess(json: js, url: urlStr, params: parameters)
                        finished(js, nil)
                    } else {
                        self.networkLogFail(error: error, url: urlStr, params: parameters)
                        finished(nil, error)
                    }
                } else {
                    self.networkLogFail(error: error, url: urlStr, params: parameters)
                    finished(nil, error)
                }
            }
        }
        let param = appendDefaultParameter(params: parameters)
        //正式发起网络请求
        //        let httpMethod:HTTPMethod = methodType == .GET ? .get : .post
        var httpMethod:HTTPMethod = .get
        if methodType == .POST {
            httpMethod = .post
        } else if methodType == .GET {
            httpMethod = .get
        } else if methodType == .PUT {
            httpMethod = .put
        } else if methodType == .DELETE {
            httpMethod = .delete
        }
        var language = "zh"
        if kLanguage_is_chinese {
            language = "zh"
        } else if (NSLocale.preferredLanguages[0].hasPrefix("en")) {
            language = "en-US"
        } else {
            language = "jp"
        }
        let token: String = UserDefaults.standard.object(forKey: "token") as? String ?? ""
        httpHeader = ["Accept-Language": language, "authorization": token] // "Accept": "application/json"
        // testToken 我的账号: "170acdbb7a344a04d9c679be854a0b69"
        if needJsonBody {
            // 这是put的头是这样的
            httpHeader = ["authorization": token, "Content-Type": "application/json","Accept-Language": language]
            // json数据需要的请求
            return manager.request(absolute!, method: httpMethod, parameters: param, encoding: JSONEncoding.default, headers: httpHeader).responseJSON(completionHandler: { (response) in
                // 302的链接-----需要等到put结束之后才能调用get，否则获取不到
                return Alamofire.request(absolute!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: resultCallBack)
            })
            
        } else {
            return manager.request(absolute!, method: httpMethod, parameters: param, encoding: URLEncoding.default, headers: httpHeader).responseJSON(completionHandler: resultCallBack)
        }
    }
    
    //MARK: - 缓存相关
    /// 获取缓存
    private func getCacheForJSON(url: String, parameters: [String :Any]?, finished: @escaping networkJSON) -> Cancellable? {
        return getForJSON(url: url, refreshCache: false, parameters: parameters) { (js, error) in
            finished(js, nil)
        }
    }
    
    /// 获取网络数据缓存字节数
    ///
    /// - Returns: 网络数据缓存字节数
    func totalCacheSize() -> Double {
        let path = cachePath()
        var isDir: ObjCBool = false
        var total: Double = 0
        
        FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        if isDir.boolValue {
            do {
                let array = try FileManager.default.contentsOfDirectory(atPath: path)
                for subPath in array {
                    let subPath = path + "/" + subPath
                    do {
                        let dict: NSDictionary = try FileManager.default.attributesOfItem(atPath: subPath) as NSDictionary
                        total += Double(dict.fileSize())
                    } catch  {
                        if isDebug {
                            SLog("‼️失败==\(error)")
                        }
                    }
                    
                }
            } catch  {
                if isDebug {
                    SLog("‼️失败==\(error)")
                }
            }
        }
        return total
    }
    
    
    /// 清除网络数据缓存
    func clearCaches() {
        DispatchQueue.global().async {
            let path = self.cachePath()
            var isDir: ObjCBool = false
            FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
            if isDir.boolValue {
                do {
                    try FileManager.default.removeItem(atPath: path)
                    if self.isDebug {
                        SLog("清除网络数据缓存成功🍎")
                    }
                } catch  {
                    if self.isDebug {
                        SLog("清除网络数据缓存失败‼️ \(error)")
                    }
                }
                
            }
        }
    }
    
    //MARK: 私有方法
    
    
    /// 成功的日志输出
    ///
    /// - Parameters:
    ///   - json: 成功的回调
    ///   - url: 接口
    ///   - params: 参数
    private func networkLogSuccess(json: JSON?, url: String, params: [String:Any]?) {
        if isDebug {
            // let absolute = absoluteUrl(path: url)
            // let param = appendDefaultParameter(params: params)
            // SLog("请求成功🍎, 🌏 \(absolute) \nparams ==>> \(String(describing: param)) \nresponse ==>> \(String(describing: json))")
        }
    }
    
    
    /// 失败的日志输出
    ///
    /// - Parameters:
    ///   - error: 失败信息
    ///   - url: 接口信息
    ///   - params: 参数字典
    private func networkLogFail(error: NSError?, url: String, params: [String:Any]?) {
        if isDebug {
            let absolute = absoluteUrl(path: url)
            let param = appendDefaultParameter(params: params)
            if error?.code == NSURLErrorCancelled {
                SLog("请求被取消🏠, 🌏 \(absolute) \nparams ==>> \(String(describing: param)) \n错误信息❌ ==>> \(String(describing: error))")
            } else {
                SLog("请求错误, 🌏 \(absolute) \nparams ==>> \(String(describing: param)) \n错误信息❌ ==>> \(String(describing: error))")
            }
        }
    }
    
    /// 将传入的参数字典转成字符串用于显示和判断唯一性，仅对一级字典结构有效
    ///
    /// - Parameters:
    ///   - url: 完整的url
    ///   - params: 参数字典
    /// - Returns: GET形式的字符串
    private func generateGETAbsoluteURL(url: String, params: [String:Any]?) -> String {
        var absoluteUrl = ""
        
        if params != nil {
            let par = appendDefaultParameter(params: params)
            for (key,value):(String,Any) in par! {
                if value is [Any] || value is [AnyHashable: Any] || value is Set<AnyHashable> {
                    continue
                } else {
                    absoluteUrl = "\(absoluteUrl)&\(key)=\(value)"
                }
            }
        }
        
        absoluteUrl = url + absoluteUrl
        
        return absoluteUrl
    }
    
    
    /// 保存网络回调数据
    ///
    /// - Parameters:
    ///   - response: 网络回调JSON数据
    ///   - url: 外部传入的接口
    ///   - parameters: 外部传入的参数
    private func cacheResponse(response: JSON?, url: String, parameters: [String :Any]?) {
        if response != nil {
            let directoryPath = cachePath()
            if !FileManager.default.fileExists(atPath: directoryPath) {
                do {
                    try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    if isDebug {
                        SLog("创建文件夹失败 ‼️ \(error)")
                    }
                    return
                }
            }
            let absolute = absoluteUrl(path: url)
            let absoluteGet = generateGETAbsoluteURL(url: absolute, params: parameters)
            let key = md5(absoluteGet)
            let path = directoryPath.appending("/\(key)")
            var data:Data? = nil
            do {
                data = try JSONSerialization.data(withJSONObject: response?.dictionaryObject ?? [:], options: .prettyPrinted)
            } catch  {
                if isDebug {
                    SLog("‼️ \(error)")
                }
            }
            if data != nil {
                FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
                if isDebug {
                    SLog("保存网络数据成功 🌏 \(absoluteGet)")
                }
            }
            
        }
    }
    
    
    /// 获取缓存的JSON数据
    ///
    /// - Parameters:
    ///   - url: 外部接口
    ///   - parameters: 参数字典
    /// - Returns: 缓存的JSON数据
    private func getCacheResponse(url: String, parameters: [String :Any]?) -> JSON? {
        var json:JSON? = nil
        let directoryPath = cachePath()
        let absolute = absoluteUrl(path: url)
        let absoluteGet = generateGETAbsoluteURL(url: absolute, params: parameters)
        let key = md5(absoluteGet)
        let path = directoryPath.appending("/\(key)")
        let data = FileManager.default.contents(atPath: path)
        if data != nil {
            json = JSON(data!)
            if isDebug {
                SLog("读取缓存的数据 🌏 \(absoluteGet)")
            }
        }
        
        return json
    }
    
    /// 拼接基础路径和接口路径
    ///
    /// - Parameter path: 接口路径
    /// - Returns: 完整的接口url
    private func absoluteUrl(path: String?) -> String {
        if path == nil || path?.characters.count == 0 {
            if baseUrl != nil {
                return baseUrl!
            }
            return ""
        }
        if baseUrl == nil || baseUrl?.characters.count == 0 {
            return path!
        }
        var absoluteUrl = path!
        if !path!.hasPrefix("http://") && !path!.hasPrefix("https://") {
            if baseUrl!.hasSuffix("/") {
                if path!.hasPrefix("/") {
                    var mutablePath = path!
                    mutablePath.remove(at: mutablePath.index(mutablePath.startIndex, offsetBy: 0))
                    absoluteUrl = baseUrl! + mutablePath
                } else {
                    absoluteUrl = baseUrl! + path!
                }
            } else {
                if path!.hasPrefix("/") {
                    absoluteUrl = baseUrl! + path!
                } else {
                    absoluteUrl = baseUrl! + "/" + path!
                }
            }
        }
        return absoluteUrl
    }
    
    
    /// 参数字典增加默认key／value
    ///
    /// - Parameter params: 外部传入的参数字典
    /// - Returns: 添加默认key／value的字典
    private func appendDefaultParameter(params: [String:Any]?) -> [String:Any]? {
        var par = params
        par?["version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return par
    }
    
    
    /// 获取缓存的文件夹路径
    ///
    /// - Returns: 文件夹路径
    private func cachePath() -> String {
        return NSHomeDirectory().appending("/Library/Caches/JHNetworkCaches")
    }
}

extension String {
    // url encode
    var urlEncode:String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    // url decode
    var urlDecode :String? {
        return self.removingPercentEncoding
    }
}

protocol Cancellable {
    func cancel()
}

extension Request: Cancellable {}

