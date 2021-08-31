//
//  ProfileViewController.swift
//  Palendar
//
//  Created by Pratham  Hebbar on 8/11/21.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var phoneNumberTextField: UITextField!
    
    @IBOutlet var firstHobbyTextField: UITextField!
    @IBOutlet var secondHobbyTextField: UITextField!
    @IBOutlet var thirdHobbyTextField: UITextField!
    
    @IBOutlet var theSwitch: UISwitch!
    @IBOutlet var availabilityButton: UIButton!
    @IBOutlet var availabilityByTime: UIButton!
    
    @IBOutlet var profileImageView: UIImageView!
    
    let imagelink = UserManager.getUser("imageURL") as? String
    
    var userId = UserManager.getUser("userId") as? String
    var userFirstName = ""
    var userLastName = ""
    var userPhoneNumber = ""
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.becomeFirstResponder()
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(phoneNumberTextField)

        Utilities.styleTextField(firstHobbyTextField)
        Utilities.styleTextField(secondHobbyTextField)
        Utilities.styleTextField(thirdHobbyTextField)
        
        DispatchQueue.main.async {
            self.getUserData()
            self.getUserInterests()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        viewTap()
        profileImageView.contentMode = .scaleAspectFit
        getAndSetProfileImage()
    }
    
    func getAndSetProfileImage() {
        if userId != nil {
            let database = Firestore.firestore()
            database.collection("users").document(userId!).getDocument { (snap, error) in
                if snap != nil && error == nil {
                    let data = snap!.data()!
                    let profilePictureURL = data["profilePictureUrl"] as? String
                    
                    if profilePictureURL != nil {
                        let storage = FileStorage()
                        
                        storage.downloadImage(imageUrl: profilePictureURL!) { (profileImage) in
                            if profileImage != nil {
                                DispatchQueue.main.async {
                                    self.profileImageView.image = profileImage!
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setProfileImage() {

        let fileStorage = FileStorage()

        if imagelink == nil {
            return
        }

        fileStorage.downloadImage(imageUrl: imagelink!) { (photo) in
            if photo != nil {
                DispatchQueue.main.async {
                    self.profileImageView.image = photo!
                    // self.profileImageView.clipsToBounds = true
                }
            }
        }

    }
    
    func viewTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTAP))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTAP() {
        view.endEditing(true)
    }
    
    @objc func keyboardAppear() {
        if isExpanded == false {
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: scrollView.frame.height + 300)
            isExpanded.toggle()
        }
    }
    
    @objc func keyboardDisappear() {
        if isExpanded {
            scrollView.contentSize = CGSize(width: self.view.frame.width, height: scrollView.frame.height - 300)
            isExpanded.toggle()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let database = Firestore.firestore()
        
        if theSwitch.isOn {
            if userId != nil {
                database.collection("users").document(userId!).updateData(["isActive":true]) { (error) in
                    
                    if error == nil {
                        DispatchQueue.main.async {
                            self.availabilityButton.alpha = 1
                            self.availabilityByTime.alpha = 1
                        }
                    }
                }
            }
        }
        else {
            if userId != nil {
                database.collection("users").document(userId!).updateData(["isActive":false]) { (error) in
                    
                    if error == nil {
                        DispatchQueue.main.async {
                            self.availabilityButton.alpha = 0
                            self.availabilityByTime.alpha = 0
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func saveChangesClicked(_ sender: Any) {
        if firstNameTextField.text == "" || lastNameTextField.text == "" || phoneNumberTextField.text == "" {
            return
        }
        view.endEditing(true)
        sendRequest()
    }
    
    @IBAction func saveHobbiesClicked(_ sender: Any) {
        if firstHobbyTextField.text == "" || secondHobbyTextField.text == "" || thirdHobbyTextField.text == "" {
            return
        }
        view.endEditing(true)
        update()
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        
        let database = Firestore.firestore()
        
        if sender.isOn {
            database.collection("users").document(userId!).updateData(["isActive":true]) { (error) in
                
                if error == nil {
                    DispatchQueue.main.async {
                        self.availabilityButton.alpha = 1
                        self.availabilityByTime.alpha = 1
                    }
                }
            }
        }
        else {
            database.collection("users").document(userId!).updateData(["isActive":false]) { (error) in
                
                if error == nil {
                    DispatchQueue.main.async {
                        self.availabilityButton.alpha = 0
                        self.availabilityByTime.alpha = 0
                    }
                }
            }
        }
    }
    
    @IBAction func setAvailabilityClicked(_ sender: Any) {
        presentVC()
    }
    
    @IBAction func setAvailabilityByTimeClicked(_ sender: Any) {
        let timeOfDayVC = storyboard?.instantiateViewController(identifier: "timeOfDayVC") as! TimeOfDayViewController
        timeOfDayVC.modalPresentationStyle = .overCurrentContext
        present(timeOfDayVC, animated: true, completion: nil)
    }
    
    @IBAction func uploadProfilePictureTapped(_ sender: Any) {
      
        let sheet = UIAlertController(title: "Add a Photo", message: "Select a source:", preferredStyle: .alert)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {

            let cameraButton = UIAlertAction(title: "Camera", style: .default) { (_) in
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                imagePicker.modalPresentationStyle = .currentContext
                self.present(imagePicker, animated: true, completion: nil)
            }
            sheet.addAction(cameraButton)
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let libraryButton = UIAlertAction(title: "Photo Library", style: .default) { (_) in
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                imagePicker.modalPresentationStyle = .currentContext
                self.present(imagePicker, animated: true, completion: nil)
            }
            sheet.addAction(libraryButton)
        }

        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        sheet.addAction(cancelButton)
        present(sheet, animated: true, completion: nil)
    }
    
    func presentVC() {
        let vc = storyboard?.instantiateViewController(identifier: "availabilityVC") as! AvailabilityViewController
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func getUserData() {
        
        let database = Firestore.firestore()
        
        if userId != nil {
            database.collection("users").document(userId!).getDocument { (snapshot, error) in
                if error == nil && snapshot != nil {
                    if snapshot!.data() != nil {
                        let data = snapshot!.data()!
                        let firstName = data["firstname"] as! String
                        let lastName = data["lastname"] as! String
                        let phoneNumber = data["phoneNumber"] as! String
                        DispatchQueue.main.async {
                            self.firstNameTextField.text = firstName
                            self.lastNameTextField.text = lastName
                            self.phoneNumberTextField.text = phoneNumber
                        }
                    }
                }
            }
        }
    }
    
    func getUserInterests() {
       
        let database = Firestore.firestore()
        
        if userId != nil {
            database.collection("users").document(userId!).getDocument { (snapshot, error) in
                if error == nil && snapshot != nil {
                    if snapshot!.data() != nil {
                        let data = snapshot!.data()!
                        let userInterests = data["interests"] as? [String]
                        
                        if userInterests != nil {
                            DispatchQueue.main.async {
                                self.firstHobbyTextField.text = userInterests![0]
                                self.secondHobbyTextField.text = userInterests![1]
                                self.thirdHobbyTextField.text = userInterests![2]
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    // MARK: - Upload Images
    private func uploadProfileImage(_ image:UIImage) {
        
        let fileDirectory = "Profiles/" + "_" + userId! + ".jpg"
        
        let fileStorage = FileStorage()
        
        fileStorage.uploadImage(image, directory: fileDirectory) { (link) in
            
            if Auth.auth().currentUser != nil && link != nil {
                
                let database = Firestore.firestore()
                
                database.collection("users").document(self.userId!).updateData(["profilePictureUrl":link!]) { (error) in
                    if error == nil {
                        UserManager.saveImageURL(imageURL: link!)
                        Toast.show(message: "Uploaded!", bgColor: .blue, textColor: .white, labelFont: .systemFont(ofSize: 18), showIn: .top, controller: self)
                    }
                }
                
                fileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 1.0)! as NSData, fileName: self.userId!)
                
                self.setProfileImage()
            }
        }
    }
    
    func sendRequest() {
        
        let database = Firestore.firestore()
        
        if userId != nil {
            database.collection("users").document(userId!).updateData(["firstname":firstNameTextField.text!, "lastname":lastNameTextField.text!, "phoneNumber":phoneNumberTextField.text!, "fullName": firstNameTextField.text! + " " + lastNameTextField.text!]) { (error) in
                
                if error == nil {
                    Toast.show(message: "Account Data was saved!", bgColor: .systemPink, textColor: .white, labelFont: .systemFont(ofSize: 22), showIn: .top, controller: self)
                }
            }
        }
    }
    
    func update() {
        
        let database = Firestore.firestore()
        
        if userId != nil {
            database.collection("users").document(userId!).updateData(["interests":[firstHobbyTextField.text!, secondHobbyTextField.text!, thirdHobbyTextField.text!]]) { (error) in
                
                if error == nil {
                    Toast.show(message: "Hobbies were saved!", bgColor: .systemGreen, textColor: .white, labelFont: .systemFont(ofSize: 22), showIn: .top, controller: self)
                }
            }
        }
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil) // Dismiss the image picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if selectedImage != nil {
            self.uploadProfileImage(selectedImage!)
        }
        
        dismiss(animated: true, completion: nil)
    }
    

    
}

