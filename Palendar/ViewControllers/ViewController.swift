//
//  ViewController.swift
//  Palendar
//
//  Created by Pratham  Hebbar on 8/11/21.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet var signInButton: UIButton!
    @IBOutlet var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 20
        createAccountButton.layer.cornerRadius = 20
        
        if Auth.auth().currentUser != nil {
            let tabBarVC = storyboard?.instantiateViewController(identifier: "tabBarVC") as! TabBarController
            view.window?.rootViewController = tabBarVC
            view.window?.makeKeyAndVisible()
        }
    }


}

