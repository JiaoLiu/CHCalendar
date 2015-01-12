//
//  CHDatePickerView.swift
//  Calendar
//
//  Created by Jiao Liu on 1/7/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

import UIKit
import Foundation

protocol CHDatePickerViewDelegate
{
    func selectedDate(date : NSDate)
}

class CHDatePickerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var calendarView : UICollectionView?
    var topDateLabel : UILabel?
    var currentDate  : NSDate = NSDate()
    var weekArr      : NSArray = ["周一","周二","周三","周四","周五","周六","周日"]
    var dateArr      : NSMutableArray = NSMutableArray()
    var delegate     : CHDatePickerViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareDateArray()
        
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 0.5
        initTopBar(CGRectMake(0, 0, frame.width, 78 / 2.0))
        initCalendarView(CGRectMake(0, 78 / 2.0, frame.width, frame.height - 78 / 2.0))
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init TopBar
    func initTopBar(frame : CGRect)
    {
        let topView = UIView(frame: frame)
        topView.backgroundColor = UIColor.redColor()
        self.addSubview(topView)
        
        topDateLabel = UILabel(frame: CGRectMake(0, 0, frame.width - 100, frame.height))
        topDateLabel?.textColor = UIColor.whiteColor()
        topDateLabel?.textAlignment = NSTextAlignment.Center
        topDateLabel?.center = topView.center
        var formatter = NSDateFormatter()
        formatter.dateFormat = "M月yyyy"
        topDateLabel?.text = formatter.stringFromDate(currentDate)
        topView.addSubview(topDateLabel!)
        
        let leftBtn = UIButton(frame: CGRectMake(0, 0, 50, frame.height))
        leftBtn.addTarget(self, action: "leftBtnClicked", forControlEvents: UIControlEvents.TouchUpInside)
        leftBtn.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        topView.addSubview(leftBtn)
        
        let rightBtn = UIButton(frame: CGRectMake(frame.width - 50, 0, 50, frame.height))
        rightBtn.setImage(UIImage(named: "forward"), forState: UIControlState.Normal)
        rightBtn.addTarget(self, action: "rightBtnClicked", forControlEvents: UIControlEvents.TouchUpInside)
        topView.addSubview(rightBtn)
    }
    
    func leftBtnClicked()
    {
        currentDate = dateInPreviousMonth(currentDate)
        var formatter = NSDateFormatter()
        formatter.dateFormat = "M月yyyy"
        topDateLabel?.text = formatter.stringFromDate(currentDate)
        prepareDateArray()
        calendarView?.reloadData()
    }
    
    func rightBtnClicked()
    {
        currentDate = dateInNextMonth(currentDate)
        var formatter = NSDateFormatter()
        formatter.dateFormat = "M月yyyy"
        topDateLabel?.text = formatter.stringFromDate(currentDate)
        prepareDateArray()
        calendarView?.reloadData()
    }
    
    // MARK: - Init CalendarView
    func initCalendarView(frame : CGRect)
    {
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        calendarView = UICollectionView(frame: frame, collectionViewLayout: layout)
        calendarView?.registerClass(CHDateCell.classForCoder(), forCellWithReuseIdentifier: "Date_Cell")
        calendarView?.dataSource = self
        calendarView?.delegate = self
        calendarView?.backgroundColor = UIColor.whiteColor()
        self.addSubview(calendarView!)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberofWeeksInDate(currentDate) + 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Date_Cell", forIndexPath: indexPath) as CHDateCell
        if indexPath.section == 0
        {
            cell.textLabel?.text = weekArr.objectAtIndex(indexPath.row) as? String
            cell.textLabel?.font = UIFont.systemFontOfSize(12.0)
            if indexPath.row < 5
            {
                cell.textLabel?.textColor = UIColor.lightGrayColor()
            }
            else
            {
                cell.textLabel?.textColor = UIColor(red: 242 / 255.0, green: 173 / 255.0, blue: 83 / 255.0, alpha: 1.0)
            }
        }
        else
        {
            let item = dateArr.objectAtIndex((indexPath.section - 1) * 7 + indexPath.row) as NSDictionary
            let date = item.objectForKey("date") as NSDate
            let isCurrentMonth  = item.objectForKey("isCurentMonth") as Bool
            if isCurrentMonth
            {
                cell.textLabel?.textColor = UIColor.blackColor()
            }
            else
            {
                cell.textLabel?.textColor = UIColor.lightGrayColor()
            }
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if formatter.stringFromDate(NSDate()) == formatter.stringFromDate(date)
            {
                cell.indicatorView?.hidden = false
            }
            else
            {
                cell.indicatorView?.hidden = true
            }
            var components = NSCalendar.currentCalendar().components((NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit), fromDate: date)
            cell.textLabel?.text = String(format: "%d", components.day)
            cell.textLabel?.font = UIFont.systemFontOfSize(14.0)
            
            let selectionView = UIView(frame: CGRectMake(0, 0, cell.frame.width, cell.frame.height))
            selectionView.backgroundColor = UIColor.lightGrayColor()
            selectionView.layer.cornerRadius = cell.frame.width / 2.0
            cell.selectedBackgroundView = selectionView
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!){
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        if indexPath.section != 0
        {
            let item = dateArr.objectAtIndex((indexPath.section - 1) * 7 + indexPath.row) as NSDictionary
            delegate?.selectedDate(item.objectForKey("date") as NSDate)
            let isCurrentMonth  = item.objectForKey("isCurentMonth") as Bool
            self.removeFromSuperview()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(27, 27)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        var topInset : CGFloat = 0
        switch numberofWeeksInDate(currentDate) + 1
        {
        case 5:
            topInset = 10
            break
        case 6 :
            topInset = 5
            break
        default :
            topInset = 1
            break
            
        }
        return UIEdgeInsetsMake(topInset, 5, 0, 5);
    }
    
    //  MARK: - DateCalculator
    
    func numOfDaysInDate(currentDate : NSDate) -> NSInteger
    {
        return NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.DayCalendarUnit, inUnit: NSCalendarUnit.MonthCalendarUnit, forDate: currentDate).length
    }
    
    func firstDayOfDateInWeek(currentDate : NSDate) -> NSInteger
    {
        var startDate : NSDate
        var components = NSCalendar.currentCalendar().components((NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit), fromDate: currentDate)
        components.setValue(1, forComponent: NSCalendarUnit.DayCalendarUnit)
        startDate = NSCalendar.currentCalendar().dateFromComponents(components)!
        return NSCalendar.currentCalendar().ordinalityOfUnit(NSCalendarUnit.DayCalendarUnit, inUnit: NSCalendarUnit.WeekCalendarUnit, forDate: startDate);
    }
    
    func numberofWeeksInDate(currentDate : NSDate) -> NSInteger
    {
        var weeks : NSInteger = 0
        var weekDay = firstDayOfDateInWeek(currentDate)
        weekDay = weekDay - 1 == 0 ? 7 : weekDay - 1
        var days = numOfDaysInDate(currentDate)
        weeks += 1
        days -= 7 - weekDay + 1
        weeks += days / 7
        weeks += days % 7 > 0 ? 1 : 0
        return weeks
    }
    
    func dateInPreviousMonth(currentDate : NSDate) -> NSDate
    {
        var components = NSCalendar.currentCalendar().components((NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit), fromDate: currentDate)
        if components.month == 1
        {
            components.setValue(12, forComponent: NSCalendarUnit.MonthCalendarUnit)
            components.setValue(components.year - 1, forComponent: NSCalendarUnit.YearCalendarUnit)
        }
        else
        {
            components.setValue(components.month - 1, forComponent: NSCalendarUnit.MonthCalendarUnit)
        }
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    
    func dateInNextMonth(currentDate : NSDate) -> NSDate
    {
        var components = NSCalendar.currentCalendar().components((NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit), fromDate: currentDate)
        if components.month == 12
        {
            components.setValue(1, forComponent: NSCalendarUnit.MonthCalendarUnit)
            components.setValue(components.year + 1, forComponent: NSCalendarUnit.YearCalendarUnit)
        }
        else
        {
            components.setValue(components.month + 1, forComponent: NSCalendarUnit.MonthCalendarUnit)
        }
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    
    
    func prepareDateArray()
    {
        dateArr.removeAllObjects()
        getPreMonthDates(currentDate)
        getCurrentMonthDates(currentDate)
        getNextMonthDates(currentDate)
    }
    
    func getPreMonthDates(currentDate : NSDate)
    {
        var weekDay = firstDayOfDateInWeek(currentDate)
        weekDay = weekDay - 1 == 0 ? 7 : weekDay - 1
        var preDate = dateInPreviousMonth(currentDate)
        let totalDays = numOfDaysInDate(preDate)
        for index in 0 ..< weekDay - 1
        {
            var components = NSCalendar.currentCalendar().components((NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit), fromDate: preDate)
            components.setValue(totalDays - index, forComponent: NSCalendarUnit.DayCalendarUnit)
            var addDate = NSCalendar.currentCalendar().dateFromComponents(components)
            var dic = NSMutableDictionary()
            dic.setObject(addDate!, forKey: "date")
            dic.setObject(false, forKey: "isCurentMonth")
            dateArr.addObject(dic)
        }
        dateArr = NSMutableArray(array: dateArr.reverseObjectEnumerator().allObjects)
    }
    
    func getCurrentMonthDates(currentDate : NSDate)
    {
        let totalDays = numOfDaysInDate(currentDate)
        for index in 1 ... totalDays
        {
            var components = NSCalendar.currentCalendar().components((NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit), fromDate: currentDate)
            components.setValue(index, forComponent: NSCalendarUnit.DayCalendarUnit)
            var addDate = NSCalendar.currentCalendar().dateFromComponents(components)
            var dic = NSMutableDictionary()
            dic.setObject(addDate!, forKey: "date")
            dic.setObject(true, forKey: "isCurentMonth")
            dateArr.addObject(dic)
        }
    }
    
    func getNextMonthDates(currentDate : NSDate)
    {
        var nextDate = dateInNextMonth(currentDate)
        var weekDay = firstDayOfDateInWeek(nextDate)
        weekDay = weekDay - 1 == 0 ? 7 : weekDay - 1
        if weekDay == 1
        {
            return
        }
        else
        {
            for index in 1 ... 8 - weekDay
            {
                var components = NSCalendar.currentCalendar().components((NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit), fromDate: nextDate)
                components.setValue(index, forComponent: NSCalendarUnit.DayCalendarUnit)
                var addDate = NSCalendar.currentCalendar().dateFromComponents(components)
                var dic = NSMutableDictionary()
                dic.setObject(addDate!, forKey: "date")
                dic.setObject(false, forKey: "isCurentMonth")
                dateArr.addObject(dic)
            }
        }
    }
}
