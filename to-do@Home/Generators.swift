//
//  Generators.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 06.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import Foundation
import UIKit
import Parse

// MARK: - Generators UI Elements

func generateTextField(placeholder: String, keyboardType: UIKeyboardType, secured: Bool, controller: UIViewController, onEndFunction: Selector) -> (background: UIImageView, textField: UITextField){
    
    let background = UIImageView.init(image: UIImage.init(named: "button_background")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
    background.translatesAutoresizingMaskIntoConstraints = false
    background.tintColor = kColorWhite
    background.userInteractionEnabled = true
    
    let textField = UITextField.init()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.tintColor = kColorAccent
    textField.textColor = kColorAccent
    textField.userInteractionEnabled = true
    textField.placeholder = placeholder
    textField.keyboardType = keyboardType
    textField.secureTextEntry = secured
    textField.autocorrectionType = UITextAutocorrectionType.No
    textField.autocapitalizationType = UITextAutocapitalizationType.None
    textField.addTarget(controller, action: onEndFunction, forControlEvents: .EditingDidEndOnExit)
    background.addSubview(textField)
    
    background.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[textField]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["textField" : textField]))
    
    background.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[textField]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["textField" : textField]))
    
    
    background.layer.borderWidth = 2
    background.layer.borderColor = kColorAccent.CGColor
    background.layer.cornerRadius = 5
    background.clipsToBounds = true
    
    return (background, textField)
}

func generateButton(title:String, function:Selector, controller: UIViewController, color: UIColor) ->UIButton{
    let button = UIButton.init();
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setBackgroundImage(UIImage.init(named: "button_background")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
    button.tintColor = color
    button.setTitle(title, forState: .Normal)
    button.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
    button.addTarget(controller, action: function, forControlEvents: UIControlEvents.TouchUpInside)
    
    button.layer.borderWidth = 2
    button.layer.borderColor = kColorWhite.CGColor
    button.layer.cornerRadius = 5
    button.clipsToBounds = true
    
    return button
}

func generateMenuButton(icon: String, title: String, function: Selector, controller: UIViewController) ->UIButton{
    let button = UIButton.init()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setBackgroundImage(UIImage.init(named: "button_background")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
    button.tintColor = kColorDark
    button.addTarget(controller, action: function, forControlEvents: .TouchUpInside)
    
    let imageView = UIImageView.init(image: UIImage.init(named: icon))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    button.addSubview(imageView)
    
    let label = UILabel.init()
    label.text = title
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = kColorWhite
    label.font = UIFont.boldSystemFontOfSize(18)
    button.addSubview(label)
    
    button.addConstraint(NSLayoutConstraint.init(item: imageView, attribute: .CenterY, relatedBy: .Equal, toItem: button, attribute: .CenterY, multiplier: 1.0, constant: 1.0))
    
    button.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[imageView(==25)]-[label]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["imageView" : imageView, "label" : label]))
    
    button.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[imageView(==25)]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["imageView" : imageView]))
    
    button.layer.borderWidth = 2
    button.layer.borderColor = kColorWhite.CGColor
    button.layer.cornerRadius = 5
    button.clipsToBounds = true
    
    return button
}

func generateTabBarItem(title: String, imageName: String) -> UITabBarItem{
    let item = UITabBarItem.init(title: title, image: UIImage.init(named: imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), selectedImage:  UIImage.init(named: imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
    
    item.setTitleTextAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(12)], forState: .Normal)
    
    return item
}

