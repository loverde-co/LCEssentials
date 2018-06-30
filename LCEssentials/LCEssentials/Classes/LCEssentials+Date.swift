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
        var convertedDate = ""
        if dateArray.count > 1 {
            convertedDate = "\(dateArray[2])-\(dateArray[1])-\(dateArray[0])"
        }else{
            convertedDate = date
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = formatted
        return dateFormatter.date(from: convertedDate)!
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
}
