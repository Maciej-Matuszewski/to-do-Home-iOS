//
//  MainViewController.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 05.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit
import Parse
import SWRevealViewController
import GoogleMobileAds

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GADInterstitialDelegate {

    let cellIdentifier = "Cell"
    var tableView = UITableView.init()
    var sections:[SectionData]! = []
    let refreshControl = UIRefreshControl.init()
    let background = UIView.init()
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        
        //#Config Background
        
        view.backgroundColor = kColorPrimary
        
        let imageView = UIImageView.init(image: UIImage.init(named: "happy"))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let nothingLabel = UILabel.init()
        nothingLabel.text = NSLocalizedString("Nothing to show!", comment: "prompt_nothing_to_show")
        nothingLabel.textColor = kColorWhite
        nothingLabel.font = UIFont.boldSystemFontOfSize(26)
        nothingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nothingLabel)
        
        let addButton = generateButton(NSLocalizedString("Add tasks", comment: "prompt_add_tasks"), function: "addTaskBtnFunc", controller: self, color: kColorAccent)
        view.addSubview(addButton)
        
        if(DeviceType.IS_IPHONE_4_OR_LESS){
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==10)-[image(==200)]-(==20)-[label]-(>=30)-[button]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["image" : imageView, "label" : nothingLabel, "button" : addButton]))
        }else{
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==70)-[image(==200)]-(==20)-[label]-(>=30)-[button]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["image" : imageView, "label" : nothingLabel, "button" : addButton]))
        }
        
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==70)-[image(==200)]-(==20)-[label]-(>=30)-[button]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["image" : imageView, "label" : nothingLabel, "button" : addButton]))
        
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[image(==200)]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["image" : imageView]))
        view.addConstraint(NSLayoutConstraint.init(item: nothingLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 1.0))
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = NSString.init(format: "%@: %@", NSLocalizedString("Today", comment: "Today_title"), NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: NSDateFormatterStyle.NoStyle)) as String
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleMenu")
        
        view.addGestureRecognizer((UIApplication.sharedApplication().delegate as! AppDelegate).sw.panGestureRecognizer())
        
        //#Config tableView
        tableView = configTableViewWithoutConstriant(tableView, cellIdentifier: cellIdentifier, background: background, view: view, controller: self, refreshControl: refreshControl, backgroundImageName: "home", cellClass: TaskMainTableViewCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
        bannerView = GADBannerView.init(adSize: kGADAdSizeBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        
        bannerView.adUnitID = kBannerAd
        bannerView.rootViewController = self
        let adRequest = GADRequest()
        bannerView.loadRequest(adRequest)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[banner]|", options: [], metrics: nil, views: ["banner" : bannerView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[banner]|", options: [], metrics: nil, views: ["banner" : bannerView]))
        
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[background][banner]", options: [], metrics: nil, views: ["background":background, "banner" : bannerView]))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[button]-[banner]", options: [], metrics: nil, views: ["button" : addButton, "banner" : bannerView]))
        
        interstitial = GADInterstitial(adUnitID: kFullScreenAd)
        interstitial.delegate = self
        interstitial.loadRequest(adRequest)
        performSelector("showAd", withObject: nil, afterDelay: 5)
        
    }
    
    func interstitialDidFailToReceiveAdWithError ( interstitial: GADInterstitial, error: GADRequestError) {
            print("interstitialDidFailToReceiveAdWithError: %@" + error.localizedDescription)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(PFUser.currentUser()?.objectForKey("home") == nil){
            let navigationController = UINavigationController.init(rootViewController: AddHomeViewController())
            navigationController.navigationBar.barStyle = UIBarStyle.Black
            navigationController.navigationBar.translucent = false
            navigationController.navigationBar.barTintColor = kColorDark
            navigationController.navigationBar.tintColor = kColorWhite
            self.presentViewController(navigationController, animated: true, completion: { () -> Void in
                self.loadData()
            })
        }else{
            loadData()
        }
    }
    
    func showAd(){
        if interstitial.isReady{
            interstitial.presentFromRootViewController(self)
        }else{
            performSelector("showAd", withObject: nil, afterDelay: 1)
        }
    }
    
    // MARK: - Buttons handlers
    
    func toggleMenu(){
        (UIApplication.sharedApplication().delegate as! AppDelegate).sw.revealToggleAnimated(true)
    }
    
    func refresh(sender:AnyObject)
    {
        loadData()
    }
    
    func addTaskBtnFunc(){
        
        let addEditTaskVC = AddEditTaskViewController()
        addEditTaskVC.navBarText = NSLocalizedString("Add task", comment: "add_task_title")
        
        addEditTaskVC.saveBlock = { (title, frequency) -> Void in
            let taskType = PFObject(className: "TaskType")
            taskType["title"] = title
            taskType["frequency"] = frequency
            taskType["home"] = PFUser.currentUser()!["home"]
            taskType["readyUntil"] = NSDate.init(timeIntervalSince1970: 0)
            
            taskType.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    addEditTaskVC.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
        
        let navi = UINavigationController.init(rootViewController: addEditTaskVC)
        navi.navigationBar.barStyle = UIBarStyle.Black
        navi.navigationBar.translucent = false
        navi.navigationBar.barTintColor = kColorDark
        navi.navigationBar.tintColor = kColorWhite
        self.presentViewController(navi, animated: true) { () -> Void in
            (UIApplication.sharedApplication().delegate as! AppDelegate).navi.setViewControllers([HomeManagerViewController(),TasksManagerViewController()], animated: false)
        }
    }
    
    // MARK: - Data handlers
    
    func loadData(){
        
        if(PFUser.currentUser()?.objectForKey("home") == nil){
            return
        }
        sections = []
        let query = PFQuery(className:"Task")
        query.whereKey("user", equalTo:PFUser.currentUser()!)
        query.whereKey("endDate", greaterThan: NSDate())
        query.addAscendingOrder("endDate")
        query.whereKey("home", equalTo:(PFUser.currentUser()?.objectForKey("home"))!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                for object in objects!{
                    let days = daysBetweenDateAndNow(object["endDate"] as! NSDate)
                    var added = false
                    for section in self.sections{
                        if(section.days == days){
                            section.array.append(object)
                            added = true
                        }
                    }
                    if(!added){
                        let section = SectionData()
                        section.days = days
                        section.array.append(object)
                        self.sections.append(section)
                    }
                }
                
                self.refreshControl.endRefreshing()
                self.reloadData()
            } else {
                NSLog("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    // MARK: - Customize tableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].array.count
    }
    
    func reloadData(){
        tableView.reloadData()
        if(sections.count>0){
            background.hidden = false
        }else{
            background.hidden = true
            performSelector("loadData", withObject: nil, afterDelay: 30)
        }
    }
    
    // MARK: - Customize header
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (self.sections[section].days){
        case 0:
            return NSLocalizedString("Today", comment: "prompt_today")
        case 1:
            return NSLocalizedString("Tomorrow", comment: "prompt_tomorrow")
            
        default:
            return NSString.init(format: "%@ %d %@", NSLocalizedString("In", comment: "prompt_in"), self.sections[section].days, NSLocalizedString("days", comment: "prompt_days")) as String
        }
    }
    
    // MARK: - Customize cell
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TaskMainTableViewCell
        cell.awakeFromNib()
        let task = self.sections[indexPath.section].array[indexPath.row]
        cell.title.text = task["title"] as? String
        cell.indicator.backgroundColor = task["done"] as! Bool == true ? kColorGreen : kColorInactive
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let doneAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: NSLocalizedString("Done", comment: "prompt_done")) { (action, indexPath) -> Void in
            
            tableView.setEditing(false, animated: true)
            self.sections[indexPath.section].array[indexPath.row]["done"] = true
            self.sections[indexPath.section].array[indexPath.row].saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.reloadData()
                }
            }
        }
        doneAction.backgroundColor=kColorGreen
        
        let undoneAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: NSLocalizedString("Undone", comment: "prompt_undone")) { (action, indexPath) -> Void in
            tableView.setEditing(false, animated: true)
            self.sections[indexPath.section].array[indexPath.row]["done"] = false
            self.sections[indexPath.section].array[indexPath.row].saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.reloadData()
                }
            }
        }
        undoneAction.backgroundColor=kColorRed
        
        return [self.sections[indexPath.section].array[indexPath.row]["done"] as! Bool == true ? undoneAction : doneAction]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

class SectionData {
    var days:Int = 0
    var array:[PFObject]! = []
}
