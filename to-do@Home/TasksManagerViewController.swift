//
//  TasksManagerViewController.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 08.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit
import Parse

class TasksManagerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier = "Cell"
    var tableView = UITableView.init()
    var tasksTypes:[PFObject]! = []
    let refreshControl = UIRefreshControl.init()
    let background = UIView.init()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //#Config Background
        
        view.backgroundColor = kColorPrimary
        
        let imageView = UIImageView.init(image: UIImage.init(named: "homework"))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let nothingLabel = UILabel.init()
        nothingLabel.text = NSLocalizedString("No tasks!", comment: "prompt_no_tasks")
        nothingLabel.textColor = kColorWhite
        nothingLabel.font = UIFont.boldSystemFontOfSize(26)
        nothingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nothingLabel)
        
        let addButton = generateButton(NSLocalizedString("Add tasks", comment: "prompt_add_tasks"), function: "addTaskFunc", controller: self, color: kColorAccent)
        view.addSubview(addButton)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==70)-[image(==200)]-(==20)-[label]-(>=30)-[button]-(==20)-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["image" : imageView, "label" : nothingLabel, "button" : addButton]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[image(==200)]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["image" : imageView]))
        view.addConstraint(NSLayoutConstraint.init(item: nothingLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 1.0))
        
        navigationItem.title = NSLocalizedString("Tasks manager", comment: "task_manager_title")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Add, target: self, action: "addTaskFunc")
        
        
        //#Config tableView
        tableView = configTableView(tableView, cellIdentifier: cellIdentifier, background: background, view: view, controller: self, refreshControl: refreshControl, backgroundImageName: "homework", cellClass: TaskDoneTableViewCell.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //#Load Data
        loadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }
    
    // MARK: - Buttons handlers
    
    func toggleMenu(){
        (UIApplication.sharedApplication().delegate as! AppDelegate).sw.revealToggleAnimated(true)
    }
    
    func refresh(sender:AnyObject)
    {
        loadData()
    }
    
    // MARK: - Data handlers
    
    func loadData(){
        if(PFUser.currentUser()?.objectForKey("home") == nil){
            return
        }
        tasksTypes = []
        let query = PFQuery(className:"TaskType")
        query.addAscendingOrder("title")
        query.whereKey("home", equalTo:(PFUser.currentUser()?.objectForKey("home"))!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                self.tasksTypes = objects
                
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
        return tasksTypes.count
    }
    
    func reloadData(){
        tableView.reloadData()
        if(tasksTypes.count>0){
            background.hidden = false
        }else{
            background.hidden = true
            performSelector("loadData", withObject: nil, afterDelay: 30)
        }
    }
    
    // MARK: - Customize header
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSString.init(format: "%@: %d", NSLocalizedString("Number of task types", comment: "prompt_number_types"), tasksTypes.count) as String
    }
    
    // MARK: - Customize cell
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TaskDoneTableViewCell
        cell.awakeFromNib()
        let task = tasksTypes[indexPath.row]
        cell.title.text = task["title"] as? String
        cell.subtitle.text = NSString.init(format: "%@: %d", NSLocalizedString("Frequency", comment: "prompt_frequency"),task["frequency"] as! Int) as String
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .Normal, title: NSLocalizedString("Edit", comment: "prompt_edit")) { (action, indexP) -> Void in
            
            let addEditTaskVC = AddEditTaskViewController()
            addEditTaskVC.navBarText = NSLocalizedString("Edit task", comment: "edit_task_title")
            addEditTaskVC.titleText = self.tasksTypes[indexPath.row]["title"] as! String
            addEditTaskVC.frequencyText = NSString.init(format: "%d", self.tasksTypes[indexPath.row]["frequency"] as! Int) as String
            
            addEditTaskVC.saveBlock = { (title, frequency) -> Void in
                let taskType = self.tasksTypes[indexPath.row]
                taskType["title"] = title
                taskType["frequency"] = frequency
                
                taskType.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if error == nil {
                        addEditTaskVC.dismissViewControllerAnimated(true, completion: nil)
                        generateFeedItem(FeedItemType.TYPE_EDIT, objectTitle: title)
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
        editAction.backgroundColor = kColorGreen
        
        let deleteAction = UITableViewRowAction(style: .Normal, title: NSLocalizedString("Delete", comment: "prompt_delete")) { (action, indexP) -> Void in
            
            let task = self.tasksTypes[indexPath.row]
            
            generateFeedItem(FeedItemType.TYPE_DELETE, objectTitle: task["title"] as! String)
            task.deleteInBackgroundWithBlock({ (success, error) -> Void in
                if(error == nil){
                    self.loadData()
                }
            })
            
        }
        deleteAction.backgroundColor = kColorRed
        
        return [deleteAction, editAction]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Tasks functions
    
    func addTaskFunc(){
        
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
                    generateFeedItem(FeedItemType.TYPE_ADD, objectTitle: taskType["title"] as! String)
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
    
}

