//
//  CalendarProtocols.swift
//  RVCalendar
//
//  Created by RV on 07/08/25.
//

import Foundation
//MARK: - Protocol Methods For Calendar As Month View


protocol CalendarCollectionDelegate {
    @MainActor func currentMonth(nameText: String)
    @MainActor func nextMonth(nameText: String)
    @MainActor func previousMonth(nameText: String)
    @MainActor func dateSelected(dateString: String)
    @MainActor func newCalendarMonth(date: Date)
    @MainActor func newMonthCalendar(height: CGFloat)
}

//Making It Optional As Its Not Working Properly Need To Work More On This Part
extension CalendarCollectionDelegate {
    func newMonthCalendar(height: CGFloat) {
        
    }
}

//MARK: - Protocol Methods For Calendar As Week View
protocol CalendarWeekViewDelegate {
    @MainActor func dateSelected(dateString: String)
    @MainActor func weekViewMonthChangedTo(newDate: Date)
}

//MARK: - Protocol Methods For Calendar As Month View
protocol CalendarMonthViewDelegate {
    @MainActor func monthViewSelected(dateString: String)
    @MainActor func monthViewMonthChangedTo(newDate: Date)
    @MainActor func monthViewNewMonthCalendar(height: CGFloat)
}

//Making It Optional As Its Not Working Properly Need To Work More On This Part
extension CalendarMonthViewDelegate {
    func monthViewNewMonthCalendar(height: CGFloat) {
        
    }
}


protocol RVCalendarDelegate {
    func updateHeightTo(newHeight: CGFloat)
    func selectedDate(stringValue: String)
}
