//
//  ArticlesViewModel.swift
//  Unwind
//
//  Created by Alan Cao on 5/18/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import UIKit
import SDWebImage

class ArticlesViewModel {
    
    // MARK: - Properties
    
    var article: Articles
    
    var title: String {
        return article.title
    }
    
    var caption: String {
        return article.caption
    }
    
    var fullnameLabel: String {
        return article.user.fullname
    }
    
    var content: NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let attributedString = NSMutableAttributedString(string: article.content, attributes: [.paragraphStyle: paragraphStyle])
        return attributedString
    }
   
    var timestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        return formatter.string(from: article.timestamp)
    }
    
    var favoriteButtonImage: UIImage? {
        let imageName = article.isFavorited ? "favorites-filled" : "favorites"
        return UIImage(named: imageName)
    }
        
    // MARK: - Lifecycle
    
    init(article: Articles) {
        self.article = article
    }
}
