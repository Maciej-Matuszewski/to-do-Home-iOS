//
//  SettingsViewController.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 08.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = kColorPrimary
        
        let backgroundImageView = UIImageView.init(image: UIImage.init(named: "settings"))
        backgroundImageView.contentMode = .ScaleAspectFit
        backgroundImageView.alpha = 0.25
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundImageView)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==25)-[item]-(==25)-|", options: .AlignAllCenterX, metrics: nil, views: ["item" : backgroundImageView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(==25)-[item]-(==25)-|", options: .AlignAllCenterX, metrics: nil, views: ["item" : backgroundImageView]))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleMenu")
        
        view.addGestureRecognizer((UIApplication.sharedApplication().delegate as! AppDelegate).sw.panGestureRecognizer())
        
        navigationItem.title = NSLocalizedString("Settings", comment: "settings_title")
        
        
        let chName = generateButton(NSLocalizedString("Change name", comment: "prompt_change_name"), function: "changeNameFunc", controller: self, color: kColorAccent)
        view.addSubview(chName)
        
        let chEmail = generateButton(NSLocalizedString("Change email", comment: "prompt_change_email"), function: "changeEmailFunc", controller: self, color: kColorAccent)
        view.addSubview(chEmail)
        
        let chPass = generateButton(NSLocalizedString("Change password", comment: "prompt_change_password"), function: "changePasswordFunc", controller: self, color: kColorAccent)
        view.addSubview(chPass)
        
        let logout = generateButton(NSLocalizedString("Logout", comment: "prompt_logout"), function: "logoutFunc", controller: self, color: kColorRed)
        view.addSubview(logout)
        
        let separator = generateSeparator(kColorWhite, parentView: view)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[name]-[email(==name)]-[pass(==name)]-(==15)-[separator(==2)]-(==15)-[logout(==name)]", options: .AlignAllCenterX, metrics: nil, views: ["name" : chName, "email" : chEmail, "pass" : chPass , "logout" : logout, "separator" : separator]))
        
        view.addConstraint(NSLayoutConstraint.init(item: separator, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 1.0))
    }
    
    func toggleMenu(){
        (UIApplication.sharedApplication().delegate as! AppDelegate).sw.revealToggleAnimated(true)
    }
    
    func changeNameFunc(){
        self.navigationController?.pushViewController(ChangeNameViewController(), animated: true)
    }
    
    func changeEmailFunc(){
        self.navigationController?.pushViewController(ChangeEmailViewController(), animated: true)
    }
    
    func changePasswordFunc(){
        self.navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
    }
    
    func logoutFunc(){
        
        let yesNoController = YesNoViewController()
        yesNoController.labelText = NSLocalizedString("Are you sure?", comment: "prompt_are_you_sure")
        yesNoController.yesColor = kColorRed
        yesNoController.completionBlock = { (response) -> Void in
            if (response == true){
                PFUser.logOutInBackgroundWithBlock({ (error) -> Void in
                    (UIApplication.sharedApplication().delegate as! AppDelegate).loadWelcome()
                    let installation = PFInstallation.currentInstallation()
                    installation.removeObjectForKey("user")
                    installation.saveInBackground()
                })
            }
        }
        self.presentViewController(yesNoController, animated: true, completion: nil)
        
        
    }

}
