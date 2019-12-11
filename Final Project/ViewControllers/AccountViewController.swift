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
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var emailTextField: UILabel!
    var selectedImage: UIImage?
    
//View Did Load:
//**********************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

//FUNCTIONS:
//********************************
    
    @IBAction func changeProfilePhoto(_ sender: Any) {
        let alert = UIAlertController(nibName: "Change Profile Photo", bundle: .none)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let removeAction = UIAlertAction(title: "Remove", style: .default) { _ in
            self.profileImage.image = UIImage(named: "profileImage")
        }
            
        let changePictureAction = UIAlertAction(title: "Change Picture", style: .default) { _ in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            self.present(pickerController, animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(removeAction)
        alert.addAction(changePictureAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //Add function to save changes
    
    @IBAction func newClubAccount(_ sender: Any) {
        let alert = UIAlertController(title: "Register", message: "Register", preferredStyle: .alert)
        
        alert.addTextField { textUserName in
            textUserName.placeholder = "User Name"
        }
        alert.addTextField { textEmail in
            textEmail.placeholder = "Email"
        }
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Password"
        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in

            let userNameField = alert.textFields![0]
            let emailField = alert.textFields![1]
            let passwordField = alert.textFields![2]
                
            //firebase part:
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                if error == nil, user != nil {
                    let curUser = User(userName: userNameField.text!, email: user!.user.email!, uid: user!.user.uid)
                        
                    let userRef = Database.database().reference(withPath: "users/\(curUser.uid)")
                    userRef.setValue(curUser.userToAny())
                } else {
                    print("Error with Create User")
                }
            }
        }

        //Add the two actions to the alert
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        //present the alert
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func LogOutButtonPressed(_ sender: Any) {
        do {//Try to sign out -- sets Firebase user to nil
            try Auth.auth().signOut()
            //dismiss current view -- Returns to login storyboard
            self.dismiss(animated: true, completion: nil)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
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

