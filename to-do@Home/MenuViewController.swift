//
//  MenuViewController.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 05.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit
import Parse

class MenuViewController: UIViewController {
    
    var main: MainViewController!
    var summary: SummaryTabBarController!
    var homeManager: HomeManagerViewController!
    var settings: SettingsViewController!
    
    let name = UILabel.init()
    let email = UILabel.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kColorPrimary
        
        let container = UIView.init()
        container.backgroundColor = kColorDark
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        
        let now = generateMenuButton("now", title: NSLocalizedString("Now", comment: "prompt_now"), function:"nowFunc", controller: self)
        let summary = generateMenuButton("summary", title: NSLocalizedString("Summary", comment: "prompt_summary"), function:"summaryFunc", controller: self)
        let homeManager = generateMenuButton("home", title: NSLocalizedString("Home manager", comment: "prompt_home_manager"), function: "homeManagerFunc", controller: self)
        let settings = generateMenuButton("settings", title: NSLocalizedString("Settings", comment: "prompt_settings"), function: "settingsFunc", controller: self)
        let share = generateMenuButton("share", title: NSLocalizedString("Share", comment: "prompt_share"), function: "shareFunc", controller: self)
        
        view.addSubview(now)
        view.addSubview(summary)
        view.addSubview(homeManager)
        view.addSubview(settings)
        view.addSubview(share)
        
        let separator = UIView.init()
        separator.backgroundColor = kColorWhite
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator)
        
        
        view .addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[separator(==view)]", options: .AlignAllCenterX, metrics: nil, views: ["separator" : separator, "view" : view]))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[container]|", options: .AlignAllCenterX, metrics: nil, views: ["container" : container]))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[container(==150)][separator(==2)]-(==20)-[now]-[summary]-[homeManager]-[settings]-[share]", options: .AlignAllCenterX, metrics: nil, views: ["container" : container,"separator" : separator, "now" : now, "summary" : summary, "homeManager" : homeManager, "settings" : settings, "share" : share]))
        
        let logo = UIImageView.init(image: UIImage.init(named: "logo_text_white"))
        logo.contentMode = .ScaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(logo)
        
        
        name.text = PFUser.currentUser()!["name"] as? String
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = kColorWhite
        name.font = UIFont.boldSystemFontOfSize(16)
        container.addSubview(name)
        
        email.text = PFUser.currentUser()!.email
        email.translatesAutoresizingMaskIntoConstraints = false
        email.textColor = kColorWhite
        email.font = UIFont.systemFontOfSize(14)
        container.addSubview(email)
        
        container.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[logo]-(==100)-|", options: .AlignAllLeft, metrics: nil, views: ["logo" : logo]))
        container.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==30)-[logo(>=50)]-[name(==20)]-[email(==10)]-(==10)-|", options: .AlignAllLeft, metrics: nil, views: ["logo" : logo, "name" : name, "email" : email]))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        name.text = PFUser.currentUser()!["name"] as? String
        email.text = PFUser.currentUser()!.email
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func nowFunc(){
        if(main == nil){
            main = MainViewController()
        }
        (UIApplication.sharedApplication().delegate as! AppDelegate).navi.setViewControllers([main], animated: false)
        (UIApplication.sharedApplication().delegate as! AppDelegate).sw.revealToggleAnimated(true)
    }
    
    func summaryFunc(){
        if(summary == nil){
            summary = SummaryTabBarController()
        }
        (UIApplication.sharedApplication().delegate as! AppDelegate).navi.setViewControllers([summary], animated: false)
        (UIApplication.sharedApplication().delegate as! AppDelegate).sw.revealToggleAnimated(true)
    }
    func homeManagerFunc(){
        if(homeManager == nil){
            homeManager = HomeManagerViewController()
        }
        (UIApplication.sharedApplication().delegate as! AppDelegate).navi.setViewControllers([homeManager], animated: false)
        (UIApplication.sharedApplication().delegate as! AppDelegate).sw.revealToggleAnimated(true)
    }
    func settingsFunc(){
        if(settings == nil){
            settings = SettingsViewController()
        }
        (UIApplication.sharedApplication().delegate as! AppDelegate).navi.setViewControllers([settings], animated: false)
        (UIApplication.sharedApplication().delegate as! AppDelegate).sw.revealToggleAnimated(true)
    }
    func shareFunc(){
        
        PFConfig.getConfigInBackgroundWithBlock {
            (config: PFConfig?, error: NSError?) -> Void in
            
            let textToShare = NSLocalizedString("Check this app!", comment: "prompt_share_text")
            
            if let myWebsite = NSURL(string: (config?["website"] as? String)!)
            {
                let objectsToShare = [textToShare, myWebsite]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                self.presentViewController(activityVC, animated: true, completion: nil)
            }
            
        }

        
        
        
    }
    
}
