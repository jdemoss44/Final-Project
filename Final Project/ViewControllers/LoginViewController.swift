//
//  LoginViewController.swift
//  Demo Project
//
//  Created by Josh DeMoss on 12/4/19.
//  Copyright © 2019 Josh DeMoss. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //task 2: Text Fields
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    //***************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        textFieldLoginEmail.delegate = self
        textFieldLoginPassword.delegate = self
        let user = Auth.auth().currentUser
        if user != nil {
            do {
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
        }
        
        //This will perform the following code when a user signs in.
        //(When a user signs in it will perform the segue)
        Auth.auth().addStateDidChangeListener() { auth, user in
          if user != nil {
            print(user!.isAnonymous)
            print(user!.email as Any)
            self.performSegue(withIdentifier: "GoToMainNavigator", sender: nil)
            self.textFieldLoginEmail.text = nil
            self.textFieldLoginPassword.text = nil
          }
        }
    }
    
    //**************************
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -150 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func anonLoginDidTouch(_ sender: Any) {
        Auth.auth().signInAnonymously() { (authResult, error) in
            if error != nil {
                print("Error in anonymous sign in")
            }
        }
    }
    
    
    
    @IBAction func signInDidTouch(_ sender: Any) {
        
        guard //check input for textfields
          let email = textFieldLoginEmail.text,
          let password = textFieldLoginPassword.text,
          email.count > 0,
          password.count > 0
          else {
            return
        }
        
        //if input is valid, sign in
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            //If there is an error present an alert saying so
          if let error = error, user == nil {
            let alert = UIAlertController(title: "Sign In Failed",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
          }
        }
    }

    @IBAction func signUpDidTouch(_ sender: Any) {
        //Create an alert for input
        let alert = UIAlertController(title: "Register",
                                        message: "Register",
                                        preferredStyle: .alert)
        //add 3 textfields to to the newly created alert
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
        
        //Create a cancel action (basically button)
        let cancelAction = UIAlertAction(title: "Cancel",
                                                  style: .cancel)
        
        //Create a save/sign up action (button)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in

            //Reference the 3 textfields
            let userNameField = alert.textFields![0]
            let emailField = alert.textFields![1]
            let passwordField = alert.textFields![2]
            
            //firebase part:
            //Create a new user with the email an password
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                if error == nil, user != nil {
                    
                    //if no error sign in
                    Auth.auth().signIn(withEmail: self.textFieldLoginEmail.text!,
                                   password: self.textFieldLoginPassword.text!)

                    //Adding username to the database:
                    //Create a instance of user using current user and update the username properly
                    let curUser = User(userName: userNameField.text!, email: user!.user.email!, uid: user!.user.uid)
                    //get reference for where we want to store the username
                    let userRef = Database.database().reference(withPath: "users/\(curUser.uid)")
                    //store it at the reference using the proper format
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
    
}

//********************

//Makes the textfields return.
extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Testing")
        if textField == textFieldLoginEmail {
            textField.resignFirstResponder()
        }
        if textField == textFieldLoginPassword {
           textField.resignFirstResponder()
        }
        return true
    }
}
