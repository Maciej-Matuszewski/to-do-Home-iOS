//
//  HomeCreatedViewController.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 08.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit
import Parse

class HomeCreatedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = kColorPrimary
        navigationItem.title = NSLocalizedString("Congratulations!", comment: "congratulations_title")
        
        let backgroundImageView = UIImageView.init(image: UIImage.init(named: "homeKey"))
        backgroundImageView.contentMode = .ScaleAspectFit
        backgroundImageView.alpha = 0.25
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundImageView)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==25)-[item]-(==140)-|", options: .AlignAllCenterX, metrics: nil, views: ["item" : backgroundImageView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(==25)-[item]-(==25)-|", options: .AlignAllCenterX, metrics: nil, views: ["item" : backgroundImageView]))
        
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Your home has been created", comment: "prompt_home_created")
        label.textColor = kColorWhite
        label.textAlignment = NSTextAlignment.Center
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFontOfSize(32)
        
        view.addSubview(label)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==100)-[label]", options: [], metrics: nil, views: ["label" : label]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: ["label" : label]))
        
        let idLabel = UILabel.init()
        idLabel.text = NSLocalizedString("Home ID:", comment: "prompt_home_id")
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(idLabel)
        
        let homeID = generateTextField("", keyboardType: .Default, secured: false, controller: self, onEndFunction: "end")
        homeID.textField.enabled = false
        homeID.textField.textAlignment = NSTextAlignment.Center
        homeID.textField.font = UIFont.boldSystemFontOfSize(26)
        view.addSubview(homeID.background)
        
        let pLabel = UILabel.init()
        pLabel.text = NSLocalizedString("Home password:", comment: "prompt_home_password")
        pLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pLabel)
        
        let homeP = generateTextField("", keyboardType: .Default, secured: false, controller: self, onEndFunction: "end")
        homeP.textField.enabled = false
        homeP.textField.textAlignment = NSTextAlignment.Center
        homeP.textField.font = UIFont.boldSystemFontOfSize(26)
        view.addSubview(homeP.background)
        
        view.addConstraint(NSLayoutConstraint.init(item: homeID.background, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 1.0))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[idLabel]", options: [], metrics: nil, views: ["label" : label, "idLabel" : idLabel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[idLabel][homeId]-[pLabel(==idLabel)][homeP(==homeId)]", options: .AlignAllLeft, metrics: nil, views: ["idLabel" : idLabel, "homeId" : homeID.background, "pLabel" : pLabel, "homeP" : homeP.background]))
        
        PFUser.currentUser()!["home"].fetchInBackgroundWithBlock { (home, error) -> Void in
            
            homeID.textField.text = home?.objectId
            homeP.textField.text = home?["password"] as? String
        }
        
        let okBtn = generateButton(NSLocalizedString("OK", comment: "prompt_ok"), function: "okBtnFunc", controller: self, color: kColorAccent)
        view.addSubview(okBtn)
        
        view.addConstraint(NSLayoutConstraint.init(item: okBtn, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 1.0))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[item]-(==20)-|", options: [], metrics: nil, views: ["item" : okBtn]))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func okBtnFunc(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func end(){
    }

}
