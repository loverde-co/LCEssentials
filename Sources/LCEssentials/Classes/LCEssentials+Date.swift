//  
// Copyright (c) 2018 Loverde Co.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
 

import Foundation
import UIKit

public extension Date {
    fileprivate struct Item {
        let multi: String
        let single: String
        let last: String
        let value: Int?
    }
    
    /// LoverdeCo: Timestamp to Date.
    ///
    /// - Parameters:
    ///   - timestamp: Give a input timestamp double.
    ///   - stringFormat: Give a input formatt that is setted.
    ///   - localeIdentifier: Locale your time
    ///   - timeZone: Specify your time zone   
    ///   - Returns: Date object.
    func timestampToDate(timestamp: Double, stringFormat:String = "yyyy-MM-dd HH:mm", localeIdentifier: String = "pt-BR", timeZone:TimeZone? = TimeZone.current) -> Date? {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter:DateFormatter = DateFormatter.init()
        let calendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let enUSPOSIXLocale:Locale = Locale.init(identifier: localeIdentifier)
        //
        dateFormatter.timeZone = timeZone
        //
        dateFormatter.calendar = calendar
        dateFormatter.locale = enUSPOSIXLocale
        dateFormatter.dateFormat = stringFormat
        let strDate:String = dateFormatter.string(from: date)
        return dateFormatter.date(from: strDate)
    }
    
    
    /// LoverdeCo: Date to String object.
    ///
    /// - Parameters:
    ///   - stringFormat: Give a input formatt that is setted.
    ///   - localeIdentifier: Locale your time
    ///   - timeZone: Specify your time zone
    ///   - Returns: String object.
    func string(stringFormat: String, localeIdentifier: String = "pt-BR", timeZone: TimeZone? = TimeZone.current) -> String {

        let dateFormatter:DateFormatter = DateFormatter.init()
        let calendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let enUSPOSIXLocale:Locale = Locale.init(identifier: localeIdentifier)
        //
        dateFormatter.timeZone = timeZone
        //
        dateFormatter.calendar = calendar
        dateFormatter.locale = enUSPOSIXLocale
        dateFormatter.dateFormat = stringFormat
        //
        let strDate:String = dateFormatter.string(from: self)
        //
        return strDate
    }

    /// Returns a Date with the specified days added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        var targetDay: Date
        targetDay = Calendar.current.date(byAdding: .year, value: years, to: self)!
        targetDay = Calendar.current.date(byAdding: .month, value: months, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .day, value: days, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .hour, value: hours, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .minute, value: minutes, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .second, value: seconds, to: targetDay)!
        return targetDay
    }
    func add(value: Int = 0, byAdding: Calendar.Component) -> Date {
        var targetDay: Date
        targetDay = Calendar.current.date(byAdding: byAdding, value: value, to: self)!
        return targetDay
    }

    /// Returns a Date with the specified days subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        let inverseYears = -1 * years
        let inverseMonths = -1 * months
        let inverseDays = -1 * days
        let inverseHours = -1 * hours
        let inverseMinutes = -1 * minutes
        let inverseSeconds = -1 * seconds
        return add(years: inverseYears, months: inverseMonths, days: inverseDays, hours: inverseHours, minutes: inverseMinutes, seconds: inverseSeconds)
    }

    func returnSunday(fromDate: Date) -> Date? {
        let gregorian = Calendar(identifier: .gregorian)
        if let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: fromDate)){
            //print(gregorian.date(byAdding: .day, value: 6, to: sunday)!)
            return sunday
        }else{ return nil }
    }

    func getMonthName(identifier: String = "pt-BR") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        dateFormatter.locale = identifier != "" ? Locale(identifier: identifier) : Locale.current
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }

    func getDayNumber(identifier: String = "pt-BR") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.locale = identifier != "" ? Locale(identifier: identifier) : Locale.current
        let strDay = dateFormatter.string(from: self)
        return strDay
    }
    
    func getWeekDayName(identifier: String = "pt-BR") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = identifier != "" ? Locale(identifier: identifier) : Locale.current
        let strDay = dateFormatter.string(from: self)
        return strDay
    }
    func getStartOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func getEndOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.getStartOfMonth())!
    }
    
    func getCorrectDateFromLocalTimezone() -> Date? {
        let currDate = Calendar.current.dateComponents(in: .current, from: Date())
        var secs = "\(currDate.second ?? 0)"
        if (currDate.second ?? 0 ) < 10 {
            secs = "0\(currDate.second ?? 0)"
        }
        let currDateStr = "\(currDate.year ?? 0)-\(currDate.month ?? 0)-\(currDate.day ?? 0) \(currDate.hour ?? 0):\(currDate.minute ?? 0):\( secs )"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let final = dateFormatter.date(from: currDateStr)
        return final
    }
    
    func returnBetweenDate(startDate: Date, endDate: Date, years:Bool = false, months:Bool = false,  days:Bool = false) -> Int {
        
        let calendar = NSCalendar.current
        
        var components: DateComponents!
        
        if years {
            components = calendar.dateComponents( [.year], from: startDate, to: endDate)
            return components.year ?? 0
        }else if months {
            components = calendar.dateComponents( [.month], from: startDate, to: endDate)
            return components.month ?? 0
        }else{
            components = calendar.dateComponents( [.day], from: startDate, to: endDate)
            return components.day ?? 0
        }
    }
    
    //MARK: Nice time
    fileprivate var components: DateComponents {
        return Calendar.current.dateComponents(
            [.minute, .hour, .day, .weekOfYear, .month, .year, .second],
            from: Calendar.current.date(byAdding: .second, value: -1, to: Date()) ?? Date(),
            to: self
        )
    }
    
    fileprivate var items: [Item] {
        return [
            Item(multi: "years ago", single: "1 year ago", last: "Last year", value: components.year),
            Item(multi: "months ago", single: "1 month ago", last: "Last month", value: components.month),
            Item(multi: "weeks ago", single: "1 week ago", last: "Last week", value: components.weekday),
            Item(multi: "days ago", single: "1 day ago", last: "Last day", value: components.day),
            Item(multi: "minutes ago", single: "1 minute ago", last: "Last minute", value: components.minute),
            Item(multi: "seconds ago", single: "Just now", last: "Last second", value: components.second)
        ]
    }
    
    func timeAgo(numericDates: Bool = false) -> String {
        for item in items {
            switch (item.value, numericDates) {
            case let (.some(step), _) where step == 0:
                continue
            case let (.some(step), true) where step == 1:
                return item.last
            case let (.some(step), false) where step == 1:
                return item.single
            case let (.some(step), _):
                return String(step) + " " + item.multi
            default:
                continue
            }
        }
        
        return "Just now"
    }
    //print(Calendar.current.date(byAdding: .day, value: 1, to: Date())!.timeAgo())
    
    func timeAgoSinceDate(numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < self ? now : self
        let latest = (earliest == now) ? self : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
}
