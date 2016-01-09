//
//  WelcomeViewController.swift
//  to-do@Home
//
//  Created by Maciej Matuszewski on 05.01.2016.
//  Copyright © 2016 Maciej Matuszewski. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = kColorPrimary
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let logo = UIImageView.init(image: UIImage.init(named: "logo_text_white"))
        logo.contentMode = UIViewContentMode.ScaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        
        let btnLogin = generateButton(NSLocalizedString("Login", comment: "Welcome_btnLogin"), function: "btnLoginFunc", controller: self, color: kColorAccent)
        view.addSubview(btnLogin)
        
        let btnRegister = generateButton(NSLocalizedString("Register", comment: "Welcome_btnRegister"), function: "btnRegisterFunc", controller: self, color: kColorAccent)
        view.addSubview(btnRegister)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==130)-[logo]-(>=10)-[btnLogin]-[btnRegister(==btnLogin)]-(==25)-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["logo" : logo, "btnLogin" : btnLogin, "btnRegister" : btnRegister]))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[logo]-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["logo" : logo]))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Button function
    
    func btnLoginFunc(){
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    func btnRegisterFunc(){
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }

}
