//
//  String+JCString.swift
//  JCSwiftKitDemo
//
//  Created by molin.JC on 2017/1/6.
//  Copyright © 2017年 molin. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

extension String {
    
    /// 以下这几种情况都认为的空
    public static func isEmptyString(str: String?) -> Bool {
        if str == nil {
            return true
        } else if (str == "") {
            return true
        } else if (str == "<null>") {
            return true
        } else if (str == "(null)") {
            return true
        } else if (str == "null") {
            return true
        }
        return false
    }
    
    /// 移除两个字符串之间的字符串后的结果
    public func removeAllSubString(beginStr: String, endStr: String) -> String {
        SLog(self)
        var last = String.init(format: "%@",self)
        for _ in 0...self.components(separatedBy: beginStr).count + 1 {
            if last.contain(ofString: beginStr) && last.contain(ofString: endStr) {
                let tempStr: NSString = NSString.init(string: last)
                let starRange = tempStr.range(of: beginStr)
                let endRange = tempStr.range(of: endStr)
                let range: NSRange! = NSMakeRange(starRange.location, endRange.location - starRange.location + 1)
                let lastStr: String? = tempStr.substring(with: range)
                last = tempStr.replacingOccurrences(of: lastStr ?? "", with: "")
            } else {
                last = self
            }
        }
        return last
    }
    /// 移除前两个两个字符串之间的字符串后的结果
    public func removeFirstSubString(beginStr: String, endStr: String) -> String {
        var last = String.init(format: "%@",self)
        if last.contain(ofString: beginStr) && last.contain(ofString: endStr) {
            let tempStr: NSString = NSString.init(string: last)
            let starRange = tempStr.range(of: beginStr)
            let endRange = tempStr.range(of: endStr)
            let range: NSRange! = NSMakeRange(starRange.location, endRange.location - starRange.location + 1)
            let lastStr: String? = tempStr.substring(with: range)
            last = tempStr.replacingOccurrences(of: lastStr ?? "", with: "")
        } else {
            last = self
        }
        return last
    }
    
    /// 获取两个字符串直接的字符串
    public func getSubStr(beginStr: String, endStr: String) -> String {
        let tempStr: NSString = NSString.init(string: self)
        let starRange = tempStr.range(of: beginStr)
        let endRange = tempStr.range(of: endStr)
        let range: NSRange! = NSMakeRange(starRange.location + starRange.length, endRange.location - starRange.location - starRange.length)
        let lastStr: String? = tempStr.substring(with: range)
        return lastStr ?? self
    }
    
    public var length: Int {
        get {
            return self.characters.count;
        }
    }
    
    func toNumber() -> NSNumber? {
        let number = NumberFormatter.init().number(from: self);
        return number;
    }
    
    func toInt() -> Int? {
        let number = self.toNumber();
        if (number != nil) {
            return number?.intValue;
        }
        return 0;
    }
    
    func toFloat() -> Float? {
        let number = self.toNumber();
        if (number != nil) {
            return number?.floatValue;
        }
        return 0;
    }
    
    func toDouble() -> Double? {
        let number = self.toNumber();
        if (number != nil) {
            return number?.doubleValue;
        }
        return 0;
    }
    
    func toBool() -> Bool? {        
        let number = self.toInt()!;
        if (number > 0) {
            return true;
        }
        
        let lowercased = self.lowercased()
        switch lowercased {
        case "true", "yes", "1":
            return true;
        case "false", "no", "0":
            return false;
        default:
            return false;
        }
    }
    
    /// UTF8StringEncoding编码转换成Data
    func dataUsingUTF8StringEncoding() -> Data? {
        return self.data(using: String.Encoding.utf8);
    }
    
    /// 获取当前的日期，格式为：yyyy-MM-dd HH:mm:ss
    static func dateString() -> String {
        return NSDate.init().string();
    }
    
    ///  获取当前的日期, 格式自定义
    func dateString(format: String) -> String {
        return NSDate.init().stringWithFormat(format: format);
    }
    
    /// 时间戳字符串转换为日期格式
    func toDateStr(format: String?) -> String {
        var formatStr = "yyyy-MM-dd"
        if (format != nil) {
            formatStr = format!
        }
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(self)!
        let date = Date(timeIntervalSince1970: timeInterval)
        //格式话输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = formatStr
        return dformatter.string(from: date)
    }
    
    /// 两个时间戳的差几天
    func toDays(endDateString: String?) -> Int {
        if endDateString == nil {
            return 0
        } else {
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy-MM-dd"

            let timeInterval0:TimeInterval = TimeInterval(self)!
            let date0 = Date(timeIntervalSince1970: timeInterval0)

            let timeInterval1:TimeInterval = TimeInterval(self)!
            let date1 = Date(timeIntervalSince1970: timeInterval1)
            if date0 == nil {
                return 0
            }
            let timeInter = date1.timeIntervalSince(date0)/(3600*24)
            return Int(timeInter)
        }
    }
    
