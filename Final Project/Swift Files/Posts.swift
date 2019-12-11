//
//  Post.swift
//  Demo Project
//
//  Created by Josh DeMoss on 12/4/19.
//  Copyright © 2019 Josh DeMoss. All rights reserved.
//

import Foundation
import Firebase

struct Post {
    var topic: String
    var info: String
    var addedByUser: String
    
    init(topic: String, info: String, addedByUser: String) {
        self.topic = topic
        self.info = info
        self.addedByUser = addedByUser
    }
    
    //Easy way to initialize a post using a retrieved snapchot of the post
    //from the database
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            
            let topic = value["topic"] as? String,
            let addedByUser = value["addedByUser"] as? String,
            let info = value["info"] as? String
            else { return nil }
        
        self.topic = topic
        self.info = info
        self.addedByUser = addedByUser
    }
    
    //Functiion to translate post info into storable format
    func toAnyObject() -> Any {
      return [
        "topic": topic,
        "info": info,
        "addedByUser": addedByUser
      ]
    }
}
