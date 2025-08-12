//
//  RVCalendar.swift
//  RVCalendar
//
//  Created by RV on 07/08/25.
//

import Foundation
import UIKit

public class RVCalendar: UIView {
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var segmentButtonWeekMonth: UISegmentedControl!
    @IBOutlet weak var labelCalendarViewType: UILabel!
    
    @IBOutlet weak var calendarMonthViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var calendarMonthView: RVCalendarView!
    @IBOutlet weak var calendarWeekViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var calendarWeekView: CalendarWeekView!

    var heightOfMonthCalendar = 433.0
    
    var dateCurrentlySelectedOnCalendar = ""
    
    //Calendar Month Changed
    var calendarNewMonthDate: Date?
    
    public var rvCalendarDelegate: RVCalendarDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }
    
    private func loadFromNib() {
        let bundle = Bundle.module
        bundle.loadNibNamed("RVCalendar", owner: self, options: nil)
        
        guard let contentView = contentView else {
            fatalError("contentView not connected")
        }
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        initialSetup()
    }
    
    private func initialSetup() {
        segmentButtonWeekMonth.selectedSegmentIndex = 1
        labelCalendarViewType.text = "Calendar View"
        
        calendarWeekView.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            if self.calendarWeekView != nil {
                //self.calendarWeekView.weekViewCalendarDelegate = self
            }
            if self.calendarMonthView != nil {
                //self.calendarMonthView.monthViewCalendarDelegate = self
            }
        }
        self.calendarMonthView.clipsToBounds = true
        self.calendarMonthView.layer.cornerRadius = 15.0
        setupSegmentButton()
    }
    
    func setupSegmentButton() {
        //let items = [UIImage(named: "CalendarListBlackIcon")!, UIImage(named: "CalendarMonthBlackIcon")!]
        segmentButtonWeekMonth.setImage(UIImage(named: "CalendarListBlackIcon"), forSegmentAt: 0)
        segmentButtonWeekMonth.setImage(UIImage(named: "CalendarMonthBlackIcon"), forSegmentAt: 1)
        //UISegmentedControl(items: items)
        segmentButtonWeekMonth.selectedSegmentIndex = 1
        
        // Tint color (selected segment background) — Light Purple
        if #available(iOS 13.0, *) {
            segmentButtonWeekMonth.selectedSegmentTintColor = .white
        } else {
            // Fallback for iOS 12 and below
            segmentButtonWeekMonth.tintColor = .white
        } //UIColor(red: 219/255, green: 213/255, blue: 255/255, alpha: 1.0)
        //216,184,238
        //167 095 255
        // Segment icon tint (unselected color)
        segmentButtonWeekMonth.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        
        // Segment icon tint (selected color)
        segmentButtonWeekMonth.setTitleTextAttributes([.foregroundColor: UIColor(red: 162/255, green: 136/255, blue: 253/255, alpha: 1.0)], for: .selected)
        
        // Border (optional)
        segmentButtonWeekMonth.layer.borderColor = UIColor(red: 162/255, green: 136/255, blue: 253/255, alpha: 1.0).cgColor
        segmentButtonWeekMonth.layer.borderWidth = 1
        segmentButtonWeekMonth.layer.cornerRadius = 22
        segmentButtonWeekMonth.clipsToBounds = true
        segmentButtonWeekMonth.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @IBAction func buttonSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //To switch from Week View to Month View:
            labelCalendarViewType.text = "List View"
            toggleViews(showWeekView: true)
            
            if calendarNewMonthDate != nil {
                calendarWeekView.calendarMonthChanged(newMonthDate: calendarNewMonthDate!)
            }
            
            //Set Current Date Selected For Month Date On Both The View Type In Case New Date Is Selected On Any Calendar View Type
            if dateCurrentlySelectedOnCalendar != "" {
                calendarWeekView.reloadWeekViewFor(selectedNewDate: dateCurrentlySelectedOnCalendar)
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.timeZone = TimeZone.current //
                if let dateValue = formatter.date(from: dateCurrentlySelectedOnCalendar) {
                    calendarWeekView.showWeekFor(selectedDate: dateValue)
                }
            }
            
        } else {
            //To switch from Month View to Week View:
            labelCalendarViewType.text = "Calendar View"
            toggleViews(showWeekView: false)
            
            //Set Current Date Selected For Month Date On Both The View Type In Case New Date Is Selected On Any Calendar View Type
            if dateCurrentlySelectedOnCalendar != "" {
                calendarMonthView.reloadMonthViewFor(newSelectedDate: dateCurrentlySelectedOnCalendar)
            }
            
            if calendarNewMonthDate != nil {
                calendarMonthView.calendarView?.reloadCalendarFor(dateValue: calendarNewMonthDate!)
            }
        }
    }
    
    
    private func toggleViews(showWeekView: Bool) {
        // Bounce animation constants
        let animationDuration = 0.6
        let bounceDamping: CGFloat = 0.5
        let initialVelocity: CGFloat = 0.3

        // Update Week View And Month View Height Constraint Value
        calendarWeekViewHeightConstraint?.constant = showWeekView ? 180 : 0
        calendarMonthViewHeightConstraint?.constant = showWeekView ? 0 : 433
        
        let newHeight = showWeekView ? 220.0 : 473.0
        rvCalendarDelegate?.updateHeightTo(newHeight: newHeight)
        
        // Unhide both views during animation
        calendarMonthView.isHidden = false
        calendarWeekView.isHidden = false

        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       usingSpringWithDamping: bounceDamping,
                       initialSpringVelocity: initialVelocity,
                       options: [.curveEaseIn],
                       animations: {
            self.calendarMonthView.alpha = showWeekView ? 0 : 1
            self.calendarWeekView.alpha = showWeekView ? 1 : 0
            self.layoutIfNeeded()
        }, completion: { _ in
            // Toggle visibility after animation
            self.calendarMonthView.isHidden = showWeekView
            self.calendarWeekView.isHidden = !showWeekView
        })
    }
    
    public func setDateSelectionBy(color: UIColor) {
        calendarMonthView.setDateSelectorColor(colorName: color)
        calendarWeekView.setDateSelectionColor(colorName: color)
    }
    
    //To Setup Event Dots With Specific Colors
    public func addEventsOn(datesWithColors: [String: [UIColor]]) {
        calendarWeekView.dictDateEventArrayColors = datesWithColors
        calendarMonthView.dictDateEventColors = datesWithColors
        calendarWeekView.reloadWeekView()
        calendarMonthView.reloadMonthViewCalendar()
    }
}

