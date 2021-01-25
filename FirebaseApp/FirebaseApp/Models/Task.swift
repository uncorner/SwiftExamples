//
//  Task.swift
//  FirebaseApp
//
//  Created by denis2 on 25.01.2021.
//

import Foundation
import Firebase

struct Task {
    let title: String
    let userId: String
    let ref: DatabaseReference?
    var completed = false
    
    init(title: String, userId: String) {
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.title = snapshotValue["title"] as! String
        self.userId = snapshotValue["userId"] as! String
        self.completed = snapshotValue["completed"] as! Bool
        self.ref = snapshot.ref
    }
    
}
