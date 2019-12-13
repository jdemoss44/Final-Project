//
//  DiscoverTableViewController.swift
//  Final Project
//
//  Created by Josh DeMoss on 12/10/19.
//  Copyright © 2019 Josh DeMoss. All rights reserved.
//

import UIKit
import Firebase

class DiscoverTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
//    let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
//        "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
//        "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
//        "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
//        "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    var posts: [Post] = []
    var user: User!
    
    var filteredData: [Post]!
    let approvedRef = Database.database().reference(withPath: "posts/requests")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        filteredData = posts
        //initialize the user
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let curUser = user else { return }
            
            let userRef = Database.database().reference(withPath: "users/\(curUser.uid)")
        
            userRef.observe( .value, with: { snapshot in
                self.user = User(snapshot: snapshot)
            })
            
        }
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

    //gets rid of view
    @IBAction func cancelSearchDidTouch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
          
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
        
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row].title
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
                  // Get user value
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
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredData = searchText.isEmpty ? posts : posts.filter { (item: Post) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }

        tableView.reloadData()
    }
        
        //this is called when the user starts editing the search
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    
    }
        
        
    //this hides the keyboard and cancels the search
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

}