func configTableView(tableView : UITableView, cellIdentifier : String, background : UIView, view : UIView, controller : UIViewController, refreshControl : UIRefreshControl, backgroundImageName : String, cellClass : AnyClass) -> UITableView{
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.registerClass(cellClass.self, forCellReuseIdentifier: cellIdentifier)
    
    tableView.separatorStyle = .None
    
    background.backgroundColor = kColorPrimary
    background.translatesAutoresizingMaskIntoConstraints = false
    
    let backgroundImageView = UIImageView.init(image: UIImage.init(named: backgroundImageName))
    backgroundImageView.contentMode = .ScaleAspectFit
    backgroundImageView.alpha = 0.25
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    
    background.addSubview(backgroundImageView)
    background.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==25)-[item]-(==25)-|", options: .AlignAllCenterX, metrics: nil, views: ["item" : backgroundImageView]))
    background.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(==25)-[item]-(==25)-|", options: .AlignAllCenterX, metrics: nil, views: ["item" : backgroundImageView]))
    
    view.addSubview(background)
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[item]|", options: .AlignAllCenterX, metrics: nil, views: ["item" : background]))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[item]|", options: .AlignAllCenterX, metrics: nil, views: ["item" : background]))
    
    background.addSubview(tableView)
    
    background.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["tableView" : tableView]))
    background.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["tableView" : tableView]))
    
    refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: "prompt_pull_to_refresh"))
    refreshControl.tintColor = kColorAccent
    refreshControl.addTarget(controller, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    tableView.addSubview(refreshControl)
    
    tableView.backgroundColor = UIColor.clearColor()
    
    return tableView
}

func configTableViewWithoutConstriant(tableView : UITableView, cellIdentifier : String, background : UIView, view : UIView, controller : UIViewController, refreshControl : UIRefreshControl, backgroundImageName : String, cellClass : AnyClass) -> UITableView{
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.registerClass(cellClass.self, forCellReuseIdentifier: cellIdentifier)
    
    tableView.separatorStyle = .None
    
    background.backgroundColor = kColorPrimary
    background.translatesAutoresizingMaskIntoConstraints = false
    
    let backgroundImageView = UIImageView.init(image: UIImage.init(named: backgroundImageName))
    backgroundImageView.contentMode = .ScaleAspectFit
    backgroundImageView.alpha = 0.25
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    
    background.addSubview(backgroundImageView)
    background.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==25)-[item]-(==25)-|", options: .AlignAllCenterX, metrics: nil, views: ["item" : backgroundImageView]))
    background.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(==25)-[item]-(==25)-|", options: .AlignAllCenterX, metrics: nil, views: ["item" : backgroundImageView]))
    
    view.addSubview(background)
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[item]|", options: .AlignAllCenterX, metrics: nil, views: ["item" : background]))
    
    background.addSubview(tableView)
    
    background.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["tableView" : tableView]))
    background.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["tableView" : tableView]))
    
    refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: "prompt_pull_to_refresh"))
    refreshControl.tintColor = kColorAccent
    refreshControl.addTarget(controller, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    tableView.addSubview(refreshControl)
    
    tableView.backgroundColor = UIColor.clearColor()
    
    return tableView
}

func generateSeparator(color : UIColor, parentView : UIView) -> UIView{
    let separator = UIView.init()
    separator.backgroundColor = color
    separator.translatesAutoresizingMaskIntoConstraints = false
    parentView.addSubview(separator)
    parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[separator]-|", options: [], metrics: nil, views: ["separator" : separator]))
    
    return separator
}

func generateFeedItem(type: String, objectTitle: String){
    let item = PFObject(className: "Feed")
    item["type"] = type
    item["objectTitle"] = objectTitle
    item["user"] = PFUser.currentUser()
    item["userName"] = PFUser.currentUser()!["name"]
    item["home"] = PFUser.currentUser()!["home"]
    item.saveInBackground()
}

func generateFeedItem(type: String, objectTitle: String, objectUserName: String){
    let item = PFObject(className: "Feed")
    item["type"] = type
    item["objectTitle"] = objectTitle
    item["objectUserName"] = objectUserName
    item["user"] = PFUser.currentUser()
    item["userName"] = PFUser.currentUser()!["name"]
    item["home"] = PFUser.currentUser()!["home"]
    item.saveInBackground()
}

// MARK: - Support function

func daysBetweenDateAndNow(endDate: NSDate) -> Int
{
    let calendar = NSCalendar.currentCalendar()
    
    let components = calendar.components([.Day], fromDate: NSDate(), toDate: endDate, options: [])
    
    return components.day
}

func randomStringWithLength (len : Int) -> NSString {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    let randomString : NSMutableString = NSMutableString(capacity: len)
    
    for (var i=0; i < len; i++){
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
    }
    
    return randomString
}