//
//  MenuViewController.swift
//  Final Project
//
//  Created by Josh DeMoss on 12/10/19.
//  Copyright © 2019 Josh DeMoss. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {
    
    
    @IBOutlet weak var notifications: UIStackView!
    @IBOutlet weak var account: UIStackView!
    @IBOutlet weak var about: UIStackView!
    @IBOutlet weak var posts: UIStackView!
    @IBOutlet weak var createPost: UIStackView!
    @IBOutlet weak var addClubUser: UIStackView!
    
    @IBOutlet weak var clubUserAddedNotification: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setting up tap gestures for stack
        let tapGestureNotifications = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.handleTappedNotifications))
        let tapGestureAccount = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.handleTappedAccount))
        let tapGestureAbout = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.handleTappedAbout))
        let tapGesturePosts = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.handleTappedPosts))
        let tapGestureCreatePost = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.handleTappedCreatePost))
        let tapGestureAddClubUser = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.handleTappedAddClubUser))
            
        notifications.addGestureRecognizer(tapGestureNotifications)
        account.addGestureRecognizer(tapGestureAccount)
        about.addGestureRecognizer(tapGestureAbout)
        posts.addGestureRecognizer(tapGesturePosts)
        createPost.addGestureRecognizer(tapGestureCreatePost)
        addClubUser.addGestureRecognizer(tapGestureAddClubUser)
        
        
        notifications.isUserInteractionEnabled = true
        account.isUserInteractionEnabled = true
        about.isUserInteractionEnabled = true
        posts.isUserInteractionEnabled = true
        createPost.isUserInteractionEnabled = true
        addClubUser.isUserInteractionEnabled = true
        
        // Do any additional setup after loading the view.
    }
    
    @objc func handleTappedNotifications() {
        self.performSegue(withIdentifier: "GoToNotifications", sender: nil)
    }
    @objc func handleTappedAccount() {
        self.performSegue(withIdentifier: "GoToAccount", sender: nil)
    }
    @objc func handleTappedAbout() {
        self.performSegue(withIdentifier: "GoToAbout", sender: nil)
    }
    @objc func handleTappedPosts() {
        self.performSegue(withIdentifier: "GoToPosts", sender: nil)
    }
    @objc func handleTappedCreatePost() {
        self.performSegue(withIdentifier: "GoToCreatePost", sender: nil)
    }
    @objc func handleTappedAddClubUser() {
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
                self.clubUserAddedNotification.text = "A New Club Account has been Created!"
            }
        }

        //Add the two actions to the alert
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        //present the alert
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func presentAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