    /// ISO8601格式的字符串转换为 固定格式的字符串
    func toDateStrISO8601(formate: String?) -> String {
        var format = "yyyy-MM-dd"
        if formate != nil {
            format = formate!
        }
        let isoFormate = ISO8601DateTimeFormatter.init()
        isoFormate.formatOptions = .withInternetDateTimeExtended
        let date = isoFormate.date(from: self)
        let dateStr = date?.stringWithFormat(format: format) ?? ""
        return dateStr
    }
    
    /// ISO8601格式的字符串转换为 固定格式的字符串
    func toDateStrISO8601ToDate(formate: String?) -> Date {
        let isoFormate = ISO8601DateTimeFormatter.init()
        isoFormate.formatOptions = .withInternetDateTimeExtended
        let date = isoFormate.date(from: self)
        if let date = date {
            return date
        } else {
            return Date()
        }
    }
    
    /// 两个时间戳的差几天
    func toDaysISO8601(endDateString: String?) -> Int {
        if endDateString == nil {
            return 0
        } else {
            let isoFormate = ISO8601DateTimeFormatter.init()
            isoFormate.formatOptions = .withInternetDateTimeExtended
            let date0 = isoFormate.date(from: self)
            let date1 = isoFormate.date(from: endDateString!)
            if date0 == nil || date1 == nil {
                return 0
            }
            let timeInter = (date1?.timeIntervalSince(date0!))!/(3600*24)
            return Int(timeInter)
        }
    }
    
    func sizeFor(size: CGSize, font: UIFont = FONT_PingFang(fontSize: 15)) -> CGSize {
       return self.sizeFor(size: size, font: font, lineBreakMode: .byWordWrapping)
    }
    /// 根据字体大小，所要显示的size，以及字段样式来计算文本的size
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - size: 所要显示的size
    ///   - lineBreakMode: 字段样式
    /// - Returns: CGSize大小
    func sizeFor(size: CGSize, font: UIFont = FONT_PingFang(fontSize: 15), lineBreakMode: NSLineBreakMode = NSLineBreakMode.byWordWrapping) -> CGSize {
        var attr = Dictionary<String, Any>.init();
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakMode.byWordWrapping) {
            let paragraphStyle = NSMutableParagraphStyle.init();
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        let rect = (self as NSString).boundingRect(with: size, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: attr, context: nil);
        return rect.size;
    }
    
    /// 去掉头尾的空格
    func stringByTrimSpace() -> String {
        let set = CharacterSet.whitespacesAndNewlines;
        return self.trimmingCharacters(in: set);
    }
    
    /// 替换掉某个字符串
    ///
    /// - Parameters:
    ///   - replacement: 要替换成的字符串
    ///   - targets: 要被替换的字符串
    /// - Returns: String
    func stringReplacement(replacement: String, targets: String...) -> String? {
        var complete = self;
        for target in targets {
            complete = complete.replacingOccurrences(of: target, with: replacement);
        }
        return complete;
    }
    
    /// 是否包含某字符串
    func contain(ofString: String) -> Bool {
        return (self.range(of: ofString) != nil);
    }
    
    /// 根据正则表达式判断
    ///
    /// - Parameter format: 正则表达式的样式
    /// - Returns: Bool
    func evaluate(format: String) -> Bool {
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", format);
        return predicate.evaluate(with: self);
    }
    
    /// 邮箱的正则表达式
    func regexpEmail() -> Bool {
        let format = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        return self.evaluate(format: format);
    }
    
    /// IP地址的正则表达式
    func regexpIp() -> Bool {
        let format = "((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)"
        return self.evaluate(format: format);
    }
    
    /// HTTP链接 (例如 http://www.baidu.com )
    func regexpHTTP() -> Bool {
        let format = "([hH]ttp[s]{0,1})://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\-~!@#$%^&*+?:_/=<>.\',;]*)?"
        return self.evaluate(format: format);
    }
    
    /// UUID
    static func stringWithUUID() -> String {
        let uuid = CFUUIDCreate(nil);
        let str = CFUUIDCreateString(nil, uuid);
        return str! as String;
    }
    
    /// 判断是否是为整数
    func isPureInteger() -> Bool {
        let scanner = Scanner.init(string: self);
        var integerValue: Int?;
        return scanner.scanInt(&integerValue!)  && scanner.isAtEnd;
    }
    
    /// 判断是否为浮点数，可做小数判断
    func isPureFloat() -> Bool {
        let scanner = Scanner.init(string: self);
        var floatValue: Float?;
        return scanner.scanFloat(&floatValue!) && scanner.isAtEnd;
    }
    
    /// 输出格式：123,456；每隔三个就有","
    static func stringFormatterWithDecimal(number: NSNumber) -> String {
        return String.stringFormatter(style: NumberFormatter.Style.decimal, number: number);
    }
    
    ///  number转换百分比： 12,345,600%
    static func stringFormatterWithPercent(number: NSNumber) -> String {
        return String.stringFormatter(style: NumberFormatter.Style.percent, number: number);
    }
    
    /// 设置NSNumber输出的格式
    ///
    /// - Parameters:
    ///   - style: 格式
    ///   - number: NSNumber数据
    /// - Returns: String
    static func stringFormatter(style: NumberFormatter.Style, number: NSNumber) -> String {
        let formatter = NumberFormatter.init();
        formatter.numberStyle = style;
        return formatter.string(from: number)!;
    }
    
}
