//
//  CollectionViewCalendar.swift
//  RVCalendar
//
//  Created by RV on 26/07/25.
//

import UIKit


class CollectionViewCalendar:  UICollectionView {
    //------- Calendar Month View -------
    private var selectedDate = Date()
    private var totalDays = [String]()
    private var datesInMonth: [Date?] = []
    //------- Calendar Month View -------
    
    private var cellSelectedToHighlight = -1
    
    var calendarDelegate: CalendarCollectionDelegate?
    var dateSelectionColor = UIColor.white
    var dictArrayDateEventColors = [String: [UIColor]]()
    
    var dateSelectedByUserOnMonthCalendar = ""
    var indexPathForNewSelectedDate: IndexPath?
    
    var nextMonthName: String {
        let nextDate = CalendarHelper.shared.getNextMonth(from: selectedDate)
        return CalendarHelper.shared.monthName(from: nextDate)
    }
    
    var previousMonthName: String {
        let previousDate = CalendarHelper.shared.getPreviousMonth(from: selectedDate)
        return CalendarHelper.shared.monthName(from: previousDate)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCollectionView() {
        self.delegate = self
        self.dataSource = self
        //Cell registration
        let bundle = Bundle.module
        let nib = UINib.init(nibName: "RVCalendarCollectionViewCell", bundle: bundle)
        self.register(nib, forCellWithReuseIdentifier: "RVCalendarCollectionViewCell")
        
        setupMonthView()
        setupCollectionViewLayout()
    }
    
    func setDateSelectionColor(colorName: UIColor) {
        dateSelectionColor = colorName
    }
    
    //------ Calendar As Month View ------
    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0 // space between columns (horizontal spacing)
        layout.minimumLineSpacing = 2       // 🔽 space between rows (vertical spacing)
        
        let totalWidth = self.bounds.width
        let cellWidth = totalWidth / 7
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        self.collectionViewLayout = layout
    }
    
    func setupMonthView() {
        setupMonthViewFor(date: selectedDate)
    }
    
    func setupMonthViewFor(date: Date) {
        totalDays.removeAll()
        datesInMonth.removeAll()
        cellSelectedToHighlight = -1
        let daysInMonth = CalendarHelper().daysInMonth(date: date)
        let firstDay = CalendarHelper().firstOfMonth(date: date)
        let startingSpaces = CalendarHelper().weekDay(date: firstDay)
        
        var count = 1
        while count <= 42 {
            if count <= startingSpaces || count - startingSpaces > daysInMonth {
                totalDays.append("")
                datesInMonth.append(nil) // blank cell
            } else {
                //totalDays.append("\(count - startingSpaces)")
                let day = count - startingSpaces
                totalDays.append("\(day)")
                
                if let validDate = CalendarHelper().calendar.date(byAdding: .day, value: day - 1, to: firstDay) {
                    datesInMonth.append(validDate) // actual Date
                } else {
                    datesInMonth.append(nil)
                }
            }
            count += 1
        }
        
        let monthLabelText = CalendarHelper().monthYearString(date: date)
        let previousMonth = CalendarHelper.shared.getPreviousMonth(from: date)
        let previousMonthText = CalendarHelper().monthName(from: previousMonth)
        let nextMonth = CalendarHelper.shared.getNextMonth(from: date)
        let nextMonthText = CalendarHelper().monthName(from: nextMonth)
        
        calendarDelegate?.previousMonth(nameText: previousMonthText)
        calendarDelegate?.currentMonth(nameText: monthLabelText)
        calendarDelegate?.nextMonth(nameText: nextMonthText)
        
        self.reloadData()
    }
    
    public func reloadCalendarFor(dateValue: Date) {
        selectedDate = dateValue
        setupMonthViewFor(date: selectedDate)
    }
    
    func calculateCalendarHeight(for date: Date) -> CGFloat {
        let weeks = CalendarHelper.shared.numberOfWeeksInMonth(for: date)
        let rowHeight: CGFloat = 48 // Or whatever your cell height is
        let totalHeight = CGFloat(weeks) * rowHeight + CGFloat(weeks) * 2
        return totalHeight
    }
    
