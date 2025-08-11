//
//  RVCalendarView.swift
//  RVCalendar
//
//  Created by RV on 26/07/25.
//

import UIKit

class RVCalendarView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var viewBaseBackground: UIView?
    @IBOutlet weak var calendarView: CollectionViewCalendar?
    @IBOutlet weak var labelCurrentMonth: UILabel?
    @IBOutlet weak var labelPreviousMonth: UILabel?
    @IBOutlet weak var labelNextMonth: UILabel?
    @IBOutlet weak var buttonPreviousMonth: UIButton?
    @IBOutlet weak var buttonNextMonth: UIButton?
    @IBOutlet weak var segmentButtonWeekMonth: UISegmentedControl!
    @IBOutlet weak var rvCalendarViewHeightConstraint: NSLayoutConstraint?

    var monthViewCalendarDelegate: CalendarMonthViewDelegate?
    private var selectedDate = Date()
    private var totalDays = [String]()
    
    //To Setup Event Dots With Specific Colors
    var dictDateEventColors = [String: [UIColor]]()
    //Date selector Highlighter color
    var colorForDateSelection = UIColor.green
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }
    
    private func loadFromNib() {
        Bundle.main.loadNibNamed("RVCalendarView", owner: self, options: nil)
        guard let contentView = contentView else {
            fatalError("contentView not connected")
        }
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        commonSetup()
    }
    
    func commonSetup() {
        //calendarView?.calendarViewType = .monthView
        calendarView?.setupCollectionView()
        calendarView?.calendarDelegate = self
        
        calendarView?.dateSelectionColor = colorForDateSelection
        calendarView?.dictArrayDateEventColors = dictDateEventColors
        
        viewBaseBackground?.clipsToBounds = true
        viewBaseBackground?.layer.borderWidth = 1.0
        viewBaseBackground?.layer.borderColor = UIColor.gray.cgColor
        viewBaseBackground?.layer.cornerRadius = 20.0
        setupCalendarHeaders() 
    }
    
    func reloadMonthViewCalendar() {
        calendarView?.dateSelectionColor = colorForDateSelection
        calendarView?.dictArrayDateEventColors = dictDateEventColors
        calendarView?.reloadData()
    }
    
    func reloadMonthViewFor(newSelectedDate: String) {
        calendarView?.reloadMonthViewFor(selectedNewDate: newSelectedDate)
    }
    
    func setupCalendarHeaders() {
        let monthLabelText = CalendarHelper().monthYearString(date: selectedDate)
        let previousMonth = CalendarHelper.shared.getPreviousMonth(from: selectedDate)
        let previousMonthText = CalendarHelper().monthName(from: previousMonth)
        let nextMonth = CalendarHelper.shared.getNextMonth(from: selectedDate)
        let nextMonthText = CalendarHelper().monthName(from: nextMonth)
        
        labelCurrentMonth?.text = monthLabelText
            labelPreviousMonth?.text = previousMonthText
            labelNextMonth?.text = nextMonthText
    }
    
    @IBAction func buttonPreviousMonth(_ sender: Any) {
            calendarView?.goToPreviousMonth()
    }
    
    @IBAction func buttonNextMonth(_ sender: Any) {
            calendarView?.goToNextMonth()
    }
    
    func setDateSelectorColor(colorName: UIColor) {
        calendarView?.setDateSelectionColor(colorName: colorName)
        colorForDateSelection = colorName
    }
}

extension RVCalendarView {
    
}


extension RVCalendarView: CalendarCollectionDelegate {
   
    func currentMonth(nameText: String) {
        labelCurrentMonth?.text = nameText
    }
    
    func nextMonth(nameText: String) {
        labelNextMonth?.text = nameText
    }
    
    func previousMonth(nameText: String) {
        labelPreviousMonth?.text = nameText
    }
    
    func dateSelected(dateString: String) {
        print(dateString)
        monthViewCalendarDelegate?.monthViewSelected(dateString: dateString)
    }
    
    func newCalendarMonth(date: Date) {
        monthViewCalendarDelegate?.monthViewMonthChangedTo(newDate: date)
    }
    
    func newMonthCalendar(height: CGFloat) {
        //monthViewCalendarDelegate?.monthViewNewMonthCalendar(height: height)
    }
    
    
}
