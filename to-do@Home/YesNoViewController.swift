//
//  YesNoViewController.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 08.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit

class YesNoViewController: UIViewController {

    var completionBlock: (Bool -> Void)? = nil
    
    var labelText: String! = ""
    var yesColor: UIColor! = kColorAccent
    var noColor: UIColor! = kColorAccent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kColorPrimary
        
        let backgroundImageView = UIImageView.init(image: UIImage.init(named: "questionMark"))
        backgroundImageView.contentMode = .ScaleAspectFit
        backgroundImageView.alpha = 0.25
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundImageView)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==25)-[item]-(==140)-|", options: .AlignAllCenterX, metrics: nil, views: ["item" : backgroundImageView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(==25)-[item]-(==25)-|", options: .AlignAllCenterX, metrics: nil, views: ["item" : backgroundImageView]))
        
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = labelText
        label.textColor = kColorWhite
        label.textAlignment = NSTextAlignment.Center
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFontOfSize(32)
        
        view.addSubview(label)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==100)-[label]", options: [], metrics: nil, views: ["label" : label]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: ["label" : label]))
        
        let yes = generateButton(NSLocalizedString("Yes", comment: "prompt_yes"), function: "yesFunc", controller: self, color: yesColor)
        view.addSubview(yes)
        
        let no = generateButton(NSLocalizedString("No", comment: "prompt_no"), function: "noFunc", controller: self, color: noColor)
        view.addSubview(no)
        
        view.addConstraint(NSLayoutConstraint.init(item: yes, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 1.0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[yes]-[no(==yes)]-(==20)-|", options: .AlignAllCenterX, metrics: nil, views: ["label" : label, "yes" : yes, "no" : no]))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==100)-[label]", options: [], metrics: nil, views: ["label" : label]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: ["label" : label]))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func yesFunc(){
        completionBlock!(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func noFunc(){
        completionBlock!(false)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
