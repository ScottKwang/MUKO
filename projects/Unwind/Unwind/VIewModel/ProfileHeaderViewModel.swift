//
//  ProfileHeaderViewModel.swift
//  Unwind
//
//  Created by Alan Cao on 5/25/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import UIKit

struct ProfileHeaderViewModel {
    let user: User
    
    var fullnameText: String {
        return user.fullname
    }
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    init(user: User) {
        self.user = user
    }
}
