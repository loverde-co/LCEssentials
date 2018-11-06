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

public extension Date {
    fileprivate struct Item {
        let multi: String
        let single: String
        let last: String
        let value: Int?
    }
    
    public func stringToDateTime( _ dateTime: String = "", formatted : String = "yyyy-MM-dd", withTime:Bool = false ) -> Date{
        var dateArray = dateTime.split{$0 == "/"}.map(String.init)
        var hour = [String]()
        var convertedDate = ""
        if dateArray.count > 1 {
            hour = dateArray[2].split{$0 == " "}.map(String.init)
            if hour.count > 1 {
                dateArray[2] = hour[0]
            }
            convertedDate = "\(dateArray[2])-\(dateArray[1])-\(dateArray[0])\( withTime ? " \(hour[1])" : "" )"
        }else{
            convertedDate = dateTime
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "\(formatted)\( withTime ? " HH:mm:ss" : "" )"
        return dateFormatter.date(from: convertedDate)!
    }

    public func stringToDate( _ date: String = "2010-10-10", formatted : String = "yyyy-MM-dd" ) -> Date{
        let dateArray = date.split{$0 == "/"}.map(String.init)
        var convertedDate = date
        if dateArray.count > 1 {
            convertedDate = "\(dateArray[2])-\(dateArray[1])-\(dateArray[0])"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = formatted
        return dateFormatter.date(from: convertedDate)!
    }
    
    
    /// LoverdeCo: Date to String object.
    ///
    /// - Parameters:
    ///   - withFormatt: Give a input formatt to any formatt you want.
    ///   - useHour: Keep or remove hour form given date
    ///   - Returns: String object.
    public func toStringFormatt(formattTo: String = "yyyy-MM-dd HH:mm:ss", useHour: Bool = false) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.locale = Calendar.current.locale
        var formatt = formattTo
        if useHour {
            formatt = String(formatt.dropLast(9))
        }
        dateFormatter.dateFormat = formatt
        return dateFormatter.string(from: self)
    }

    /// Returns a Date with the specified days added to the one it is called with
    public func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        var targetDay: Date
        targetDay = Calendar.current.date(byAdding: .year, value: years, to: self)!
        targetDay = Calendar.current.date(byAdding: .month, value: months, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .day, value: days, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .hour, value: hours, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .minute, value: minutes, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .second, value: seconds, to: targetDay)!
        return targetDay
    }

    /// Returns a Date with the specified days subtracted from the one it is called with
    public func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        let inverseYears = -1 * years
        let inverseMonths = -1 * months
        let inverseDays = -1 * days
        let inverseHours = -1 * hours
        let inverseMinutes = -1 * minutes
        let inverseSeconds = -1 * seconds
        return add(years: inverseYears, months: inverseMonths, days: inverseDays, hours: inverseHours, minutes: inverseMinutes, seconds: inverseSeconds)
    }

    public func returnSunday(fromDate: Date) -> Date? {
        let gregorian = Calendar(identifier: .gregorian)
        if let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: fromDate)){
            //print(gregorian.date(byAdding: .day, value: 6, to: sunday)!)
            return sunday
        }else{ return nil }
    }

    public func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }

    public func getDayNumber() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let strDay = dateFormatter.string(from: self)
        return strDay
    }
    
    public func getWeekDayName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let strDay = dateFormatter.string(from: self)
        return strDay
    }
    public func getStartOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    public func getEndOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.getStartOfMonth())!
    }
    
    public func returnBetweenDate(startDate: Date, endDate: Date, years:Bool = false, months:Bool = false,  days:Bool = false) -> Int {
        
        let calendar = NSCalendar.current
        
        var components: DateComponents!
        
        if years {
            components = calendar.dateComponents( [.year], from: startDate, to: endDate)
            return components.year!
        }else if months {
            components = calendar.dateComponents( [.month], from: startDate, to: endDate)
            return components.month!
        }else{
            components = calendar.dateComponents( [.day], from: startDate, to: endDate)
            return components.day!
        }
    }
    
    //MARK: Nice time
    fileprivate var components: DateComponents {
        return Calendar.current.dateComponents(
            [.minute, .hour, .day, .weekOfYear, .month, .year, .second],
            from: Calendar.current.date(byAdding: .second, value: -1, to: Date())!,
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
    
    public func timeAgo(numericDates: Bool = false) -> String {
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
