//
//  MenuViewController.swift
//  Final Project
//
//  Created by Josh DeMoss on 12/10/19.
//  Copyright © 2019 Josh DeMoss. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    
    @IBOutlet weak var notifications: UIStackView!
    @IBOutlet weak var account: UIStackView!
    @IBOutlet weak var about: UIStackView!
    @IBOutlet weak var posts: UIStackView!
    @IBOutlet weak var createPost: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setting up tap gestures for stack
        let tapGestureNotifications = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.handleTappedNotifications))
        let tapGestureAccount = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.handleTappedAccount))
        let tapGestureAbout = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.handleTappedAbout))
        let tapGesturePosts = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.handleTappedPosts))
        let tapGestureCreatePost = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.handleTappedCreatePost))
        
        notifications.addGestureRecognizer(tapGestureNotifications)
        account.addGestureRecognizer(tapGestureAccount)
        about.addGestureRecognizer(tapGestureAbout)
        posts.addGestureRecognizer(tapGesturePosts)
        createPost.addGestureRecognizer(tapGestureCreatePost)
        
        notifications.isUserInteractionEnabled = true
        account.isUserInteractionEnabled = true
        about.isUserInteractionEnabled = true
        posts.isUserInteractionEnabled = true
        createPost.isUserInteractionEnabled = true
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
