//
//  CalendarHelper.swift
//  RVCalendar
//
//  Created by RV on 26/07/25.
//

import Foundation
class CalendarHelper {
    
    @MainActor static let shared = CalendarHelper()
    
    let calendar = Calendar.current

    func monthYearString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: date)
    }

    func daysInMonth(date: Date) -> Int {
        calendar.range(of: .day, in: .month, for: date)?.count ?? 0
    }

    func firstOfMonth(date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? Date()
    }
    
    func startOfWeek(from date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(date: Date) -> Int {
        calendar.component(.weekday, from: date) - 1
    }

    func plusMonth(date: Date) -> Date {
        calendar.date(byAdding: .month, value: 1, to: date) ?? Date()
    }

    func minusMonth(date: Date) -> Date {
        calendar.date(byAdding: .month, value: -1, to: date) ?? Date()
    }
    
    func monthName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        return formatter.string(from: date)
    }
    
    func getPreviousMonth(from date: Date) -> Date {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func getNextMonth(from date: Date) -> Date {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func numberOfWeeksInMonth(for date: Date) -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        let totalDays = range.count

        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let weekday = calendar.component(.weekday, from: firstDayOfMonth) // Sunday = 1

        let offset = weekday - calendar.firstWeekday
        let leadingEmptyDays = offset < 0 ? 7 + offset : offset

        let totalCells = totalDays + leadingEmptyDays
        let numberOfWeeks = Int(ceil(Double(totalCells) / 7.0))

        return numberOfWeeks
    }

}
