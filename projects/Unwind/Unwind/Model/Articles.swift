//
//  Articles.swift
//  Unwind
//
//  Created by Alan Cao on 5/14/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import Foundation

struct Articles {
    let user: User
    let uid: String
    let title: String
    let caption: String
    let content: String
    var image: URL?
    var timestamp: Date!
    var favorites: Int
    var isFavorited: Bool = false
    
    init(user: User, uid: String, dictionary: [String: Any]) {
        self.user = user
        self.uid = uid
        
        self.title = dictionary["title"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        self.favorites = dictionary["favorites"] as? Int ?? 0
        
        if let imageURL = dictionary["imageURL"] as? String {
            guard let url = URL(string: imageURL) else { return }
            self.image = url
        }
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
