//
//  ArticleService.swift
//  Unwind
//
//  Created by Alan Cao on 5/15/20.
//  Copyright © 2020 Alan Cao. All rights reserved.
//

import Firebase
import FirebaseDatabase

struct ArticleService {
    static let shared = ArticleService()
        
    func postArticle(title: String, caption: String, content: String, image: UIImage, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageReference = STORAGE_ARTICLE_IMAGES.child(fileName)
        
        storageReference.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            storageReference.downloadURL { (url, error) in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    return
                }
                guard let url = url?.absoluteString else { return }
                let values = [
                    "uid": uid,
                    "timestamp": Int(NSDate().timeIntervalSince1970),
                    "favorites": 0,
                    "title": title,
                    "caption": caption,
                    "content": content,
                    "imageURL": url
                    ] as [String : Any]
                
                REF_ARTICLES.childByAutoId().updateChildValues(values) { (error, reference) in
                    guard let articleID = reference.key else { return }
                    REF_USER_ARTICLES.child(uid).updateChildValues([articleID: 1], withCompletionBlock: completion)
                }
            }
        }
    }
    
    func fetchArticles(completion: @escaping([Articles]) -> Void) {
        var articles = [Articles]()
        REF_ARTICLES.observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchCurrentUser(uid: uid) { (user) in
                let article = Articles(user: user, uid: uid, dictionary: dictionary)
                articles.append(article)
                completion(articles)
            }
        }
    }
    
    func fetchArticles(withArticleID articleID: String, completion: @escaping(Articles) -> Void) {
        REF_ARTICLES.child(articleID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchCurrentUser(uid: uid) { (user) in
                let article = Articles(user: user, uid: uid, dictionary: dictionary)
                completion(article)
            }
        }
    }
    
    func fetchUserArticles(forUser user: User, completion: @escaping([Articles]) -> Void) {
        var articles = [Articles]()
        REF_USER_ARTICLES.child(user.uid).observe(.childAdded) { (snapshot) in
            let articleID = snapshot.key
            
            self.fetchArticles(withArticleID: articleID) { (article) in
                articles.append(article)
                completion(articles)
            }
        }
    }
    
    func favoriteArticle(article: Articles, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let favorites = article.isFavorited ? article.favorites - 1 : article.favorites + 1
        REF_USER_ARTICLES.child(uid).observe(.childAdded) { (snapshot) in
            let articleID = snapshot.key
            REF_ARTICLES.child(articleID).updateChildValues(["favorites": favorites])
            if article.isFavorited {
                REF_USER_FAVORITES.child(uid).child(articleID).removeValue { (error, reference) in
                    REF_ARTICLE_FAVORITES.child(articleID).removeValue(completionBlock: completion)
                }
            } else {
                REF_USER_FAVORITES.child(uid).updateChildValues([articleID: 1]) { (error, reference) in
                    REF_ARTICLE_FAVORITES.child(articleID).updateChildValues([uid: 1], withCompletionBlock: completion)
                }
            }
        }
    }
    
    func fetchFavorites(forUser user: User, completion: @escaping([Articles]) -> Void) {
        var articles = [Articles]()
        REF_USER_FAVORITES.child(user.uid).observe(.childAdded) { (snapshot) in
            let articleID = snapshot.key
            self.fetchArticles(withArticleID: articleID) { (likedArticle) in
                var article = likedArticle
                article.isFavorited = true
                articles.append(article)
                completion(articles)
            }
        }
    }
}
