//
//  ViewController.swift
//  Calendar
//
//  Created by Jiao Liu on 1/7/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController ,CHDatePickerViewDelegate{
    var resultsLabel : UILabel?
    var isPickerShow : Bool = false
    var pickerView   : CHDatePickerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resultsLabel = UILabel(frame: CGRectMake(0, 100, 320, 44))
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        let dateStr = formatter.stringFromDate(NSDate())
        resultsLabel?.text = dateStr
        resultsLabel?.textAlignment = NSTextAlignment.Center
        resultsLabel?.userInteractionEnabled = true
        self.view.addSubview(resultsLabel!)
        
        let tap = UITapGestureRecognizer(target: self, action: "showPickerView")
        resultsLabel?.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPickerView()
    {
        isPickerShow = !isPickerShow
        if isPickerShow
        {
            pickerView = CHDatePickerView(frame : CGRectMake(0, 0, 430 / 2.0, 470 / 2.0))
            pickerView?.center = self.view.center
            pickerView?.delegate = self
            self.view.addSubview(pickerView!)
        }
        else
        {
            pickerView?.removeFromSuperview()
        }
    }
    
    func selectedDate(date: NSDate) {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy年M月d日"
        resultsLabel?.text = formatter.stringFromDate(date)
    }
}