    func goToPreviousMonth() {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setupMonthView()
        calendarDelegate?.newCalendarMonth(date: selectedDate)
        /*
        let newHeight = calculateCalendarHeight(for: selectedDate)
        calendarDelegate?.newMonthCalendar(height: newHeight)
        */
    }
    
    func goToNextMonth() {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setupMonthView()
        calendarDelegate?.newCalendarMonth(date: selectedDate)
        /*
        let newHeight = calculateCalendarHeight(for: selectedDate)
        calendarDelegate?.newMonthCalendar(height: newHeight)
        */
    }
    
    func reloadMonthViewFor(selectedNewDate: String) {
        dateSelectedByUserOnMonthCalendar = selectedNewDate
        self.reloadData()        
    }
    
}

// MARK: - UICollectionViewDataSource
extension CollectionViewCalendar: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "RVCalendarCollectionViewCell", for: indexPath) as! RVCalendarCollectionViewCell
        
        cell.viewDateLabelSelection.backgroundColor = .white
        cell.configure(with: totalDays[indexPath.item], index: indexPath.item)
        
        
        if cell.labelDate.text != "" {
            let currentCellDate = getDateForSelectedCell(atIndex: indexPath.item)
            if dictArrayDateEventColors.count > 0 {
                if let arrayColors = dictArrayDateEventColors[currentCellDate] {
                    cell.setEventDateDotsWith(colors: arrayColors)
                }
            }
            if currentCellDate == dateSelectedByUserOnMonthCalendar {
                cell.viewDateLabelSelection.clipsToBounds = true
                cell.viewDateLabelSelection.layer.cornerRadius = cell.viewDateLabelSelection.frame.height / 2.0
                cell.viewDateLabelSelection.backgroundColor = dateSelectionColor
                indexPathForNewSelectedDate = indexPath
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(indexPath.item)
        if let cell = collectionView.cellForItem(at: indexPath) as? RVCalendarCollectionViewCell {
            if cell.labelDate.text != "" {
                cellSelectedToHighlight = indexPath.item
                
                cell.viewDateLabelSelection.clipsToBounds = true
                cell.viewDateLabelSelection.layer.cornerRadius = cell.viewDateLabelSelection.frame.height / 2.0
                cell.viewDateLabelSelection.backgroundColor = dateSelectionColor
                //--
                if indexPathForNewSelectedDate != nil && indexPathForNewSelectedDate != indexPath {
                    if let previousCell = collectionView.cellForItem(at: indexPathForNewSelectedDate!) as? RVCalendarCollectionViewCell {
                        previousCell.viewDateLabelSelection.backgroundColor = .clear
                        indexPathForNewSelectedDate = nil
                    }
                }
                //--
                let selectedDateValue = getDateForSelectedCell(atIndex: indexPath.item)
                //print("Selected Date: \(selectedDateValue)")
                dateSelectedByUserOnMonthCalendar = selectedDateValue
                calendarDelegate?.dateSelected(dateString: selectedDateValue)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        if let cell = collectionView.cellForItem(at: indexPath) as? RVCalendarCollectionViewCell {
            cellSelectedToHighlight = -1
            cell.labelDate.textColor = .black
            cell.viewDateLabelSelection.backgroundColor = .white
        }
    }
    
    func getDateForSelectedCell(atIndex: Int) -> String {
        let day = Int(totalDays[atIndex])!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        
        var dateComponents = DateComponents()
        dateComponents.year = components.year
        dateComponents.month = components.month
        dateComponents.day = day
        
        if let fullDate = calendar.date(from: dateComponents) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            //print("Selected Date: \(formatter.string(from: fullDate))")
            return formatter.string(from: fullDate)
        }
        
        return ""
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewCalendar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 2) / 7
        let height = (collectionView.frame.height - 2) / 6
        return CGSize(width: width, height: height)
    }
}
