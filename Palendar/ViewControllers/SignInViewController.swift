//  SignInViewController.swift
//  Palendar
//  Created by Pratham  Hebbar on 8/11/2021.

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.becomeFirstResponder()
        passwordTextField.isSecureTextEntry = true
        configureTextField()
        configureTapGesture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
  
    @objc func keyboardAppear() {
        if isExpanded == false {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + 300)
            isExpanded.toggle()
        }
    }
    
    @objc func keyboardDisappear() {
        if isExpanded {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - 300)
            isExpanded.toggle()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func dismissClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // IBAction Sign In
    @IBAction func signInClicked(_ sender: UIButton) {
        
        if firstNameTextField.text == "" || lastNameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" {
            return
        }
        
        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                self.showAlert(message: error!.localizedDescription)
            }
            else {
                let uniqueString = result!.user.uid
                UserManager.saveUserId(userId: uniqueString)
                UserManager.saveUser(firstName: firstName, lastName: lastName)
                UserManager.saveEmail(email: email)
                
                let database = Firestore.firestore()
                
                database.collection("users").document(uniqueString).updateData(["firstname":firstName, "lastname":lastName, "email":email, "fullName":firstName + " " + lastName]) { (error) in
                    
                    if error == nil {
                        DispatchQueue.main.async {
                            self.view.endEditing(true)
                            self.transitionToHome()
                        }
                    }
                    else {
                        self.showAlert(message: error!.localizedDescription)
                    }
                }
            }
        }
        
    }
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func transitionToHome() {
        let screen = storyboard?.instantiateViewController(identifier: "tabBarVC") as! TabBarController
        view.window?.rootViewController = screen
        view.window?.makeKeyAndVisible()
    }
    
    func configureTextField() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        firstNameTextField.becomeFirstResponder()
    }
    
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(sender:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}
extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if textField == firstNameTextField {
            firstNameTextField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
        }
        else if textField == lastNameTextField {
            lastNameTextField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        }
        else if textField == emailTextField {
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            view.endEditing(true)
        }
        return false
    }
    
}
