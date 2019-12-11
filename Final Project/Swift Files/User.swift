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

class User {
    var profileImage: UIImage?
    var userName: String
    let email: String
    let uid: String

    init(userName: String , email: String, uid: String) {
        self.userName = userName
        self.uid = uid
        self.email = email
    }
    
    //In order to store information in the database it has to be in
    //a json format. This function turns the variables of a User class
    //into the appropriate format to be stored.
    func userToAny() -> Any {
      return [
        "username": userName,
        "uid": uid,
        "email": email
      ]
    }
}
