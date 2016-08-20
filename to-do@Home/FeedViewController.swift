//
//  FeedViewController.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 14.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "Cell"
    var tableView = UITableView.init()
    var items:[PFObject]! = []
    let refreshControl = UIRefreshControl.init()
    let background = UIView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = kColorPrimary
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleMenu")
        
        view.addGestureRecognizer((UIApplication.sharedApplication().delegate as! AppDelegate).sw.panGestureRecognizer())
        
        navigationItem.title = NSLocalizedString("Feed", comment: "feed_title")
        
        let imageView = UIImageView.init(image: UIImage.init(named: "sad"))
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
        tableView = configTableView(tableView, cellIdentifier: cellIdentifier, background: background, view: view, controller: self, refreshControl: refreshControl, backgroundImageName: "history_bg", cellClass: FeedItemTableViewCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        
        loadData()
        
    }
    
    func refresh(sender:AnyObject)
    {
        loadData()
    }
    
    func toggleMenu(){
        (UIApplication.sharedApplication().delegate as! AppDelegate).sw.revealToggleAnimated(true)
    }
    
    func loadData(){
        if(PFUser.currentUser()?.objectForKey("home") == nil){
            return
        }
        let query = PFQuery(className:"Feed")
        query.addDescendingOrder("createdAt")
        query.whereKey("home", equalTo:(PFUser.currentUser()?.objectForKey("home"))!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                self.items = objects
                
                self.refreshControl.endRefreshing()
                self.reloadData()
            } else {
                NSLog("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    // MARK: - Customize tableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func reloadData(){
        tableView.reloadData()
        if(items.count>0){
            background.hidden = false
        }else{
            background.hidden = true
            performSelector("loadData", withObject: nil, afterDelay: 30)
        }
    }
    
    // MARK: - Customize cell
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FeedItemTableViewCell
        cell.awakeFromNib()
        let item = self.items[indexPath.row]
        let fontSize:CGFloat = 16
        let boldA = [NSFontAttributeName : UIFont.boldSystemFontOfSize(fontSize)]
        let normalA = [NSFontAttributeName : UIFont.systemFontOfSize(fontSize)]
        
        cell.subtitle.text = NSDateFormatter.localizedStringFromDate(item.createdAt!, dateStyle: .LongStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        
        cell.indicator.backgroundColor = kColorInactive
        
        switch item["type"] as! String{
        case FeedItemType.HOME_CONNECT:
            
            let attributed = NSMutableAttributedString.init(string: "")
            attributed.appendAttributedString(NSMutableAttributedString(string:item["userName"] as! String, attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString(" joined to home!", comment: "feed_joined_home"), attributes:normalA))
            
            cell.title.attributedText = attributed
            cell.indicator.backgroundColor = kColorGreen
            break
            
            
        case FeedItemType.HOME_DISCONNECT:
            
            let attributed = NSMutableAttributedString.init(string: "")
            attributed.appendAttributedString(NSMutableAttributedString(string:item["userName"] as! String, attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString(" disconected from home!", comment: "feed_disconect_home"), attributes:normalA))
            
            cell.title.attributedText = attributed
            cell.indicator.backgroundColor = kColorRed
            break
            
            
        case FeedItemType.HOME_CREATE:
            
            let attributed = NSMutableAttributedString.init(string: "")
            attributed.appendAttributedString(NSMutableAttributedString(string:item["userName"] as! String, attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString(" created home!", comment: "feed_created_home"), attributes:normalA))
            
            cell.title.attributedText = attributed
            cell.indicator.backgroundColor = kColorAccent
            break
            
            
        case FeedItemType.TASK_DONE:
            
            let attributed = NSMutableAttributedString.init(string: "")
            attributed.appendAttributedString(NSMutableAttributedString(string:item["userName"] as! String, attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString(" marked", comment: "feed_marked"), attributes:normalA))
            attributed.appendAttributedString(NSMutableAttributedString(string:" \"", attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:item["objectTitle"] as! String, attributes:boldA))
            
            attributed.appendAttributedString(NSMutableAttributedString(string:"\" ", attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString("as ", comment: "feed_as"), attributes:normalA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString("done!", comment: "feed_done"), attributes:boldA))
            
            cell.title.attributedText = attributed
            cell.indicator.backgroundColor = kColorGreen
            break
            
            
        case FeedItemType.TASK_UNDONE:
            
            let attributed = NSMutableAttributedString.init(string: "")
            attributed.appendAttributedString(NSMutableAttributedString(string:item["userName"] as! String, attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString(" marked", comment: "feed_marked"), attributes:normalA))
            attributed.appendAttributedString(NSMutableAttributedString(string:" \"", attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:item["objectTitle"] as! String, attributes:boldA))
            
            attributed.appendAttributedString(NSMutableAttributedString(string:"\" ", attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString("as ", comment: "feed_as"), attributes:normalA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString("undone!", comment: "feed_undone"), attributes:boldA))
            
            cell.title.attributedText = attributed
            cell.indicator.backgroundColor = kColorRed
            break
            
            
        case FeedItemType.TASK_LIKE:
            
            let attributed = NSMutableAttributedString.init(string: "")
            attributed.appendAttributedString(NSMutableAttributedString(string:item["userName"] as! String, attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString(" like", comment: "feed_like"), attributes:normalA))
            attributed.appendAttributedString(NSMutableAttributedString(string:" \"", attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:item["objectTitle"] as! String, attributes:boldA))
            
            attributed.appendAttributedString(NSMutableAttributedString(string:"\" ", attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString("made by ", comment: "feed_made_by"), attributes:normalA))
            attributed.appendAttributedString(NSMutableAttributedString(string:item["objectUserName"] as! String, attributes:boldA))
            
            cell.title.attributedText = attributed
            cell.indicator.backgroundColor = kColorGreen
            break
            
            
            
        case FeedItemType.TASK_DISLIKE:
            
            let attributed = NSMutableAttributedString.init(string: "")
            attributed.appendAttributedString(NSMutableAttributedString(string:item["userName"] as! String, attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString(" dislike", comment: "feed_dislike"), attributes:normalA))
            attributed.appendAttributedString(NSMutableAttributedString(string:" \"", attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:item["objectTitle"] as! String, attributes:boldA))
            
            attributed.appendAttributedString(NSMutableAttributedString(string:"\" ", attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString("made by ", comment: "feed_made_by"), attributes:normalA))
            attributed.appendAttributedString(NSMutableAttributedString(string:item["objectUserName"] as! String, attributes:boldA))
            
            cell.title.attributedText = attributed
            cell.indicator.backgroundColor = kColorRed
            break
            
            
        case FeedItemType.TYPE_ADD:
            
            let attributed = NSMutableAttributedString.init(string: "")
            attributed.appendAttributedString(NSMutableAttributedString(string:item["userName"] as! String, attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString(" add type of task:", comment: "feed_add_type"), attributes:normalA))
            attributed.appendAttributedString(NSMutableAttributedString(string:" \"", attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:item["objectTitle"] as! String, attributes:boldA))
            
            attributed.appendAttributedString(NSMutableAttributedString(string:"\"", attributes:boldA))
            
            cell.title.attributedText = attributed
            cell.indicator.backgroundColor = kColorGreen
            break
            
            
        case FeedItemType.TYPE_EDIT:
            
            let attributed = NSMutableAttributedString.init(string: "")
            attributed.appendAttributedString(NSMutableAttributedString(string:item["userName"] as! String, attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString(" edit type of task:", comment: "feed_edit_type"), attributes:normalA))
            attributed.appendAttributedString(NSMutableAttributedString(string:" \"", attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:item["objectTitle"] as! String, attributes:boldA))
            
            attributed.appendAttributedString(NSMutableAttributedString(string:"\"", attributes:boldA))
            
            cell.title.attributedText = attributed
            cell.indicator.backgroundColor = kColorAccent
            break
            
            
        case FeedItemType.TYPE_DELETE:
            
            let attributed = NSMutableAttributedString.init(string: "")
            attributed.appendAttributedString(NSMutableAttributedString(string:item["userName"] as! String, attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:NSLocalizedString(" delete type of task:", comment: "feed_delete_type"), attributes:normalA))
            attributed.appendAttributedString(NSMutableAttributedString(string:" \"", attributes:boldA))
            attributed.appendAttributedString(NSMutableAttributedString(string:item["objectTitle"] as! String, attributes:boldA))
            
            attributed.appendAttributedString(NSMutableAttributedString(string:"\"", attributes:boldA))
            
            cell.title.attributedText = attributed
            cell.indicator.backgroundColor = kColorRed
            break
            
            default: break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
