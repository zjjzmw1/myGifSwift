//
//  NSDate+JCDate.swift
//  JCSwiftKitDemo
//
//  Created by molin.JC on 2017/1/4.
//  Copyright © 2017年 molin. All rights reserved.
//

import Foundation

private let kNSDATE_MINUTE_SEC = 60;      // 一分 = 60秒
private let kNSDATE_HOURS_SEC  = 3600;    // 一小时 = 60分 = 3600秒
private let kNSDATE_DAY_SEC    = 86400;   // 一天 = 24小时 = 86400秒
private let kNSDATE_WEEK_SEC   = 604800;  // 一周 = 7天 =  604800秒

enum dateFormatStyle: String {
    case Style1 = "yyyy-MM-dd"
}

extension NSDate {
    
    class func formatterWithStyle(withStyle style: dateFormatStyle) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current
        formatter.dateFormat = style.rawValue
        return formatter
    }
    
    /**
     根据时间戳返回日期
     
     - parameter stamp: 时间戳字符串
     
     - returns: 日期
     */
    class func dateWithTimeStamp(stamp: String) -> NSDate? {
        if let interval = TimeInterval(stamp) {
            return NSDate(timeIntervalSince1970: interval / 1000.0)
        }
        return nil
    }
    
    /**
     根据日期返回字符串格式
     
     - returns: 日期字符串
     */
    func string(withStyle style: dateFormatStyle) -> String? {
        switch style {
        case .Style1:
            let formatter = NSDate.formatterWithStyle(withStyle: style)
            return formatter.string(from: self as Date)
        }
    }
    
    private func dateFormat() -> Date {
        let formatter = NSDate.formatterWithStyle(withStyle: .Style1)
        let dateStr = formatter.string(from: self as Date)
        return formatter.date(from: dateStr)!
    }
    
    var yearSwift: NSInteger {
        get {
            return NSCalendar.current.component(Calendar.Component.year, from: self as Date);
        }
    }
    
    var monthSwift: NSInteger {
        get {
            return NSCalendar.current.component(Calendar.Component.month, from: self as Date);
        }
    }
    
    var daySwift: NSInteger {
        get {
            return NSCalendar.current.component(Calendar.Component.day, from: self as Date);
        }
    }
    
    var hourSwift: NSInteger {
        get {
            return NSCalendar.current.component(Calendar.Component.hour, from: self as Date);
        }
    }
    
    var minuteSwift: NSInteger {
        get {
            return NSCalendar.current.component(Calendar.Component.minute, from: self as Date);
        }
    }
    
    var secondSwift: NSInteger {
        get {
            return NSCalendar.current.component(Calendar.Component.second, from: self as Date);
        }
    }
    
    var nanosecondSwift: NSInteger {
        get {
            return NSCalendar.current.component(Calendar.Component.nanosecond, from: self as Date);
        }
    }
    
    var weekdaySwift: NSInteger {
        get {
            return NSCalendar.current.component(Calendar.Component.weekday, from: self as Date);
        }
    }
    
    var weekdayOrdinalSwift: NSInteger {
        get {
            return NSCalendar.current.component(Calendar.Component.weekdayOrdinal, from: self as Date);
        }
    }
    
    var weekOfMonthSwift: NSInteger {
        get {
            return NSCalendar.current.component(Calendar.Component.weekOfMonth, from: self as Date);
        }
    }
    
    var weekOfYearSwift: NSInteger {
        get {
            return NSCalendar.current.component(Calendar.Component.weekOfYear, from: self as Date);
        }
    }
    
    var yearForWeekOfYearSwift: NSInteger {
        get {
            return NSCalendar.current.component(Calendar.Component.yearForWeekOfYear, from: self as Date);
        }
    }
    
    var quarterSwift: NSInteger {
        get {
            return NSCalendar.current.component(Calendar.Component.quarter, from: self as Date);
        }
    }
    
    /// 闰月
    var isLeapMonthSwift: Bool {
        get {
            return DateComponents.init().isLeapMonth!;
        }
    }
    
    /// 闰年
    var isLeapYearSwift: Bool {
        get {
            let year = self.yearSwift;
            return ((year % 400 == 0) || (year % 100 == 0) || (year % 4 == 0));
        }
    }
    
    /// 今天
    var isTodaySwift: Bool {
        get {
            if (fabs(self.timeIntervalSinceNow) >= Double(kNSDATE_DAY_SEC)) {
                return false;
            }
            return NSDate.init().daySwift == self.day;
        }
    }
}

extension NSDate {
    
    class func dateWithString(stringDate: String) -> NSDate? {
        return NSDate.dateWithString(stringDate: stringDate, format: "yyyy-MM-dd HH:mm:ss");
    }
    
    class func dateWithString(stringDate: String, format: String) -> NSDate? {
        let formatter = DateFormatter.init();
        formatter.locale = NSLocale.current;
        formatter.dateFormat = format;
        return formatter.date(from: stringDate) as NSDate?;
    }
    
    func string() -> String {
        return self.stringWithFormat(format: "yyyy-MM-dd HH:mm:ss");
    }
    
    func stringWithFormat(format: String) -> String {
        let formatter = DateFormatter.init();
        formatter.locale = NSLocale.current;
        formatter.dateFormat = format;
        return formatter.string(from: self as Date);
    }
    
    /// 明天
    class func dateTomorrow() -> NSDate {
        return NSDate.dateWithDaysFromNow(days: 1);
    }
    
    /// 后几天
    class func dateWithDaysFromNow(days: NSInteger) -> NSDate {
        return NSDate.init().dateByAdding(days: days);
    }
    
    /// 昨天
    class func dateYesterday() -> NSDate {
        return NSDate.dateWithDaysBeforeNow(days: 1);
    }
    
    /// 前几天
    class func dateWithDaysBeforeNow(days: NSInteger) -> NSDate {
        return NSDate.init().dateByAdding(days: -(days));
    }
    
    /// 当前小时后hours个小时
    class func dateWithHoursFromNow(hours: NSInteger) -> NSDate {
        return NSDate.dateByAddingTimeInterval(ti: TimeInterval(kNSDATE_HOURS_SEC * hours));
    }
    
    /// 当前小时前hours个小时
    class func dateWithHoursBeforeNow(hours: NSInteger) -> NSDate {
        return NSDate.dateByAddingTimeInterval(ti: TimeInterval(-kNSDATE_HOURS_SEC * hours));
    }
    
    /// 当前分钟后minutes个分钟
    class func dateWithMinutesFromNow(minutes: NSInteger) -> NSDate {
        return NSDate.dateByAddingTimeInterval(ti: TimeInterval(kNSDATE_MINUTE_SEC * minutes));
    }
    
    /// 当前分钟前minutes个分钟
    class func dateWithMinutesBeforeNow(minutes: NSInteger) -> NSDate {
        return NSDate.dateByAddingTimeInterval(ti: TimeInterval(-kNSDATE_MINUTE_SEC * minutes));
    }
    
    /// 追加天数，生成新的NSDate
    func dateByAdding(days: NSInteger) -> NSDate {
        var dateComponents = DateComponents.init();
        dateComponents.day = days;
        let date = NSCalendar.current.date(byAdding: dateComponents, to: (self as Date?)!);
        return (date as NSDate?)!;
    }
    
    /// 追加秒数，生成新的NSDate
    class func dateByAddingTimeInterval(ti: TimeInterval) -> NSDate {
        let aTimeInterval = NSDate.init().timeIntervalSinceReferenceDate + ti;
        let date = NSDate.init(timeIntervalSinceReferenceDate: aTimeInterval);
        return date;
    }
}
