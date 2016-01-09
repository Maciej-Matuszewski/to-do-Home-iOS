//
//  AddHomeViewController.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 06.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit
import Parse

class AddHomeViewController: UIViewController {

    var homeId:(background: UIImageView, textField: UITextField)!
    var homePassword:(background: UIImageView, textField: UITextField)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kColorPrimary
        
        
        if(DeviceType.IS_IPHONE_4_OR_LESS){
            view.transform = CGAffineTransformMakeScale(0.9, 0.9)
        }
        
        let backgroundImageView = UIImageView.init(image: UIImage.init(named: "homeKey"))
        backgroundImageView.contentMode = .ScaleAspectFit
        backgroundImageView.alpha = 0.25
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundImageView)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==25)-[item]-(==25)-|", options: .AlignAllCenterX, metrics: nil, views: ["item" : backgroundImageView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(==25)-[item]-(==25)-|", options: .AlignAllCenterX, metrics: nil, views: ["item" : backgroundImageView]))
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = NSLocalizedString("Add home", comment: "Add_home_title")
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "backgroundFunc:"))
        
        homeId = generateTextField(NSLocalizedString("Home ID", comment: "prompt_home_id"), keyboardType: .Default, secured: false, controller: self, onEndFunction: "idEndFunc")
        homePassword = generateTextField(NSLocalizedString("Home Password", comment: "prompt_home_password"), keyboardType: .Default, secured: false, controller: self, onEndFunction: "passwordEndFunc")
        
        let connectBtn = generateButton(NSLocalizedString("Connect to home", comment: "prompt_connect_to_home"), function: "connectToHomeFunc",controller: self, color: kColorAccent)
        let createBtn = generateButton(NSLocalizedString("Create home", comment: "prompt_create_home"), function: "createHomeFunc",controller: self, color: kColorAccent)
        
        view.addSubview(homeId.background)
        view.addSubview(homePassword.background)
        view.addSubview(connectBtn)
        view.addSubview(createBtn)
        
        let separator = generateSeparator(kColorWhite, parentView: view)
        
        let orLabel = UILabel.init()
        orLabel.text = NSLocalizedString("OR", comment: "prompt_OR")
        orLabel.textColor = kColorWhite
        orLabel.font = UIFont.boldSystemFontOfSize(20)
        orLabel.backgroundColor = kColorAccent
        orLabel.layer.cornerRadius = 25
        orLabel.clipsToBounds = true
        orLabel.textAlignment = NSTextAlignment.Center
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        
        orLabel.layer.borderWidth = 2
        orLabel.layer.borderColor = kColorWhite.CGColor
        orLabel.clipsToBounds = true
        
        view.addSubview(orLabel)
        
        view .addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[homeId]-[homePassword(==homeId)]-[connectBtn(==homeId)]-(==50)-[separator(==2)]-(==50)-[createBtn(==homeId)]", options: .AlignAllCenterX, metrics: nil, views: ["homeId" : homeId.background, "homePassword" : homePassword.background, "connectBtn" : connectBtn, "createBtn" : createBtn, "separator" : separator]))
        
        view.addConstraint(NSLayoutConstraint.init(item: separator, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 1.0))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[orLabel(==50)]", options: .AlignAllCenterX, metrics: nil, views: ["orLabel" : orLabel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[orLabel(==50)]", options: .AlignAllCenterX, metrics: nil, views: ["orLabel" : orLabel]))
        
        view.addConstraint(NSLayoutConstraint.init(item: orLabel, attribute: .CenterX, relatedBy: .Equal, toItem: separator, attribute: .CenterX, multiplier: 1.0, constant: 1.0))
        view.addConstraint(NSLayoutConstraint.init(item: orLabel, attribute: .CenterY, relatedBy: .Equal, toItem: separator, attribute: .CenterY, multiplier: 1.0, constant: 1.0))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Buttons functions
    
    func backgroundFunc(recognizer:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func connectToHomeFunc(){
        let query = PFQuery(className:"Home")
        query.getObjectInBackgroundWithId(homeId.textField.text!) {
            (home: PFObject?, error: NSError?) -> Void in
            if error == nil && home != nil {
                if(home!["password"] as! String == self.homePassword.textField.text!){
                    PFUser.currentUser()!["home"] = home
                    PFUser.currentUser()?.saveInBackground()
                    self.dismissViewControllerAnimated(true) { () -> Void in
                        
                    }
                }else{
                    UIAlertView.init(title: NSLocalizedString("Error", comment: "Error_title"), message: NSLocalizedString("Password is not correct!", comment: "prompt_password_not_correct"), delegate: nil, cancelButtonTitle: NSLocalizedString("Ok", comment: "prompt_ok")).show()
                }
            } else {
                UIAlertView.init(title: NSLocalizedString("Error", comment: "Error_title"), message: error?.userInfo["error"] as? String, delegate: nil, cancelButtonTitle: NSLocalizedString("Ok", comment: "prompt_ok")).show()
            }
        }
    }
    
    func createHomeFunc(){
        
        
        let yesNoController = YesNoViewController()
        yesNoController.labelText = NSLocalizedString("Are you sure?", comment: "prompt_are_you_sure")
        yesNoController.yesColor = kColorGreen
        yesNoController.noColor = kColorRed
        yesNoController.completionBlock = { (response) -> Void in
            if (response == true){
                
                let home = PFObject(className: "Home")
                
                home["password"] = randomStringWithLength(8)
                
                home.saveInBackgroundWithBlock { (success, error) -> Void in
                    if(success){
                        PFUser.currentUser()!["home"] = home
                        PFUser.currentUser()?.saveInBackground()
                        self.navigationController?.setViewControllers([HomeCreatedViewController()], animated: true)
                    }
                }
                
            }
        }
        self.presentViewController(yesNoController, animated: true, completion: nil)
    }
    
    func idEndFunc(){
        homePassword.textField.becomeFirstResponder()
    }
    
    func passwordEndFunc(){
        self.connectToHomeFunc()
    }
}
