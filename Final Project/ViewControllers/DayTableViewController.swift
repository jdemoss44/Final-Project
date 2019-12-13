//
//  FeedTableViewController.swift
//  Demo Project
//
//  Created by Josh DeMoss on 12/4/19.
//  Copyright © 2019 Josh DeMoss. All rights reserved.
//

import UIKit
import Firebase

//Task 8: Sign out (button function)

class DayTableViewController: UITableViewController {
    
    var posts: [Post] = []
    var user: User!
    
    //connecting to firebase
//    let approvedRef = Database.database().reference(withPath: "posts/approved")
    let approvedRef = Database.database().reference(withPath: "posts/requests")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize the user
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let curUser = user else { return }
            
            let userRef = Database.database().reference(withPath: "users/\(curUser.uid)")
        
            userRef.observe( .value, with: { snapshot in
                self.user = User(snapshot: snapshot)
            })
            
        }
        
        //Retrieving Posts from the Database
        approvedRef.observe(.value, with: { snapshot in
            var newPosts: [Post] = []
            for uid in snapshot.children {
                if let title = uid as? DataSnapshot {
                    for curPost in title.children {
                        if let realSnapshot = curPost as? DataSnapshot,
                            let post = Post(snapshot: realSnapshot){
                            print(post.title)
                            newPosts.append(post)
                        }
                    }
                }
            }

            self.posts = newPosts
            self.tableView.reloadData()
        })
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
       
    }

//*************************************************

    //Used for creating cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    //Creates cells using internal array of posts
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as UITableViewCell

        let post = posts[indexPath.row]
        
//        let profileImage = cell.imageView
//        profileImage!.layer.cornerRadius = 50
//        profileImage!.clipsToBounds = true
//        profileImage?.image = UIImage(named: "profileImage")!
        
        let titleLabel = cell.viewWithTag(101) as! UILabel
        let dateLabel = cell.viewWithTag(102) as! UILabel
        let timeLabel = cell.viewWithTag(103) as! UILabel
        let addedByUser = cell.viewWithTag(104) as! UILabel
        let descriptionTextView = cell.viewWithTag(105) as! UILabel
    
        titleLabel.text = post.title
        dateLabel.text = post.date
        timeLabel.text = post.time
        let userNameRef = Database.database().reference(withPath: "users/\(post.addedByUser)")
        userNameRef.observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as! NSDictionary
          let username = value["username"] as? String
            addedByUser.text = username
          }) { (error) in
            print(error.localizedDescription)
        }
        
        addedByUser.text = post.addedByUser
        descriptionTextView.text = post.description
        
        return cell
    }

    @IBAction func discoverButtonDidTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToDiscover", sender: nil)
    }
    

}
