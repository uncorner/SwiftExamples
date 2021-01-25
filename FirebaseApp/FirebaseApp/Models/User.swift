//
//  User.swift
//  FirebaseApp
//
//  Created by denis2 on 25.01.2021.
//

import Foundation
import Firebase

struct User {
    
    var uid: String
    var email: String
    
    init(user: Firebase.User) {
        uid = user.uid
        email = user.email!
    }
    
    
}
