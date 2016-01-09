//
//  HomeManagerViewController.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 07.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit
import Parse

class HomeManagerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = kColorPrimary
        
        let backgroundImageView = UIImageView.init(image: UIImage.init(named: "homeKey"))
        backgroundImageView.contentMode = .ScaleAspectFit
        backgroundImageView.alpha = 0.25
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundImageView)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==25)-[item]-(==25)-|", options: .AlignAllCenterX, metrics: nil, views: ["item" : backgroundImageView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(==25)-[item]-(==25)-|", options: .AlignAllCenterX, metrics: nil, views: ["item" : backgroundImageView]))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleMenu")
        
        view.addGestureRecognizer((UIApplication.sharedApplication().delegate as! AppDelegate).sw.panGestureRecognizer())
        
        navigationItem.title = NSLocalizedString("Home manager", comment: "home_manager_title")
        
        let idLabel = UILabel.init()
        idLabel.text = NSLocalizedString("Home ID:", comment: "prompt_home_id")
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(idLabel)

        let homeID = generateTextField("", keyboardType: .Default, secured: false, controller: self, onEndFunction: "idEndFunc")
        homeID.textField.enabled = false
        homeID.textField.textAlignment = NSTextAlignment.Center
        homeID.textField.font = UIFont.boldSystemFontOfSize(26)
        view.addSubview(homeID.background)
        
        let pLabel = UILabel.init()
        pLabel.text = NSLocalizedString("Home password:", comment: "prompt_home_password")
        pLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pLabel)
        
        let homeP = generateTextField("", keyboardType: .Default, secured: false, controller: self, onEndFunction: "passEndFunc")
        homeP.textField.enabled = false
        homeP.textField.textAlignment = NSTextAlignment.Center
        homeP.textField.font = UIFont.boldSystemFontOfSize(26)
        view.addSubview(homeP.background)
        
        view.addConstraint(NSLayoutConstraint.init(item: homeID.background, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 1.0))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[idLabel][homeId]-[pLabel(==idLabel)][homeP(==homeId)]", options: .AlignAllLeft, metrics: nil, views: ["idLabel" : idLabel, "homeId" : homeID.background, "pLabel" : pLabel, "homeP" : homeP.background]))
        
        PFUser.currentUser()!["home"].fetchInBackgroundWithBlock { (home, error) -> Void in
            
            homeID.textField.text = home?.objectId
            homeP.textField.text = home?["password"] as? String
        }
        let tasksManagerBtn = generateButton(NSLocalizedString("Tasks manager", comment: "prompt_tasks_manager"), function: "taskManagerBtnFunc", controller: self, color: kColorAccent)
        view.addSubview(tasksManagerBtn)
        
        
        let disconnectBtn = generateButton(NSLocalizedString("Disconnect", comment: "prompt_disconnect"), function: "disconnectBtnFunc", controller: self, color: kColorRed)
        view.addSubview(disconnectBtn)
        
        let separator = generateSeparator(kColorWhite, parentView: view)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[homeP]-(==15)-[s1(==2)]-(==15)-[taskManagerBtn(==homeP)]-(==15)-[s2(==2)]-(==15)-[disconnectBtn(==homeP)]", options: .AlignAllCenterX, metrics: nil, views: ["homeP" : homeP.background, "s1" : separator, "s2" : generateSeparator(kColorWhite, parentView: view), "taskManagerBtn" : tasksManagerBtn, "disconnectBtn" : disconnectBtn]))
        
        view.addConstraint(NSLayoutConstraint.init(item: separator, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 1.0))
    }

    func taskManagerBtnFunc(){
        self.navigationController?.pushViewController(TasksManagerViewController(), animated: true)
    }

    func disconnectBtnFunc(){
        
        let yesNoController = YesNoViewController()
        yesNoController.labelText = NSLocalizedString("Are you sure?", comment: "prompt_are_you_sure")
        yesNoController.yesColor = kColorRed
        yesNoController.completionBlock = { (response) -> Void in
            if (response == true){
                PFUser.currentUser()?.removeObjectForKey("home")
                PFUser.currentUser()?.saveInBackgroundWithBlock({ (user, error) -> Void in
                    (UIApplication.sharedApplication().delegate as! AppDelegate).navi.setViewControllers([MainViewController()], animated: false)
                })
            }
        }
        self.presentViewController(yesNoController, animated: true, completion: nil)
        
    }
    
    func toggleMenu(){
        (UIApplication.sharedApplication().delegate as! AppDelegate).sw.revealToggleAnimated(true)
    }
    
    func idEndFunc(){
    }
    func passEndFunc(){
    }
}
