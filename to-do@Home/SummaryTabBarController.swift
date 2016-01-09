//
//  SummaryTabBarController.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 06.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit

class SummaryTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let done = SummaryDoneViewController()
        done.tabBarItem = generateTabBarItem(NSLocalizedString("Done", comment: "prompt_done"), imageName: "tick")
        
        let notDone = SummaryNotdoneViewController()
        notDone.tabBarItem = generateTabBarItem(NSLocalizedString("Not done", comment: "prompt_not_done"), imageName: "cross")
        
        let history = SummaryHistoryViewController()
        history.tabBarItem = generateTabBarItem(NSLocalizedString("History", comment: "prompt_history"), imageName: "history")
            
        self.viewControllers = [done, notDone, history]
        self.tabBar.barStyle = UIBarStyle.Default
        self.tabBar.barTintColor = kColorDark
        self.tabBar.tintColor = kColorWhite
        self.tabBar.translucent = false
        
        view.backgroundColor = kColorPrimary
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: UIBarButtonItemStyle.Plain, target: self, action: "toggleMenu")
        
        view.addGestureRecognizer((UIApplication.sharedApplication().delegate as! AppDelegate).sw.panGestureRecognizer())
        
        navigationItem.title = NSLocalizedString("Summary", comment: "Summary_title")
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.selectedIndex = 0
    }
    
    func toggleMenu(){
        (UIApplication.sharedApplication().delegate as! AppDelegate).sw.revealToggleAnimated(true)
    }

}
