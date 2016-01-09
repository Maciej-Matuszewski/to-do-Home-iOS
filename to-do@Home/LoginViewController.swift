//
//  LoginViewController.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 05.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    var views: [UIView] = []
    var logo:UIImageView!
    var emailView:(background: UIImageView, textField: UITextField)!
    var passwordView:(background: UIImageView, textField: UITextField)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //#Config Background
        view.backgroundColor = kColorPrimary
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = NSLocalizedString("Login", comment: "Login_title")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)

        //##Add elements
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "backgroundFunc:"))
        
        logo = UIImageView.init(image: UIImage.init(named: "logo_text_white"))
        logo.contentMode = UIViewContentMode.ScaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        
        emailView = generateTextField(NSLocalizedString("Email", comment: "prompt_email"), keyboardType: .EmailAddress, secured: false, controller: self, onEndFunction: "emailEnd")
        passwordView = generateTextField(NSLocalizedString("Password", comment: "prompt_password"), keyboardType: .Default, secured: true, controller: self, onEndFunction: "passEnd")
        view.addSubview(emailView.background)
        views.append(emailView.background)
        view.addSubview(passwordView.background)
        views.append(passwordView.background)
        
        let button = generateButton(NSLocalizedString("Login", comment: "Login_button"), function: "buttonFunc", controller: self, color: kColorAccent)
        view.addSubview(button)
        views.append(button)
        
        //##Add constrants
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[logo]-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["logo" : logo]))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==32)-[logo]-(>=10)-[emailView]-[passwordView(==emailView)]-[button(==emailView)]-(20)-|", options: .AlignAllCenterX, metrics: nil, views: ["logo" : logo, "emailView" : emailView.background, "passwordView" : passwordView.background, "button" : button]))
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Buttons functions
    
    func buttonFunc(){
        
        PFUser.logInWithUsernameInBackground(emailView.textField.text!, password:passwordView.textField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.view.endEditing(true)
                let installation = PFInstallation.currentInstallation()
                installation["user"] = user
                installation.saveInBackground()
                (UIApplication.sharedApplication().delegate as! AppDelegate).loadMain()
            } else {
                UIAlertView.init(title: NSLocalizedString("Error", comment: "Error_title"), message: error?.userInfo["error"] as? String, delegate: nil, cancelButtonTitle: NSLocalizedString("Ok", comment: "prompt_ok")).show()
            }
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
                    self.logo.alpha = 1.5+height/(endFrame?.size.height)!
                },
                completion: nil)
        }
    }
    
    
    func emailEnd(){
        passwordView.textField.becomeFirstResponder()
    }
    func passEnd(){
        buttonFunc()
    }
    
}
