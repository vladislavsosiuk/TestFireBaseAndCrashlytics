//
//  SignInViewController.swift
//  TestFireBaseAndCrashlytics
//
//  Created by air on 03.11.17.
//  Copyright © 2017 VladOS. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignInViewController: UIViewController {
    
    //MARK: - keys
    let MainViewControllerSegueKey = "MainViewControllerSegue"

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        
        Auth.auth().addStateDidChangeListener({auth, user in
            guard let _ = user else {return}
            
            self.performSegue(withIdentifier: self.MainViewControllerSegueKey, sender: nil)
        })
    }

}
extension SignInViewController:GIDSignInUIDelegate{
    
}
