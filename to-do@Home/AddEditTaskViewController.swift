//
//  AddEditTaskViewController.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 08.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit

class AddEditTaskViewController: UIViewController, UITextFieldDelegate {

    var navBarText: String! = ""
    var titleText: String! = ""
    var frequencyText: String! = ""
    var saveBlock: ((String, Int) -> Void)? = nil
    var imageName: String! = "homework"
    var views: [UIView] = []
    var img: UIImageView!
    var titleView:(background: UIImageView, textField: UITextField)!
    var frequencyView:(background: UIImageView, textField: UITextField)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = navBarText
        view.backgroundColor = kColorPrimary
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelFunc")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "backgroundFunc:"))
        
        img = UIImageView.init(image: UIImage.init(named: imageName))
        img.contentMode = UIViewContentMode.ScaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(img)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[img]-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["img" : img]))
        
        titleView = generateTextField(NSLocalizedString("Title", comment: "prompt_title"), keyboardType: .Default, secured: false, controller: self, onEndFunction: "titleEnd")
        titleView.textField.text = titleText
        view.addSubview(titleView.background)
        views.append(titleView.background)
        
        frequencyView = generateTextField(NSLocalizedString("Frequency", comment: "prompt_frequency"), keyboardType: .NumberPad, secured: false, controller: self, onEndFunction: "frequencyEnd")
        frequencyView.textField.delegate = self
        frequencyView.textField.text = frequencyText
        view.addSubview(frequencyView.background)
        views.append(frequencyView.background)
        
        let save = generateButton(NSLocalizedString("Save", comment: "prompt_save"), function: "saveFunc", controller: self, color: kColorAccent)
        view.addSubview(save)
        views.append(save)
        
        view.addConstraint(NSLayoutConstraint.init(item: titleView.background, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 1.0))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[title]-[frequency(==title)]-[save(==title)]-(==20)-|", options: .AlignAllCenterX, metrics: nil, views: ["title" : titleView.background, "frequency" : frequencyView.background, "save" : save]))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[img]-[title]", options: [], metrics: nil, views: ["img" : img, "title" : titleView.background]))
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func saveFunc(){
        
        if titleView.textField.text!.isEmpty || frequencyView.textField.text!.isEmpty {
            UIAlertView.init(title: NSLocalizedString("Error", comment: "Error_title"), message: NSLocalizedString("All fields are required", comment: "prompt_all_fields"), delegate: nil, cancelButtonTitle: NSLocalizedString("Ok", comment: "prompt_ok")).show()
        }else if (frequencyView.textField.text! as NSString).integerValue < 1{
            UIAlertView.init(title: NSLocalizedString("Error", comment: "Error_title"), message: NSLocalizedString("Frequency have to be bigger than zero!", comment: "prompt_bigger_than_zero"), delegate: nil, cancelButtonTitle: NSLocalizedString("Ok", comment: "prompt_ok")).show()
        }else{
            saveBlock!(titleView.textField.text!, (frequencyView.textField.text! as NSString).integerValue)
        }
    }
    
    func cancelFunc(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersInString:"0123456789").invertedSet
        let compSepByCharInSet = string.componentsSeparatedByCharactersInSet(aSet)
        let numberFiltered = compSepByCharInSet.joinWithSeparator("")
        return string == numberFiltered
        
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
    
    func titleEnd(){
        frequencyView.textField.becomeFirstResponder()
    }
    func frequencyEnd(){
        saveFunc()
    }
}
