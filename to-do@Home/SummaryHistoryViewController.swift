//
//  SummaryHistoryViewController.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 07.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit
import Parse

class SummaryHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "Cell"
    var tableView = UITableView.init()
    var sections:[SectionData]! = []
    let refreshControl = UIRefreshControl.init()
    let background = UIView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView.init(image: UIImage.init(named: "history_bg"))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let nothingLabel = UILabel.init()
        nothingLabel.text = NSLocalizedString("Nothing to show!", comment: "prompt_nothing_to_show")
        nothingLabel.textColor = kColorWhite
        nothingLabel.font = UIFont.boldSystemFontOfSize(26)
        nothingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nothingLabel)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==70)-[image(==200)]-(==20)-[label]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["image" : imageView, "label" : nothingLabel]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[image(==200)]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["image" : imageView]))
        view.addConstraint(NSLayoutConstraint.init(item: nothingLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 1.0))
        
        //#Config tableView
        tableView = configTableView(tableView, cellIdentifier: cellIdentifier, background: background, view: view, controller: self, refreshControl: refreshControl, backgroundImageName: "history_bg", cellClass: TaskDoneTableViewCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
        
    }
    
    func refresh(sender:AnyObject)
    {
        loadData()
    }
    
    func loadData(){
        if(PFUser.currentUser()?.objectForKey("home") == nil){
            return
        }
        sections = []
        let query = PFQuery(className:"Task")
        query.whereKey("endDate", lessThan: NSDate())
        query.addDescendingOrder("endDate")
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
            return NSLocalizedString("Yesterday", comment: "prompt_yesterday")
            
        default:
            return NSString.init(format: "%d %@", (self.sections[section].days * -1 ) + 1, NSLocalizedString("days ago", comment: "prompt_days_ago")) as String
        }
    }
    
    // MARK: - Customize cell
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TaskDoneTableViewCell
        cell.awakeFromNib()
        let task = self.sections[indexPath.section].array[indexPath.row]
        cell.title.text = task["title"] as? String
        
        task["user"].fetchInBackgroundWithBlock { (user, error) -> Void in
            if(error == nil){
                cell.subtitle.text = user!["name"] as? String
            }
        }
        
        var disLCount = 0
        var lCount = 0
        
        if(task["dislikes"] != nil){
            if(task["dislikes"].isKindOfClass(NSArray)){
                disLCount = (task["dislikes"] as! NSArray).count
            }
        }
        if(task["likes"] != nil){
            if(task["likes"].isKindOfClass(NSArray)){
                lCount = (task["likes"] as! NSArray).count
            }
        }
        if (task["done"] as! Bool == true && lCount > disLCount){
            cell.indicator.backgroundColor = kColorGreen
        }else{
            cell.indicator.backgroundColor = kColorRed
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