//MARK: - Week View Delegate Method -
extension RVCalendar: CalendarWeekViewDelegate {
    public func dateSelected(dateString: String) {
        print(dateString)
        rvCalendarDelegate?.selectedDate(stringValue: dateString)
        dateCurrentlySelectedOnCalendar = dateString
    }
    
    public func weekViewMonthChangedTo(newDate: Date) {
        calendarNewMonthDate = newDate
        //calendarMonthView.calendarView?.reloadCalendarFor(dateValue: newDate)
    }
}

extension RVCalendar: CalendarMonthViewDelegate {
    public func monthViewSelected(dateString: String) {
        print(dateString)
        rvCalendarDelegate?.selectedDate(stringValue: dateString)
        dateCurrentlySelectedOnCalendar = dateString
    }
    
    public func monthViewMonthChangedTo(newDate: Date) {
        calendarNewMonthDate = newDate
        //calendarWeekView.calendarMonthChanged(newMonthDate: newDate)
    }
    
    public func monthViewNewMonthCalendar(height: CGFloat) {
        //433 Full View Height
        //40 Space for Calendar Type Label And Segment Button
        //112 + 32 = 144 Space In Calendar View From Top And Bottom
        let newHeight = height + 40.0 + 144.0
        heightOfMonthCalendar = newHeight
        //rvCalendarDelegate?.updateHeightTo(newHeight: newHeight)
    }
}
