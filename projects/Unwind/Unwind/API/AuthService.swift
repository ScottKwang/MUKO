//
//  AuthService.swift
//  Unwind
//
//  Created by Alan Cao on 5/11/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import Firebase
import FirebaseDatabase

struct AuthService {
    static let shared = AuthService()
    
    func signInUser(email: String, password: String, completion: (AuthDataResultCallback?)) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func signUpUser(email: String, password: String, completion: (AuthDataResultCallback?)) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
}
