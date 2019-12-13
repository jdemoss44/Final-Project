//
//  User.swift
//  Demo Project
//
//  Created by Josh DeMoss on 12/4/19.
//  Copyright © 2019 Josh DeMoss. All rights reserved.
//

//Task 4: Creating a User Class
//It is important to note that one could sign in without a user class
//because firebase authentication stores an email and password by
//default for the login that we choose. We could retrieve the
// email and password for the current user by making the function call
//Auth.auth().curentUser, but since we want to associate a username
//with that email and password as well, we will create a class to hold
//that all authentication info and we will store that info in the database

import Foundation
import Firebase
import FirebaseStorage

class User {
    var profileImage: UIImage?
    var userName: String
    var email: String
    var bio: String
    var uid: String

    init(userName: String , email: String, uid: String) {
        profileImage = UIImage(named: "profileImage")
        self.bio = ""
        self.userName = userName
        self.uid = uid
        self.email = email
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let userName = value["username"] as? String,
            let email = value["email"] as? String,
            let bio = value["bio"] as? String,
            let uid = value["uid"] as? String
            else { return nil}
        
        self.profileImage = UIImage(named: "profileImage")
        self.userName = userName
        self.email = email
        self.bio = bio
        self.uid = uid
        
        if value["profile_image"] != nil {
            // Create a reference to the file you want to download
            let profileImageRef = Storage.storage().reference(withPath: "\(uid)/images/profile_image")

            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            profileImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
              if let error = error {
                print(error.localizedDescription)
              } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                self.profileImage = image
                }
            }
            
        }
        
    }

    func userToAny() -> Any {
      return [
        "username": userName,
         "email": email,
         "bio": bio,
        "uid": uid
      ]
    }
}
