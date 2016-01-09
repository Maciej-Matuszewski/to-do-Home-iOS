//
//  TaskDoneTableViewCell.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 07.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit

class TaskDoneTableViewCell: UITableViewCell {

    let title:UILabel! = UILabel.init()
    let subtitle:UILabel! = UILabel.init()
    let indicator :UIView! = UIView.init()
    let separator :UIView! = UIView.init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
        
        backgroundColor = kColorBackground
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFontOfSize(18)
        title.textColor = kColorBlack
        self.addSubview(title)
        
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.font = UIFont.systemFontOfSize(14)
        subtitle.textColor = kColorBlack
        self.addSubview(subtitle)
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[item]-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["item" : title]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[item]-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["item" : subtitle]))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[title][subtitle]-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["title" : title, "subtitle" : subtitle]))
        
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
        subtitle.text = ""
        indicator.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
