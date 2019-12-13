//
//  AccountViewController.swift
//  Final Project
//
//  Created by Josh DeMoss on 12/10/19.
//  Copyright © 2019 Josh DeMoss. All rights reserved.
//

import UIKit
import Firebase


class AccountViewController: UIViewController {

//Variables:
    var isDefaultImage = true
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var emailTextField: UILabel!
    var selectedImage: UIImage?
    
    var user: User!
    
    
//View Did Load:
//**********************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        userNameTextField.delegate = self
        bioTextField.delegate = self
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        // Do any additional setup after loading the view.
        if !Auth.auth().currentUser!.isAnonymous {
            let curUser = Auth.auth().currentUser
            guard curUser != nil else {
                return
            }
            let userRef = Database.database().reference(withPath: "users/\(curUser!.uid)")
            userRef.observe( .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as! NSDictionary
                let username = value["username"] as? String
                let bio = value["bio"] as? String
                let email = value["email"] as? String
                self.userNameTextField.text = username
                self.bioTextField.text = bio
                self.emailTextField.text = email

            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        
        //initializing user
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let curUser = user else { return }
            
            let userRef = Database.database().reference(withPath: "users/\(curUser.uid)")
        
            userRef.observe( .value, with: { snapshot in
                self.user = User(snapshot: snapshot)
            })
        }
    }

//FUNCTIONS:
//********************************
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func changeProfilePhoto(_ sender: Any) {
        
        
        let alert = UIAlertController(nibName: "Change Profile Photo", bundle: .none)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let removeAction = UIAlertAction(title: "Remove", style: .default) { _ in
            self.profileImage.image = UIImage(named: "profileImage")
            self.isDefaultImage = true
        }
            
        let changePictureAction = UIAlertAction(title: "Change Picture", style: .default) { _ in
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                self.present(pickerController, animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        if !isDefaultImage {
           alert.addAction(removeAction)
        }
        alert.addAction(changePictureAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func LogOutButtonPressed(_ sender: Any) {
        let user = Auth.auth().currentUser
        do {//Try to sign out -- sets Firebase user to nil
            if user!.isAnonymous {
                user?.delete { error in
                    if let error = error {
                      print(error.localizedDescription)
                    }
                }
            }
            try Auth.auth().signOut()
            //dismiss current view -- Returns to login storyboard
            self.dismiss(animated: true, completion: nil)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
        if user!.isAnonymous {
            user?.delete { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func saveChangesDidTouch(_ sender: Any) {
//        let user = Auth.auth().currentUser!
        //saving the change to the user profile image
//        let storageRef = Storage.storage().reference(withPath: "\(user.uid)/images/profile_image")
//        if let profileImage = selectedImage,
//            let imageData = profileImage.jpegData(compressionQuality: 0.1) {

            // Upload the file to the path
//            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
//                storageRef.downloadURL { (url, error) in
//                    guard let downloadURL = url else {
//                        print("error with downloadURL")
//                        return
//                    }
//                    let profileImageRef = Database.database().reference(withPath: "users/\(user.uid)/images/profile_image")
//                    profileImageRef.setValue(["profile_image": downloadURL.absoluteString])
        
//                }
//            }
//        }
        user.userName = userNameTextField.text!
        user.bio = bioTextField.text!
        let userRef = Database.database().reference(withPath: "users/\(user.uid)")
        userRef.setValue(user.userToAny())
        
        presentAlert("Changes Saved", "Events Updated with New Information")
        
    }
    
    func presentAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
//EXTENSIONS:
// ****************************************

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImage = image
            profileImage.image = image
        }
        isDefaultImage = false;
        dismiss(animated: true, completion: nil)
    }
}

extension AccountViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            userNameTextField.becomeFirstResponder()
        }
        if textField ==  bioTextField {
           bioTextField.resignFirstResponder()
        }
        
        return true
    }
}

