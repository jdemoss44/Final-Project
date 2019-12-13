import Foundation
import Firebase

struct Post {
    var title: String
    var date: String
    var time: String
    var description: String
    var addedByUser: String
    
    init(title: String, date: String, time: String, description: String, addedByUser: String) {
        self.title = title
        self.date = date
        self.time = time
        self.description = description
        self.addedByUser = addedByUser
    }
    
    //Easy way to initialize a post using a retrieved snapchot of the post
    //from the database
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let title = value["title"] as? String,
            let date = value["date"] as? String,
            let time = value["time"] as? String,
            let description = value["description"] as? String,
            let addedByUser = value["addedByUser"] as? String
            else { return nil }
        
        self.title = title
        self.date = date
        self.time = time
        self.description = description
        self.addedByUser = addedByUser
    }
    
    //Functiion to translate post date into storable format
    func toAnyObject() -> Any {
      return [
        "title": title,
        "date": date,
        "time": time,
        "description": description,
        "addedByUser": addedByUser
      ]
    }
}
