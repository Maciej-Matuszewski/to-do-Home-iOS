//
//  TaskMainTableViewCell.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 05.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit

class TaskMainTableViewCell: UITableViewCell {

    let title:UILabel! = UILabel.init()
    let indicator :UIView! = UIView.init()
    let separator :UIView! = UIView.init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = kColorBackground
        
        self.selectionStyle = .None
        
        title.textColor = kColorBlack
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFontOfSize(22)
        self.addSubview(title)
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[item]-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["item" : title]))
        self.addConstraint(NSLayoutConstraint.init(item: title, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 1.0))
        
        separator.backgroundColor = kColorInactive
        separator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separator)
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[separator]|", options: .AlignAllCenterX, metrics: nil, views: ["separator" : separator]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[separator(==1)]|", options: .AlignAllCenterX, metrics: nil, views: ["separator" : separator]))
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.backgroundColor = UIColor.clearColor()
        self.addSubview(indicator)
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[item(==10)]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["item" : indicator]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[item]|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["item" : indicator]))
        
    }
    
    override func prepareForReuse() {
        title.text = ""
        indicator.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
