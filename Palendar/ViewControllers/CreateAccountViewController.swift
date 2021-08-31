//  CreateAccountViewController.swift
//  Palendar
//  Created by Pratham  Hebbar on 8/11/2021.

import UIKit
import Firebase
import FirebaseAuth

class CreateAccountViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var scrollViewTwo: UIScrollView!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    
    var ages = [String]()
    var pickerview = UIPickerView()
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.becomeFirstResponder()
        ageTextField.inputView = pickerview
        ageTextField.textAlignment = .center
        
        phoneNumberTextField.keyboardType = .phonePad
        passwordTextField.isSecureTextEntry = true
        configureTextField()
        configureTapGesture()
        makeArray()
        pickerview.dataSource = self
        pickerview.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardAppear() {
        if isExpanded == false {
            scrollViewTwo.contentSize = CGSize(width: self.view.frame.width, height: scrollViewTwo.frame.height + 300)
            isExpanded.toggle()
        }
    }
    
    @objc func keyboardDisappear() {
        if isExpanded {
            scrollViewTwo.contentSize = CGSize(width: self.view.frame.width, height: scrollViewTwo.frame.height - 300)
            isExpanded.toggle()
        }
    }
    
    @IBAction func exitClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func makeArray() {
        for i in 1...100 {
            ages.append(String(i))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func validateFields() -> String? {
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            return "Please fill in all fields."
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        return nil
    }

    @IBAction func createAccountClicked(_ sender: UIButton) {
        
        let error = validateFields()
        
        if error != nil {
            showAlert(message: error!)
        }
        else {
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phoneNumber = phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let age = ageTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let ageAsANumber = Int(age)
            
            if ageAsANumber! < 13 {
                showAlert(message: "You need to be 13 or older to create an account")
                return
            }
            
            UserManager.saveUser(firstName: firstName, lastName: lastName)
            UserManager.saveEmail(email: email)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                if error == nil {
                    let database = Firestore.firestore()
                    
                    let userId = result!.user.uid
                    
                    database.collection("users").document(userId).setData(["firstname":firstName, "lastname":lastName, "uid":userId, "phoneNumber":phoneNumber, "age":age, "email":email, "fullName":firstName + " " + lastName]) { (error) in
                        
                        if error == nil {
                            DispatchQueue.main.async {
                                UserManager.saveUserId(userId: userId)
                                self.transitionToHome()
                            }
                        }
                    }
                    
                }
                else {
                    self.showAlert(message: error!.localizedDescription)
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
        phoneNumberTextField.delegate = self
        
        firstNameTextField.becomeFirstResponder()
    }
    
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(sender:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ageTextField.text = ages[row]
    }
}

extension CreateAccountViewController: UITextFieldDelegate {
    
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
            phoneNumberTextField.becomeFirstResponder()
        }
        else if textField == phoneNumberTextField {
            phoneNumberTextField.resignFirstResponder()
            view.endEditing(true)
        }
        return false
    }
    
}
