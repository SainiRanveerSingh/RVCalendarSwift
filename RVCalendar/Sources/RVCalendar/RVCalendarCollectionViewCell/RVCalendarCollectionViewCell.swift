//
//  RVCalendarCollectionViewCell.swift
//  RVCalendar
//
//  Created by RV on 26/07/25.
//

import UIKit

class RVCalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewMainCellBackground: UIView!
    @IBOutlet weak var viewDateLabelSelection: UIView!
    @IBOutlet weak var viewDateLabelBackground: UIView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var viewToShowFourEventDots: UIView!
    @IBOutlet weak var imageViewDateHighlighter: UIImageView!
    
    @IBOutlet weak var viewMainDateEventDots: UIView!
    @IBOutlet weak var widthLayoutForViewMainDateEventDots: NSLayoutConstraint!
    @IBOutlet weak var viewDateEventDotOne: UIView!
    @IBOutlet weak var viewDateEventDotTwo: UIView!
    @IBOutlet weak var viewDateEventDotThree: UIView!
    @IBOutlet weak var viewDateEventDotFour: UIView!
    @IBOutlet weak var viewDateEventDotFive: UIView!
    
    @IBOutlet weak var widthLayoutForViewDateEventDotOne: NSLayoutConstraint!
    @IBOutlet weak var widthLayoutForViewDateEventDotTwo: NSLayoutConstraint!
    @IBOutlet weak var widthLayoutForViewDateEventDotThree: NSLayoutConstraint!
    @IBOutlet weak var widthLayoutForViewDateEventDotFour: NSLayoutConstraint!
    @IBOutlet weak var widthLayoutForViewDateEventDotFive: NSLayoutConstraint!
    
    var cellColor = UIColor.white
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.initialSetup()
        }
    }
    
    func initialSetup() {
        //viewDateLabelBackground.backgroundColor = cellColor
        viewDateLabelBackground.layer.cornerRadius = viewDateLabelBackground.frame.size.height / 2.0
        
        viewMainDateEventDots.isHidden = true
        viewDateEventDotOne.layer.cornerRadius = viewDateEventDotOne.frame.size.height / 2.0
        viewDateEventDotTwo.layer.cornerRadius = viewDateEventDotTwo.frame.size.height / 2.0
        viewDateEventDotThree.layer.cornerRadius = viewDateEventDotThree.frame.size.height / 2.0
        viewDateEventDotFour.layer.cornerRadius = viewDateEventDotFour.frame.size.height / 2.0
        viewDateEventDotFive.layer.cornerRadius = viewDateEventDotFive.frame.size.height / 2.0
        
        viewDateEventDotOne.isHidden = true
        viewDateEventDotTwo.isHidden = true
        viewDateEventDotThree.isHidden = true
        viewDateEventDotFour.isHidden = true
        viewDateEventDotFive.isHidden = true
    }
    
    func configure(with day: String, index: Int) {
        labelDate.text = day
        labelDate.tag = 1000 + index
        viewDateLabelBackground.tag = 2000 + index
        viewToShowFourEventDots.tag = 3000 + index
        imageViewDateHighlighter.tag = 4000 + index
        
        viewMainDateEventDots.isHidden = true
        viewDateEventDotOne.isHidden = true
        viewDateEventDotTwo.isHidden = true
        viewDateEventDotThree.isHidden = true
        viewDateEventDotFour.isHidden = true
        viewDateEventDotFive.isHidden = true
    }
    
    func setEventDateDotsWith(colors: [UIColor]) {
        viewMainDateEventDots.isHidden = false
        
        let dotArray = [viewDateEventDotOne, viewDateEventDotTwo, viewDateEventDotThree, viewDateEventDotFour, viewDateEventDotFive]
        for i in 0..<colors.count {
            if i < dotArray.count {
                switch i {
                case 0:
                    viewDateEventDotOne.backgroundColor = colors[i]
                    viewDateEventDotOne.isHidden = false
                    //4 Lead Space + 5 + 4 Trail Space
                    widthLayoutForViewMainDateEventDots.constant = 13
                    widthLayoutForViewDateEventDotOne.constant = 5
                    widthLayoutForViewDateEventDotTwo.constant = 0
                    widthLayoutForViewDateEventDotThree.constant = 0
                    widthLayoutForViewDateEventDotFour.constant = 0
                    widthLayoutForViewDateEventDotFive.constant = 0
                case 1:
                    viewDateEventDotTwo.backgroundColor = colors[i]
                    viewDateEventDotTwo.isHidden = false
                    //4 Lead Space + 5 + 4 Space Between + 5 + 4 Trail Space
                    widthLayoutForViewMainDateEventDots.constant = 22
                    widthLayoutForViewDateEventDotOne.constant = 5
                    widthLayoutForViewDateEventDotTwo.constant = 5
                    widthLayoutForViewDateEventDotThree.constant = 0
                    widthLayoutForViewDateEventDotFour.constant = 0
                    widthLayoutForViewDateEventDotFive.constant = 0
                case 2:
                    viewDateEventDotThree.backgroundColor = colors[i]
                    viewDateEventDotThree.isHidden = false
                    //4 Lead Space + 5 + 4 + 5 + 4 + 5 + 4 Trail Space
                    widthLayoutForViewMainDateEventDots.constant = 31
                    widthLayoutForViewDateEventDotOne.constant = 5
                    widthLayoutForViewDateEventDotTwo.constant = 5
                    widthLayoutForViewDateEventDotThree.constant = 5
                    widthLayoutForViewDateEventDotFour.constant = 0
                    widthLayoutForViewDateEventDotFive.constant = 0
                case 3:
                    viewDateEventDotFour.backgroundColor = colors[i]
                    viewDateEventDotFour.isHidden = false
                    //4 Lead Space + 5 + 4 + 5 + 4 + 5 + 4 + 5 + 4 Trail Space
                    widthLayoutForViewMainDateEventDots.constant = 40
                    widthLayoutForViewDateEventDotOne.constant = 5
                    widthLayoutForViewDateEventDotTwo.constant = 5
                    widthLayoutForViewDateEventDotThree.constant = 5
                    widthLayoutForViewDateEventDotFour.constant = 5
                    widthLayoutForViewDateEventDotFive.constant = 0
                case 4:
                    viewDateEventDotFive.backgroundColor = colors[i]
                    viewDateEventDotFive.isHidden = false
                    //4 Lead Space + 5 + 4 + 5 + 4 + 5 + 4 + 5 + 4 + 5 + 4 Trail Space
                    widthLayoutForViewMainDateEventDots.constant = 49
                    widthLayoutForViewDateEventDotOne.constant = 5
                    widthLayoutForViewDateEventDotTwo.constant = 5
                    widthLayoutForViewDateEventDotThree.constant = 5
                    widthLayoutForViewDateEventDotFour.constant = 5
                    widthLayoutForViewDateEventDotFive.constant = 5
                default:
                    break
                }
            }
        }
    }
    
}
