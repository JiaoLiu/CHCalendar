//
//  CHDateCell.swift
//  Calendar
//
//  Created by Jiao Liu on 1/8/15.
//  Copyright (c) 2015 Jiao Liu. All rights reserved.
//

import UIKit

class CHDateCell: UICollectionViewCell {
    var textLabel : UILabel?
    var indicatorView : UIImageView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        indicatorView = UIImageView(frame: CGRectMake(0, 0, frame.width, frame.height))
        indicatorView?.image = UIImage(named: "backImg")
        indicatorView?.center = CGPointMake(frame.width / 2.0, frame.height / 2.0)
        indicatorView?.hidden = true
        self.contentView.addSubview(indicatorView!)
        
        textLabel = UILabel(frame: CGRectMake(0, 0, frame.width, frame.height))
        textLabel?.backgroundColor = UIColor.clearColor()
        textLabel?.textAlignment = NSTextAlignment.Center
        self.contentView.addSubview(textLabel!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
