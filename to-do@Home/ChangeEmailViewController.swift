//
//  ChangeEmailViewController.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 08.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit
import Parse

class ChangeEmailViewController: UIViewController {
    
    var fieldOne:(background: UIImageView, textField: UITextField)!
    var img: UIImageView!
    var views: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = kColorPrimary
        navigationItem.title = NSLocalizedString("Change email", comment: "change_email_title")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "backgroundFunc:"))
        
        img = UIImageView.init(image: UIImage.init(named: "user"))
        img.contentMode = UIViewContentMode.ScaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(img)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[img]-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["img" : img]))
        
        fieldOne = generateTextField(NSLocalizedString("Email", comment: "prompt_email"), keyboardType: .EmailAddress, secured: false, controller: self, onEndFunction: "fieldOneEndFunc")
        fieldOne.textField.text = PFUser.currentUser()!.email
        fieldOne.textField.autocapitalizationType = .None
        view.addSubview(fieldOne.background)
        views.append(fieldOne.background)
        
        let save = generateButton(NSLocalizedString("Save", comment: "prompt_save"), function: "saveFunc", controller: self, color: kColorAccent)
        view.addSubview(save)
        views.append(save)
        
        view.addConstraint(NSLayoutConstraint.init(item: fieldOne.background, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 1.0))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[fieldOne]-[save(==fieldOne)]-(==20)-|", options: .AlignAllCenterX, metrics: nil, views: ["fieldOne" : fieldOne.background, "save" : save]))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[img]-[fieldOne]", options: [], metrics: nil, views: ["img" : img, "fieldOne" : fieldOne.background]))
        
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func saveFunc(){
        if fieldOne.textField.text!.isEmpty{
            UIAlertView.init(title: NSLocalizedString("Error", comment: "Error_title"), message: NSLocalizedString("Email field is required", comment: "prompt_email_required"), delegate: nil, cancelButtonTitle: NSLocalizedString("Ok", comment: "prompt_ok")).show()
        }else{
            PFUser.currentUser()!.email = fieldOne.textField.text
            PFUser.currentUser()?.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    UIAlertView.init(title: NSLocalizedString("Success", comment: "Success_title"), message: NSLocalizedString("Profile has been updated", comment: "prompt_profile_updated"), delegate: nil, cancelButtonTitle: NSLocalizedString("Ok", comment: "prompt_ok")).show()
                    PFUser.currentUser()?.fetchInBackground()
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    UIAlertView.init(title: NSLocalizedString("Error", comment: "Error_title"), message: error?.userInfo["error"] as? String, delegate: nil, cancelButtonTitle: NSLocalizedString("Ok", comment: "prompt_ok")).show()
                }
            })
        }
    }
    
    func backgroundFunc(recognizer:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Keyboard Notification handler
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let duration:NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            let height:CGFloat = -(UIScreen.mainScreen().bounds.size.height - (endFrame?.origin.y)!)
            
            UIView.animateWithDuration(duration,
                delay: NSTimeInterval(0),
                options: animationCurve,
                animations: {
                    if(DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS){
                        self.navigationController?.setNavigationBarHidden(height != 0 ? true : false, animated: true)
                    }
                    for v in self.views {
                        v.transform = CGAffineTransformMakeTranslation(0, height)
                    }
                    self.img.alpha = 1.5+height/(endFrame?.size.height)!
                },
                completion: nil)
        }
    }
    
    func fieldOneEndFunc(){
        saveFunc()
    }
}